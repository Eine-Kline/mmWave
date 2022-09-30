clear all; 
close all;
clc;
m = 5;
L = 1000;
for kk = 1:100
    wo = randn(m,1);
    UU = randn(m,L);
    V1= randn(1,L)*0.1;
    V2= randn(1,L)*2;
    Num_slt =randn(1,L);
    VV=(Num_slt>0.1).*V1+(Num_slt<0.1).*V2;
    DD = wo' * UU + VV;
% RLS
    Pn = eye(m);
    lamda = 1;
    w_rls = randn(m,1);
    store = w_rls;   %记录w_rls初始值，保证后面的w_rmc与初始值相同（因为因为迭代，w_rls会变化）
    for ii = 1:L
        Err_RLS(kk,ii) = norm(w_rls - wo);
        un = UU(:,ii);
        dn = DD(:,ii);
        en = dn - w_rls' * un;
        kn = Pn * un / (lamda + un'*Pn*un);
        Pn = 1/lamda * (Pn - kn * un' * Pn);
        w_rls = w_rls + kn * en;
    end
    Pn = eye(m);
    sigma = 2;
%     w_rmc = randn(m,1);
    w_rmc = store;
%RMC
    for ii = 1:L
        Err_RMC(kk,ii) = norm(w_rmc - wo);
        un = UU(:,ii);
        dn = DD(:,ii);
        en = dn - w_rmc' * un;
        kn = Pn * un / (lamda*exp(en^2/2/sigma/sigma) + un'*Pn*un);
        Pn = 1/lamda * (Pn - kn * un' * Pn);
        w_rmc = w_rmc + kn * en;
    end
end
Rn = UU * UU';
rn = UU * DD';
w_close = inv(Rn) * rn;
ERR = norm(w_close - wo);
figure,hold on;
plot(log(mean(Err_RLS)),'r');
plot(log(mean(Err_RMC)),'b');
plot(log(ERR) * ones(1,L),'k');
legend('RLS','RMC');