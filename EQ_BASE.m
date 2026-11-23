clc; clear; close all;

filePath = "/Users/martintorrefiel/Documents/MATLAB/ex.wav";
[x, fs] = audioread(filePath);

% convert to mono if multichannel
if size(x,2) > 1
    x = mean(x,2);
end

N = length(x);
t = (0:N-1)/fs;

% FFT and matching frequency vector
X = fft(x);
f = (0:N-1)' * fs / N;          % 0 to fs
f = min(f, fs - f);             % fold so negative freqs mirror positive ones

% Frequency bands
low  = f < 500;
mid  = f >= 500 & f < 3000;
high = f >= 3000;

% Gains
X(low)  = 2.0 * X(low);
X(mid)  = 0.5 * X(mid);
X(high) = 1.5 * X(high);

% Back to time domain
y = real(ifft(X));
y = 0.9 * y / max(abs(y));

disp('Playing Equalized Audio');
sound(y, fs);

% Plots
figure;
subplot(2,1,1);
plot(t, x);
title("Original Audio");
xlabel('Time (s)'); ylabel('Amplitude');

subplot(2,1,2);
plot(t, y);
title("Equalized Audio");
xlabel('Time (s)'); ylabel('Amplitude');

% Spectrum comparison
figure;
Xo = fft(x);
half = 1:floor(N/2);
semilogx(f(half), 20*log10(abs(Xo(half))+eps)); hold on;
semilogx(f(half), 20*log10(abs(X(half))+eps));
legend('Original','Equalized');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
xlim([20 fs/2]); grid on;