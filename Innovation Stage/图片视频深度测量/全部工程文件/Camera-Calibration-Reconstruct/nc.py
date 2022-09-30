import torch as th
from torch import nn

from .... import function as fn
from ..softmax import edge_softmax
from ..utils import Identity
from ....utils import expand_as_pair


class GATConv(nn.Module):
    def __init__(self,
                 in_feats,
                 out_feats,
                 num_heads,
                 feat_drop=0.,
                 attn_drop=0.,
                 negative_slope=0.2,
                 residual=False,
                 activation=None):
        super(GATConv, self).__init__()

        self._num_heads = num_heads
        # expand_as_pair 函数可以返回一个二维元组。
        self._in_src_feats, self._in_dst_feats = expand_as_pair(in_feats)
        self._out_feats = out_feats

        if isinstance(in_feats, tuple):
            self.fc_src = nn.Linear(
                self._in_src_feats, out_feats * num_heads, bias=False)
            self.fc_dst = nn.Linear(
                self._in_dst_feats, out_feats * num_heads, bias=False)
        else:
            #全连接层
            self.fc = nn.Linear(
                self._in_src_feats, out_feats * num_heads, bias=False)


        self.attn_l = nn.Parameter(th.FloatTensor(size=(1, num_heads, out_feats)))
        self.attn_r = nn.Parameter(th.FloatTensor(size=(1, num_heads, out_feats)))
        #对所有元素中每个元素按概率更改为0
        self.feat_drop = nn.Dropout(feat_drop)
        #对所有元素中每个元素按概率更改为0
        self.attn_drop = nn.Dropout(attn_drop)
        self.leaky_relu = nn.LeakyReLU(negative_slope)
        if residual:
            if self._in_dst_feats != out_feats:
                self.res_fc = nn.Linear(
                    self._in_dst_feats, num_heads * out_feats, bias=False)
            else:
                self.res_fc = Identity()
        else:
            self.register_buffer('res_fc', None)
        self.reset_parameters()
        self.activation = activation

    #初始化参数
    def reset_parameters(self):
        """Reinitialize learnable parameters."""
        gain = nn.init.calculate_gain('relu')
        if hasattr(self, 'fc'):
            nn.init.xavier_normal_(self.fc.weight, gain=gain)
        else: # bipartite graph neural networks
            nn.init.xavier_normal_(self.fc_src.weight, gain=gain)
            nn.init.xavier_normal_(self.fc_dst.weight, gain=gain)
        nn.init.xavier_normal_(self.attn_l, gain=gain)
        nn.init.xavier_normal_(self.attn_r, gain=gain)
        if isinstance(self.res_fc, nn.Linear):
            nn.init.xavier_normal_(self.res_fc.weight, gain=gain)

    #前向传播
    def forward(self, graph, feat):
        #graph.local_scope()是为了避免意外覆盖现有的特征数据
        with graph.local_scope():
            if isinstance(feat, tuple):
                h_src = self.feat_drop(feat[0])
                h_dst = self.feat_drop(feat[1])
                feat_src = self.fc_src(h_src).view(-1, self._num_heads, self._out_feats)
                feat_dst = self.fc_dst(h_dst).view(-1, self._num_heads, self._out_feats)
            else:
                h_src = h_dst = self.feat_drop(feat)
                #Wh_i(src)、Wh_j(dst)在各head的特征组成的矩阵: (1, num_heads, out_feats)
                feat_src = feat_dst = self.fc(h_src).view(
                    -1, self._num_heads, self._out_feats)

            #Wh_i * a_l， 并将各head得到的注意力系数aWh_i相加
            el = (feat_src * self.attn_l).sum(dim=-1).unsqueeze(-1)
            #Wh_j * a_r， 并将各head得到的注意力系数aWh_j相加
            er = (feat_dst * self.attn_r).sum(dim=-1).unsqueeze(-1)
            graph.srcdata.update({'ft': feat_src, 'el': el})
            graph.dstdata.update({'er': er})
            #(a^T [Wh_i || Wh_j] = )a_l Wh_i + a_r Wh_j
            graph.apply_edges(fn.u_add_v('el', 'er', 'e'))
            #e_ij = LeakyReLU(a^T [Wh_i || Wh_j])
            e = self.leaky_relu(graph.edata.pop('e'))
            #\alpha_i,j = softmax e_ij
            graph.edata['a'] = self.attn_drop(edge_softmax(graph, e))
            #'m' = \alpha * Wh_j
            #feature = \sum(\alpha_i,j * Wh_j)
            graph.update_all(fn.u_mul_e('ft', 'a', 'm'),
                             fn.sum('m', 'ft'))
            rst = graph.dstdata['ft']

            # 残差
            if self.res_fc is not None:
                resval = self.res_fc(h_dst).view(h_dst.shape[0], -1, self._out_feats)
                rst = rst + resval

            # 激活函数
            if self.activation:
                rst = self.activation(rst)
            return rst