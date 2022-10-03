function [phase,signal] = P1(N)
phase = zeros(N);%长度为N的相位
Tr = 1;%码长度
f = 1/Tr;%码率
n = 0:0.01:Tr;%采样率100Hz
for i = 1:N
    for j = 1:N
        phase(i,j) = -(pi/N)*(N-(2*j-1))*((j-1)*N+i-1);%更新
    end
end
phase = reshape(phase,[1,N^2]);
signal = exp(1i*(2*pi*f*n+phase(1)));
len = size(phase,2);
for i = 2:len
    s = exp(1i*(2*pi*f*n+phase(i)));
    signal = [signal,s(2:end)];
end