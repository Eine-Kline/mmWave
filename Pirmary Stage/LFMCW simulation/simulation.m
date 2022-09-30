close all;clc;
f0 = 1e6;%1M
c = 3e8;%光速
B = 1e2;%带宽
Slope = 4e2;%斜率
Tr = 2*B/Slope;%上升时间
fs = 8e3;%采样率
n = 0:1/fs:Tr;%点数序列
N = Tr*fs;%采样点数
f1 =-B+ Slope*n;%频率
phase = -B*n+Slope*n.^2/2;%相位
figure();
plot(f1);
title('LMF时频域');
ylabel('f/Hz');
xlabel('t/us');

signal = exp(2i*pi*phase);
figure();
plot(real(signal));%信号
title('LFM Signal(real)');
fft_signal = fft(signal);
ylabel('Amplitude')
xlabel('time')
axis([0,4000,-1,1])
figure;
plot(imag(signal));%信号
title('LFM Signal(image)');
ylabel('Amplitude')
xlabel('time')
axis([0,4000,-1,1])

figure();
f = -fs/2:fs/N:fs/2;
plot(f,abs(fftshift(fft_signal)));%信号频谱
title('Signal spectrum');
ylabel('Amplitude')
xlabel('frequence')



% Rmax = 10;
% R = 0:0.1:Rmax;
% tao = 2*R/c;
% num_tao = size(tao,2);
% Vmax = 5;
% V = -Vmax:0.1:Vmax; 
% fd = 2*V*f0/c;
% num_fd = size(fd,2);
% X = zeros(2*N+1,num_fd);
% for j=1:num_fd
%   X(:,j)=conv(signal,conj(fliplr(signal).*exp(-1i*2*pi*fd(j)*(1:N+1))));
% end
[X] = ambiguity (signal);
figure()
mesh(abs(X));
figure();
contour(abs(X));
ylabel('时延')
xlabel('频偏')
% axis([0,1000,0,400])
%脉冲压缩
compressed_signal = conv(signal,conj(fliplr(signal)));
figure();
plot(20*log10(abs(compressed_signal)/max(abs(compressed_signal))));
figure();
plot(abs(X(:,50)))
% 
% 
% %%
% %线性调频脉冲压缩
% 
% close all;clc;
% f0 = 1e6;
% Slope = 1e9;
% fs = 4e9;
% Tr = 1e-4;
% n = 0:1/fs:Tr;
% N = Tr*fs;
% phase = f0*n+Slope*n.^2/2;
% A = 1;
% signal = exp(1j*2*pi*phase);
% c = 3e8;
% % B = 1e2;
% % Slope = 4e2;
% % Tr = 2*B/Slope;
% % fs = 8e2;
% % n = 0:1/fs:Tr;
% % N = Tr*fs;
% % phase = -B*n+Slope*n.^2/2;
% figure();
% plot(phase);
% % signal = cos(2*pi*phase);
% figure(1);
% plot(real(signal));
% title('LFM Signal');
% fft_signal = fft(signal);
% figure(2);
% f = 0:fs/N:fs;
% plot(abs(fft_signal));
% title('Signal spectrum');
% % Rmax = 10;
% % R = 0:0.1:Rmax;
% % tao = 2*R/c;
% % num_tao = size(tao,2);
% Vmax = 5;
% V = -Vmax:0.1:Vmax; 
% fd = 2*V*f0/c;
% num_fd = size(fd,2);
% X = zeros(2*N+1,num_fd);
% for j=1:num_fd
%   X(:,j)=conv(signal,conj(fliplr(signal).*exp(-1i*2*pi*fd(j)*(1:N+1))));
% end
% figure(3)
% mesh(abs(X));
% figure(4);
% contour(abs(X));
% %脉冲压缩
% compressed_signal = conv(signal,conj(fliplr(signal)));
% figure(5);
% plot(20*log10(abs(compressed_signal)/max(abs(compressed_signal))));
% 
% 
% 
% %%
% %Frank码
% function [sequence,phase,signal] = Frank(N)
% A = zeros(N);
% phase = zeros(1,N^2);
% Tr = 1;
% f = 1/Tr;
% n = 0:0.01:Tr;
% for i = 2:N
%     for j = 2:N
%         A(i,j) = (i-1)*(j-1);
%     end
% end
% sequence = mod(reshape(A,[1,N^2]),N);
% for i = 1:N^2
%     phase(i) = 2*pi*sequence(i)/N;
% end
% signal = exp(1i*(2*pi*f*n+phase(1)));
% len = size(sequence,2);
% for i = 2:len
%     s = exp(1i*(2*pi*f*n+phase(i)));
%     signal = [signal,s(2:end)];
% end
% end
