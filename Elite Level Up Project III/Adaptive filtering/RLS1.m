clear  all; close all;
N=1000;
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
    mu1=0.1;mu2=0.001;mu3=mu1;

    %algorithm RLS
    lamda=1;
    Pn=eye(n)*10;
    for ii=1:N
        Err_RLS(kk,ii)=norm(wo-w_rls);
        
        un=UU(:,ii);
        dn=DD(ii);
        
        en=dn-w_rls'*un;
        kn=Pn*un/(lamda+un'*Pn*un);
        Pn=1/lamda*(Pn-kn*un'*Pn);
        w_rls=w_rls+kn*en;
    end
    Rn = UU*UU';
    rn = UU*DD';
    w_close = inv(Rn)*rn;
end
figure,hold on;
plot(log(mean(Err_RLS)),'g');
plot(log(norm(w_close-wo))*ones(1,N),'r')
