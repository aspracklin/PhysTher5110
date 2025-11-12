data = load('spinalRecording.txt');
sR = 30000; % Sampling frequency
t = (1:size(data,1))/sR;

figure; 
subplot(3,1,1)
plot(t,data,'k')
xlim([0 max(t)])
xlabel('time (s)')
ylabel('$\mu$V','interpreter','latex')
title('raw signal')

subplot(3,1,2)
plot(t,abs(data),'k')
xlim([0 max(t)])
xlabel('time (s)')
ylabel('$\mu$V','interpreter','latex')
title('rectified signal')

%% moving average filter
win = 0.1*sR;
filtered_data_causal = movmean(abs(data),[win 0]);
subplot(3,1,3)
plot(t,filtered_data_causal)
xlim([0 max(t)])
xlabel('time (s)')
ylabel('$\mu$V','interpreter','latex')
title('filtered signal')
hold on

filtered_data_acausal = movmean(abs(data),[0 win]);
subplot(3,1,3)
plot(t,filtered_data_acausal)

% zero-phase
coeffs = 1/win*ones(win,1);
filtered_data_0phase_01 = filtfilt(coeffs,1,abs(data));
subplot(3,1,3)
plot(t,filtered_data_0phase_01)

win = 1*sR; 
coeffs = 1/win*ones(win,1);
filtered_data_0phase_1 = filtfilt(coeffs,1,abs(data));
subplot(3,1,3)
plot(t,filtered_data_0phase_1)

%% Autocorrelation/cross correlation
[r_AC, lags_AC] = xcorr(data,0.5*sR,'normalized');
figure;
plot(lags_AC/sR,r_AC)
xlabel('lag time (s)')
ylabel('Correlation (r)')
title('AutoCorrelation')

data2 = load('spinalRecording_chan2.txt');
[r_CC, lags_CC] = xcorr(data,data2,0.5*sR,'normalized');
figure;
plot(lags_CC/sR,r_CC)
xlabel('lag time (s)')
ylabel('Correlation (r)')
title('Cross Correlation')

%% STA 
clear; % clearing because my workspace is too full
sR = 30000; % sampling frequency
data_STA = load('spinalRecording_forSTA.txt');
stimTimes = load('stimTimes.txt');

window_size = 0.25; % plus/minus from stimulus
% window_idx = [-window_size*sR,window_size*sR];
% indeces = round(stimTimes*sR);
% t = (window_idx(1):window_idx(2))/sR;
% N = 10;
% figure;
% for i = 1:N
%     idx = window_idx+indeces(i);
%     stim_data(:,i) = data_STA(idx(1):idx(2));
%     plot(t',stim_data(:,i))
%     hold on
% end
% 
% window_length = window_idx(2) - window_idx(1) + 1;
% num_events = length(stimTimes);
% 
% for i = 1: num_events
%     idx = window_idx+indeces(i);
%     stim_data_full(:,i) = data_STA(idx(1):idx(2));
% end
% 
% plot(t',mean(stim_data_full,2),'k','LineWidth',2)

%% Try to do STA without a loop
window_pre = window_size*sR;  % e.g., 100 ms before (if fs=1000Hz)
window_post = window_size*sR; % e.g., 200 ms after
window_size_idx = window_pre + window_post + 1;

% 1. Get the indices of the windows around each trigger
num_triggers = length(stimTimes);
% Create a matrix of indices for all epochs
indices = repmat(-window_pre:window_post, num_triggers, 1) + repmat(round(stimTimes(:)*sR), 1, window_size_idx);

STA = data_STA(indices);

figure;
for i = 1:10
    plot(t,STA(i,:))
    hold on
end

plot(t,mean(STA,1),'k','LineWidth',2)
xlabel('Time from stimulus (s)')
ylabel('$\mu$V','interpreter','latex')
title('STA')