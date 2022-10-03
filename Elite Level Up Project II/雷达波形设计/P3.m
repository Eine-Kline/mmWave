function [phase,signal] = P3(N)
phase = zeros(1,N);
Tr = 1;
f = 1/Tr;
n = 0:0.01:Tr;
for i = 1:N
    phase(i) = pi/N*i^2;
end
signal = exp(1i*(2*pi*f*n+phase(1)));
len = size(phase,2);
for i = 2:len
    s = exp(1i*(2*pi*f*n+phase(i)));
    signal = [signal,s(2:end)];
end