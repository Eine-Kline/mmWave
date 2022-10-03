function [sequence,M_phase,signal] = M_sequence(g)
% g = [0 0 0 1 1 1 0 1];
Tr = 1;
f = 1/Tr;
n = 0:0.01:Tr;
m = size(g,2);
N = 2.^m-1;
register = [zeros(1,m-1) 1];  %移位寄存器的初始状态
new_register = zeros(1,m);
sequence = zeros(1,N+1);
M_phase = zeros(1,N+1);
sequence(1) = register(m);
for i=2:N
    new_register(1) = mod(sum(g.*register),2); %移存器与反馈系数进行模2加，更新移存器第1个数
    for j = 2:m
        new_register(j) = register(j-1); %更新移存器其他数
    end
    register = new_register;
    sequence(i) = register(m);  %输出
end
for i = 1:N
   if sequence(i) == 1
   M_phase(i) = 0;
   else
   M_phase(i) = pi;
   end
end
signal = sin(2*pi*f*n+phase(1));
len = size(sequence,2);
for i = 2:len
    s = sin(2*pi*f*n+phase(i));
    signal = [signal,s(2:end)];
end