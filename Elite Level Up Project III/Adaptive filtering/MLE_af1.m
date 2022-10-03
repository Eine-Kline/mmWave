%% 简单的极大似然自适应滤波(噪声为混合高斯噪声)
clear all;
close all;
N = 1000;
n = 8;
mu1 = 1;%第一个分布的参数
sigma1 = 2;%第一个分布的参数
mu2 = 3;%第二个分布的参数
sigma2 = 1;%第二个分布的参数
mu = 0.1;     %步长
for kk = 1:100
    UU = randn(n,N);
    VV = 0.2 * normrnd(mu1,sigma1,1,N) + 0.8 * normrnd(mu2,sigma2,1,N)    %混合高斯噪声
    wo = randn(n,1);
    DD = wo' * UU + VV;
    w = randn(n,1);      %储存最开始的oumiga值，随着迭代，w_lms等会随着迭代次数变化
%LMS
    mu = 0.1;
    w_lms = w;
    w_rls = w;
    w_mle = w;
    for ii = 1:N
       Err_LMS(kk,ii) = norm(wo - w_lms);
       di = DD(ii);
       ui = UU(:,ii);
       ei = di - w_lms' * ui;
       w_lms = w_lms + mu * ei * ui;
    end
    %RLS
        lamda=1;
        Pk=eye(n)*10;
    for ii=1:N
        Err_RLS(kk,ii)=norm(wo-w_rls);
        uk=UU(:,ii);
        dk=DD(ii);
        
        ek=dk-w_rls'*uk;
        kn=Pk*uk/(lamda+uk'*Pk*uk);
        Pk=1/lamda*(Pk-kn*uk'*Pk);
        w_rls=w_rls+kn*ek;
    end
    %MLE算法
    for ii = 1:N
        ERR_MLE(ii) = norm(wo - w_mle);
        ERR_mk1(ii) = norm(mu1 - mk1);
        ERR_mk2(ii) = norm(mu2 - mk2);
    end
end