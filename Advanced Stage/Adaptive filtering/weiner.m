m=5;
n=1000;
uu=randn(m,n);
wo=randn(m,1);
vv=randn(1,n)*0.1;
dd=wo'*uu+vv;
mu=0.1;
A=uu';
b=dd';
w_weiner=pinv(A)*b;
w=randn(m,1);
for ii=1:n
    UU=uu(:,ii);
    DD=dd(:,ii);
    ek=DD-w'*UU;
    w=w+mu*ek*UU;
    Err1(ii)=log(norm(w-wo));
    Err2(ii)=log(norm(w_weiner-wo));
end    
figure,plot(Err1,'r');
hold on
plot(Err2,'b')
