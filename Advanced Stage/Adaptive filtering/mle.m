clear all;
close all;
N = 2000;
n = 8;
UU = randn(n,N);
VV = randn(1,N)  + 1;
wo = randn(n,1);
DD = wo' * UU + VV;

%%LMS
mu = 0.01;
w_lms = randn(n,1);
w_ml = w_lms;
for ii = 1:N
    ERR_LMS(ii) = norm(wo - w_lms);
    di = DD(ii);
    ui = UU(:,ii);
    ei = di - w_lms' * ui;
    w_lms = w_lms + mu * ei * ui;
end
figure;
plot(log(ERR_LMS));title('ERR LMS')

%%ML
mk = 0.5;
ck = 1;
for ii = 1:N
    ERR_ML(ii) = norm(wo - w_ml);
    ERR_mk(ii) = norm(mean(VV) - mk);
    ERR_ck(ii) = norm(std(VV) - ck);
    di = DD(ii);
    ui = UU(:,ii);
    ei = di - w_ml' * ui;
    w_ml = w_ml + mu * (1/ck)^2 *(ei-mk) * ui;
    mk = mk + mu * (1/ck)^2 *(ei-mk);
    ck = ck + mu * ((ei-mk)^2/(ck)^3 - 1/ck);
end
figure,plot(log(ERR_ML));title('ERR ML');
figure,plot(log(ERR_mk));title('ERR mk');
figure,plot(log(ERR_ck));title('ERR ck');

% [mean(ERR_LMS(end/2:end)) mean(ERR_ML(end/2:end))]