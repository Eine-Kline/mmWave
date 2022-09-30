close all;clear;clc
N=1000;
n=8;
for kk=1:100
    wo=randn(n,1);
    UU=randn(n,N);
    
    
    V1=randn(1,N)*0.1;
    V2=randn(1,N)*2;
    Num_slt=rand(1,N);
    VV=(Num_slt>0.1).*V1+(Num_slt<0.1).*V2;
    DD=wo'*UU+VV;
    w_rls=randn(n,1);
    w_lms=w_rls;
    w_rmc=w_rls;
    
    %% LMS
    mu=0.01;
    for ii=1:N
        un=UU(:,ii);
        dn=DD(:,ii);
        en=dn-w_lms'*un;
        w_lms=w_lms+en*un*mu;
        err_LMS(kk,ii)=(w_lms-wo)'*(w_lms-wo);
    end
    
    %% Theoretical Mean Square Error
    aa=(1-mu)^2;
    bb=mu.^2*n*var(VV);
    Err_TH_LMS(kk)=bb/(1-aa);
    
    %% algorithm RLS
    lamda=0.99;
    Pk=eye(n)*1;
    for ii=1:N
        err_RLS(kk,ii)=(wo-w_rls)'*(wo-w_rls);
        uk=UU(:,ii);
        dk=DD(ii);
        ek=dk-w_rls'*uk;
        kn=Pk*uk/(lamda+uk'*Pk*uk);
        Pk=1/lamda*(Pk-kn*uk'*Pk);
        w_rls=w_rls+kn*ek;
        
    end
    
    %% Theoretical Mean Square Error
    Err_TH_RLS(kk)=(1-lamda)/(1+lamda)*n*var(VV);
    
    
    
    %% algorithm RMC
    Pk=eye(n)*1;
    sigma=4;
    
    %     w_rmc=w_rls;
    for ii=1:N
        err_RMC(kk,ii)=(wo-w_rmc)'*(wo-w_rmc);
        uk=UU(:,ii);
        dk=DD(ii);
        ek=dk-w_rmc'*uk;
        kn=Pk*uk/(lamda*exp(ek^2/2/sigma/sigma)+uk'*Pk*uk);
        Pk=1/lamda*(Pk-kn*uk'*Pk);
        w_rmc=w_rmc+kn*ek;
        
    end
    
    
    %% Theoretical Mean Square Error
    Gn=exp(-VV.^2/2/sigma^2);
    vG=Gn.*VV.*Gn.*VV;
    Eg=mean(Gn);
    Evg=mean(vG);
    Err_TH_RMC(kk)=(1-lamda)/(1+lamda)*n*Evg/Eg^2;
    
    
    %% 维纳解
    Rn=UU*UU';
    rn=UU*DD';
    w_close=inv(Rn)*rn;
    err_close(kk)=(w_close-wo)'*(w_close-wo);       %维纳解
end


figure,hold on;
plot(log(mean(err_LMS)),'g');
plot(log(mean(err_RLS)),'b');
plot(log(mean(err_RMC)),'r');
plot(log(mean(err_close)*ones(1,N)));
plot(log(mean( Err_TH_LMS)*ones(1,N)),'g');
plot(log(mean( Err_TH_RLS)*ones(1,N)),'b');
plot(log(mean( Err_TH_RMC)*ones(1,N)),'r');
legend('LMS','RLS','RMC','Weiner','Err_TH_LMS','Err_TH_RLS','Err_TH_RMC');
