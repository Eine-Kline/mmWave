close all;
clear all;
clc;
n = 3;
m = 2;
L = 500;
A = randn(3);A=orth(A);
C = randn(m,n);
w = randn(n,L)*0.1;
v = randn(m,L)*0.1;      
X = zeros(n,L);          %实际状态值
Q = w*w'/L;
R = v*v'/L;
Pk = eye(n);
Xk = zeros(n,1);         %观测状态值，n=3，即表示Xk具有3个状态

for ii = 2:L
    X(:,ii) = A * X(:,ii-1)+w(:,ii);
    Y(:,ii) = C * X(:,ii)+v(:,ii);
    %kalman
    Pk1=A *Pk *A' + Q;
    Hk=Pk1 * C' *inv(R+C * Pk1 * C');
    Xk(:,ii) = A * Xk(:,ii-1) + Hk*(Y(:,ii) - C * A * Xk(:,ii-1));
    Pk = Pk1 - Hk * C * Pk1;
    
end

figure,hold on;
plot(X(1,:),'ro');
plot(Xk(1,:),'b');

figure,hold on;
plot(X(2,:),'ro');
plot(Xk(2,:),'b');

figure,hold on;
plot(X(3,:),'ro');
plot(Xk(3,:),'b');


