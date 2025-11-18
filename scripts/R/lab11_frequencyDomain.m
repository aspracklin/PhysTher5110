clear; close all; clc;
sR = 1000;
t = 0:(1/sR):(5*60);
t = t';
% 1 Hz = 2pi rad/s
wave(:,1) = 10*sin(10*2*pi*t);
wave(:,2) = 7*sin(30*2*pi*t);
wave(:,3) = 5*sin(100*2*pi*t);
signal_data = 5 + sum(wave,2);

figure;
subplot 311
plot(t,signal_data)
xlim([0 5])
xlabel('time (s)')
ylabel('signal (V)')
title('Signal')
% One side FFT
sigF = fft(signal_data);
L = size(t,1);
sigF_scaled = abs(sigF/L);
sigF_scaled(2:end) = 2*sigF_scaled(2:end);
sigF_scaled(end/2:end) = 0;
freq = sR/L*(0:L-1);
subplot 312
plot(freq,abs(sigF_scaled))
xlabel('frequency (Hz)')
ylabel('|fft|')
title('One sided FFT')
xlim([-5 150])
% Power spectral density
% autocorrelation = xcorr(signal_data,round(L/2)-1);
% PSD = fft(autocorrelation);
subplot 313
% plot(freq',abs(PSD))
plot(freq,sigF_scaled.^2)
xlim([-5 150])
title('Power Spectral Density')
xlabel('frequency (Hz)')
ylabel('[V^2/Hz]')

%% Add noise
noise = 2*randn(size(signal_data));
noisySignal = signal_data + noise;
figure; 
subplot 311
plot(t,noisySignal)
xlim([0 10])
xlabel('time (s)')
ylabel('signal (V)')
title('Signal')

% One side FFT
sigFn = fft(noisySignal);
sigFn_scaled = abs(sigFn/L);
sigFn_scaled(2:end) = 2*sigFn_scaled(2:end);
sigFn_scaled(end/2:end) = 0;
subplot 312
plot(freq,abs(sigFn_scaled))
xlim([-5 150])
xlabel('frequency (Hz)')
ylabel('|fft|')
title('One sided FFT')

% Power spectral density
% autocorrelation = xcorr(noisySignal,round(L/2)-1);
% PSDn = fft(autocorrelation);
subplot 313
plot(freq,sigFn_scaled.^2)
title('Power Spectral Density')
xlabel('frequency (Hz')
ylabel('[V^2/Hz]')
xlim([-5 150])

%% 
clear;
data = load('dat.txt');

%% 
% Using transfer function (“[b, a]”) form, create an 4th order Butterworth notch/bandstop filter to 
% remove 60Hz noise from dat.txt Center the filter’s bandstop at 60Hz, with a ±2Hz cutoff range on either side.
Fs = 30000; %Collected at 30 khz
Fc = [58, 62];
[b, a] = butter(4,Fc/(Fs/2),"stop");
filtered_data = filtfilt(b,a,data);
t = (0:1:length(data)-1)/Fs;
t = t';
figure;
subplot 411
plot(t,data)
title('raw signal')

subplot 412
plot(t,filtered_data);
title('4th order butterworth')

[b2, a2] = butter(2,Fc/(Fs/2),"stop");
filtered_data_2 = filtfilt(b2,a2,data);
subplot 413
plot(t,filtered_data_2)
title('2nd order butterworth')

% Now, use zero, pole, gain form ([z,p,k]) to create a 4th order Butterworth filter with 
% the same parameters as above. Implement this version of the filter on dat (the original one, 
% not the filtered one from 3c) using second-order sections (sos) form and as a zero-phase filter.

[z,p,k] = butter(4,Fc/(Fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_zpk_4 = filtfilt(sos, g, data);

subplot 414
plot(t,filtered_data_zpk_4)
title('4th order butterworth zpk')

figure; 
plot(t,data,'LineWidth',3)
hold on
plot(t,filtered_data_2,'LineWidth',2)
plot(t,filtered_data_zpk_4,'LineWidth',.5)

dataFFT = fft(data);
L = size(t,1);
dataFFT_scaled = abs(dataFFT/L);
dataFFT_scaled(2:end) = 2*dataFFT_scaled(2:end);
dataFFT_scaled(end/2:end) = 0;
freq = Fs/L*(0:L-1);
subplot 311
plot(freq,abs(dataFFT_scaled))
xlabel('frequency (Hz)')
ylabel('|fft|')
title('FFT data')
xlim([-5 150])

dataFFT2 = fft(filtered_data_2);
L = size(t,1);
dataFFT_scaled = abs(dataFFT2/L);
dataFFT_scaled(2:end) = 2*dataFFT_scaled(2:end);
dataFFT_scaled(end/2:end) = 0;
freq = Fs/L*(0:L-1);
subplot 312
plot(freq,abs(dataFFT_scaled))
xlabel('frequency (Hz)')
ylabel('|fft|')
title('FFT 2nd order butterworth')
xlim([-5 150])

dataFFT4 = fft(filtered_data_zpk_4);
L = size(t,1);
dataFFT_scaled = abs(dataFFT4/L);
dataFFT_scaled(2:end) = 2*dataFFT_scaled(2:end);
dataFFT_scaled(end/2:end) = 0;
freq = Fs/L*(0:L-1);
subplot 313
plot(freq,abs(dataFFT_scaled))
xlabel('frequency (Hz)')
ylabel('|fft|')
title('FFT 4th order butterworth')
xlim([-5 150])

%% Mystery song
clear;
[filename,fs]  = audioread('mysterySong_withNoise.mp3'); 
t = (0:1:length(filename)-1)/fs; t = t';
figure;
subplot 211
plot(t,filename(:,1));
xlim([0 212])
title('Channel 1')
xlabel('time (s)')
subplot 212
plot(t,filename(:,2))
xlim([0 212])
title('Channel 2')
xlabel('time (s)')

%% PSD
window_length = fs*1;
pxx1 = pwelch(filename(:,1),window_length,window_length/2,window_length,fs);
figure;
plot(1:24001,pxx1)
title('unfiltered')
% filter out peak at 1000 and 2000 and 5000

Fc1 = [998 1002];
Fc2 = [1998 2002];
Fc3 = [4998 5002];
[z,p,k] = butter(4,Fc1/(fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_stop1000 = filtfilt(sos, g, filename(:,1));
[z,p,k] = butter(4,Fc2/(fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_stop2000 = filtfilt(sos, g, filtered_data_stop1000);
[z,p,k] = butter(4,Fc3/(fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_stop5000 = filtfilt(sos, g, filtered_data_stop2000);

pxx2 = pwelch(filtered_data_stop5000(:,1),window_length,window_length/2,window_length,fs);
figure;
plot(1:24001,pxx2)
title('filtered')
clean = filtered_data_stop5000;
%%
pxxL = pwelch(filename(:,2),window_length,window_length/2,window_length,fs);
figure;
plot(1:24001,pxxL)
title('unfiltered')
% filter out peak at 121 and 183
%
Fc1 = [119 123];
Fc2 = [181 185];
[z,p,k] = butter(4,Fc1/(fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_stop121 = filtfilt(sos, g, filename(:,2));
[z,p,k] = butter(4,Fc2/(fs/2),'stop');
[sos, g] = zp2sos(z, p, k);
filtered_data_stop183 = filtfilt(sos, g, filtered_data_stop121);

pxx2 = pwelch(filtered_data_stop183,window_length,window_length/2,window_length,fs);
figure;
plot(1:24001,pxx2)
title('filtered')
clean(:,2) = filtered_data_stop183;
%%
audiowrite('mysterySong_clean.mp3',clean,fs)