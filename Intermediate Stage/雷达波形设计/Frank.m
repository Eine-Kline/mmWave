function [sequence,phase,signal] = Frank(N)
A = zeros(N);
phase = zeros(1,N^2);
Tr = 1;
f = 1/Tr;
n = 0:0.01:Tr;
for i = 2:N
    for j = 2:N
        A(i,j) = (i-1)*(j-1);
    end
end
sequence = mod(reshape(A,[1,N^2]),N);
for i = 1:N^2
    phase(i) = 2*pi*sequence(i)/N;
end
signal = exp(1i*(2*pi*f*n+phase(1)));
len = size(sequence,2);
for i = 2:len
    s = exp(1i*(2*pi*f*n+phase(i)));
    signal = [signal,s(2:end)];
end