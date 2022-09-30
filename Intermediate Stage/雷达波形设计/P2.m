function [phase,signal] = P2(N)
phase = zeros(N);
Tr = 1;
f = 1/Tr;
n = 0:0.01:Tr;
for i = 1:N
    for j = 1:N
        phase(i,j) = ((pi/2)*(N-1)/N-pi*(i-j)/N)*(N+1-2*j);
    end
end
phase = reshape(phase,[1,N^2]);
signal = exp(1i*(2*pi*f*n+phase(1)));
len = size(phase,2);
for i = 2:len
    s = exp(1i*(2*pi*f*n+phase(i)));
    signal = [signal,s(2:end)];
end