close all;
clc;

t=1:200;              %设置时间
Ts=0.01;              %
T_length=size(t,2);   

Orders=2;                    % X(t)=a0*t+a1*t+a2*t^2+a3*t^3
Timesize=4;                    % timesize

T=zeros(Timesize,Orders);

for n=1:Timesize
    for m=1:Orders
        T(n,m)=(n*Ts)^(m-1);
    end
end

T_temp=inv(T'*T)*T';

X_real=sin(4*t*Ts);
Y_real=cos(2*t*Ts);
% figure(1);
plot(X_real,Y_real);hold on

X_obser=X_real+0.03*randn(1,T_length);
Y_obser=Y_real+0.03*randn(1,T_length);
% figure(2);
plot(X_obser,Y_obser,'go');hold on

X_filter=zeros(1,T_length);
Y_filter=zeros(1,T_length);

X_filter1=zeros(1,T_length);
Y_filter1=zeros(1,T_length);

alpha_X=zeros(Orders,1);
alpha_Y=zeros(Orders,1);

for i=1:T_length-Timesize-1
    alpha_X=T_temp*(X_obser(i:i+Timesize-1))';
    X_filter(i:i+Timesize-1)= T*alpha_X; 
    alpha_Y=T_temp*(Y_obser(i:i+Timesize-1))';
    Y_filter(i:i+Timesize-1)= T*alpha_Y;
end
% figure(3);
plot(X_filter,Y_filter,'r*');hold on




