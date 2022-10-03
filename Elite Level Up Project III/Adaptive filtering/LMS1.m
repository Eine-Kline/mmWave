clear all; close all;

for kk = 1 : 100
    m = 5;
    L = 5000;
    wo = randn(m,1);
    UU = randn(m,L);
%     VV = randn(1,L) * 0.1;
    
    V1 = randn(1,L) * 0.1;
    V2 = randn(1,L) * 2;
    Num_slt = rand(1,L);
    VV = (Num_slt>0.1) .* V1 + (Num_slt<0.1) .* V2;
    
    DD = wo' * UU + VV;
    
    w_rls = randn(m,1);
    w_rmc = w_rls;
    w_lms = w_rls;
    %% LMS
    mu = 0.02;
    for ii = 1 : L
        un = UU(:, ii);
        dn = DD(:,ii);
        en = dn - w_lms' * un;
        w_lms = w_lms + mu * en * un;
        Err_LMS(kk,ii) = (w_lms - wo)'*(w_lms - wo);
    end
    %% Theoretical Mean Square Error
    bb = mu^2 * m * var(VV);
    aa = (1 - mu)^2;
    Err_TH_LMS(kk) = bb / (1 - aa);
    %% RLS
    Pn = eye(m)*100;
    lamd =0.99;
    w_rls = randn(m,1);
    w_rmc = w_rls;
    for ii = 1 : L
        un = UU(:, ii);
        dn = DD(:,ii);
        en = dn - w_rls' * un;
        kn = Pn * un / (lamd + un'*Pn*un);
        Pn = 1/lamd * (Pn - kn * un' * Pn);
        w_rls = w_rls + kn * en;
        Err(kk,ii) = (w_rls - wo)'*(w_rls - wo);
    end
    Rn = UU * UU';
    rn = UU * DD';
    w_close = inv(Rn) * rn;
    Err_close(kk) = (w_close - wo)'*(w_close - wo);
    Err_TH_RLS(kk) = (1 - lamd) / (1 + lamd) * m * var(VV);
    
    
    %% RMC
    Pn = eye(m)*100;
%     lamd = 1;
    sigm = 1;
    for ii = 1 : L
        un = UU(:, ii);
        dn = DD(:,ii);
        en = dn - w_rmc' * un;
        kn = Pn * un / (lamd * exp(en^2/2/sigm/sigm) + un'*Pn*un);
        Pn = 1/lamd * (Pn - kn * un' * Pn);
        w_rmc = w_rmc + kn * en;
        Err_RMC(kk,ii) = (w_rmc - wo)'*(w_rmc - wo);
    end
    Gn = exp(-VV.^2/2/sigm^2);
    vG =  Gn .* VV .* Gn .* VV;
    Eg = mean(Gn);
    EvG = mean(vG);
    Err_TH_RMC(kk) = (1 - lamd) / (1 + lamd) * m * EvG / Eg^2;
    
end
figure,hold on;
plot(log(mean(Err_LMS)),'g');
plot(log(mean(Err)),'k');
plot(log(mean(Err_RMC)),'r');
plot(log(mean(Err_close)) * ones(1,L));
plot(log(mean(Err_TH_LMS)) * ones(1,L),'g');
plot(log(mean(Err_TH_RLS)) * ones(1,L),'k');
plot(log(mean(Err_TH_RMC)) * ones(1,L),'r');
legend('LMS','RLS','RMC','Weiner','LMS_TH','RLS_TH','RMC_TH');

