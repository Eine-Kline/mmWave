%% 简单的极大似然自适应滤波(噪声为高斯白噪声)
clear all;
close all;
N = 5000;
n = 8;
for kk = 1:2
    UU = randn(n,N);
    VV = randn(1,N)  + 1;     %单个高斯噪声
    wo = randn(n,1);
    DD = wo' * UU + VV;
    w = randn(n,1);      %储存最开始的oumiga值，随着迭代，w_lms等会随着迭代次数变化
%LMS
    mu = 0.01;
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
%MLE
miu = 0.5;     %均值
sigma = 0.5;   %标准差
   for ii = 1:N
       if ii == 1000
           mu = 0.01;
       end
       if ii == 1500
           mu = 0.005;
       end
       if ii == 3000
           mu = 0.001;
       end
       Err_MLE(kk,ii) = norm(wo - w_mle);
       di = DD(ii);
       ui = UU(:,ii);
       ei = di - w_mle' * ui;
       w_mle = w_mle + mu*(1/sigma)^2* (ei-miu) * ui;
       miu = miu + mu * (1/sigma)^2*(ei- miu);
       sigma = sigma + mu * ((ei-miu)^2/(sigma)^3 - 1/sigma);
       S(kk,ii) = sigma;
       M(kk,ii) = miu;
   end
end
figure,hold on;
plot(log(mean(Err_LMS)),'g');
plot(log(mean(Err_RLS)),'r');
plot(log(mean(Err_MLE)),'b');
plot((mean(S)), 'p'); 
plot((mean(M)), 'k');
legend('LMS','RLS','MLE')



