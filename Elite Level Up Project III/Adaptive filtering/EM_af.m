%%  基于EM算法的自适应滤波
clear all;
close all;
clc;
N = 2000;
n = 2;     
KK = 2;    %混合高斯中单高斯个数
iteration = 1000;   %迭代次数
mu1 = 1;
sigma1 = 0.6;  
V1 = normrnd(mu1,sigma1,1,N); %第一个分布的参数
mu2 = 3;
sigma2 =1;
V2 = normrnd(mu2,sigma2,1,N);%第二个分布的参数
UU = randn(n,N);
Num_slt = rand(1,N);       %0到1之间的均匀分布
alpha1 = 0.4;
alpha2 = 0.6;   %alpha即权重，在参数估计模型中即出现概率
VV = (Num_slt<0.4).*V1 + (Num_slt>0.4).* V2;%混合高斯噪声
wo = randn(n,1);
DD = wo' * UU + VV;             %目标函数
%% 绘制概率密度图
figure;
subplot(311);
[f,x1] = ksdensity(V1);
plot(x1,f);title('第一个高斯分布');
subplot(312);
[f,x2] = ksdensity(V2);
plot(x2,f);title('第二个高斯分布');
subplot(313);
[f,x3] = ksdensity(VV);
plot(x3,f);title('混合高斯分布');

%% 迭代设计初值（可任意设置）
alphak = [0.1,0.9];%权重
mi = [2,2];   %均值
ci = [0,1];   %方差
w_em = randn(n,1)
for ite =1:iteration
    ui=UU(:,ii);
    di=DD(ii);
    ei=di-w_em'*ui;
end

