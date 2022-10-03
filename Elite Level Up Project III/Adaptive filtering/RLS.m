clear  all; close all;clc;
N=200000;
n=8;
for kk=1:100
    wo=randn(n,1);
    UU=randn(n,N);
    VV=randn(1,N)*0.1/2;
    %VV=(randn(1,N)-0.5)*0.1;%亚高斯

    % VV2=(randn(1,N)-0.5)*0.1;%亚高斯
    % V1=randn(1,N)*0.3;V2=randn(1,N);
    % for ii=1:N
    %     aa=rand;
    %     if aa>0.9
    %         VV(ii)=V2(ii);
    %     else
    %         VV(ii)=V1(ii);
    %     end
    % end
    DD=wo'*UU+VV;
    w_lms=randn(n,1);
    w_lmf=w_lms;w_mcc=w_lms;w_rls=w_lms;
    mu1=0.0001;mu2=0.001;mu3=mu1;

    %algorithm LMS
    for ii=1:N
        Err_LMS(kk,ii)=norm(wo-w_lms);
        uk=UU(:,ii);
        dk=DD(ii);
        ek=dk-w_lms'*uk;
        w_lms=w_lms+mu1*ek*uk;
    end
    %algorithm LMF
    for ii=1:N
        Err_LMF(kk,ii)=norm(wo-w_lmf);
        uk=UU(:,ii);
        dk=DD(ii);
        ek=dk-w_lmf'*uk;
        w_lmf=w_lmf+mu2*ek^3*uk;
    end

    %algorithm MCC
    for ii=1:N
        sigma=1;
        Err_MCC(kk,ii)=norm(wo-w_mcc);
        uk=UU(:,ii);
        dk=DD(ii);
        ek=dk-w_mcc'*uk;
        w_mcc=w_mcc+mu3*exp(-ek^2/2/sigma^2)*ek*uk;
    end

    %algorithm RLS
    lamda=0.99;
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
    Rn = UU * UU';
    rn = UU * DD';
    w_close = inv(Rn) * rn;
    Err_close(kk) = norm(w_close - wo);
end
figure,hold on;
% plot(log(mean(Err_LMF)),'g')
plot(log(mean(Err_LMS)),'r');
% plot(log(mean(Err_MCC)),'b');
plot(log(mean(Err_RLS)),'g');
plot(log(mean(Err_close))* ones(1,N),'b');
legend('LMS','RLS','weinner');