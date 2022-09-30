%%加油
%%---------------------------
clear all;
close all;
clc;
%%线性调频信号
T=1e-5;                                  %p脉冲持续时间10us
B=4e9;                                   %线性调频信号的频带宽度30MHz
k=B/T;                                   %调频斜率
fs=2*B;
Ts=1/fs;                                 %采样频率和采样间隔
N=T/Ts;                                  %采样点数
t=linspace(0,T,N);                       %设置时间和步长
c=3e8;                                   %光速
signal=exp(j*pi*k*t.^2);                    %线性调频信号
subplot(211)
plot(t,real(signal));
xlabel('时间/s');
ylabel('幅度');
title('线性调频信号的实部');
grid on;
subplot(212)
freq=linspace(0,fs,N);
plot(freq,fftshift(abs(fftshift(fft(signal)))));
xlabel('频率/Hz');
title('spectrum');
grid on;
%%---------------------------------------------------------------------
f=k*t;                                   %信号频率     
phase = pi * k * t.^2;
freq=linspace(0,fs,N);                   %频域采样
signalfft = fftshift( fft(signal) );
%%频谱图
figure,plot( freq,abs(signalfft) ),xlabel('f /Hz'),title('Chirp信号频谱');
%% 时域匹配滤波
ht = conj( fliplr(signal) );                %时域匹配滤波为发射信号时间反褶再取共轭
signal1 = conv(signal,ht);                   %线性调频信号经过匹配滤波器后的输出(时域卷积)
N1 = N+N-1 ;                            %线性卷积后信号长度变为 N1+N2-1
t1 = linspace( 0 , T , N1);
figure;
plot( t1 , abs(signal1) );
xlabel('t /s');
ylabel('幅度');
title('chirp脉冲压缩');
%%----------------------------------------------------------------------

