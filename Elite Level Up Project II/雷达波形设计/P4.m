function [phase,signal] = P4(N)
phase = zeros(1,N+1);
Tr = 1;
f = 1/Tr;
n = 0:0.01:Tr;
for i = 0:N
    phase(i+1) = pi/N*(i-1)^2-pi*(i-1);
end
signal = exp(1i*(2*pi*f*n+phase(1)));
len = size(phase,2);
for i = 2:len
    s = exp(1i*(2*pi*f*n+phase(i)));
    signal = [signal,s(2:end)];
end