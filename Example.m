% Basic Example of Compound Barker Coded Excitation with Inverse Filtering
clear, clc, close all
addpath('src') 

%  Make the encoding chip, which for these purposes will be the same as the decoding chip
f0 = 2.7e6; 
fs = 50*f0;
Ncycles = 1;
tchip = 0:1/fs:1/f0*Ncycles;
chip = sin(2*pi*f0*tchip);
Tpfs = length(chip); 

% Make the coded excitation waveform
N = 25;
code = genCompoundBarkerCode(N);
codeUpsamp = upsample(code, Tpfs);
codeUpsamp = codeUpsamp(1:end-Tpfs+1); % remove extra zeros
codedPulse = conv(chip, codeUpsamp, 'full');

% Make the Decoding Filter
M = 300; % number of points for Fourier spectrum of code
L = 256; % number of filter taps
[g, C] = genDecodingFilter(code, chip, M, L, Tpfs);

% Make the coded excitation data
target = zeros(1, 4000); target(end/2) = 1;  % point target
data = conv(target, codedPulse, 'same');

% Perform code compression
compressedPulse = pulseCompress(data', g, fs, fs);
logCompressedPulse = 20*log10(abs(hilbert(compressedPulse)));
logCompressedPulse = logCompressedPulse - max(logCompressedPulse);

% Plot
figure(1)
stem(code, 'k', 'LineWidth', 1.5)
title('Binary Code')
xlabel('Bits')
axis([0 N+1 -1.5 1.5])
set(gca, 'ytick', [-1 0 1])
set(gca, 'xtick', 0:5:25)
set(gca, 'FontSize', 14)
grid on

figure(2)
plot(tchip*1e6, chip, 'k', 'LineWidth', 1.5)
axis([0 tchip(end)*1e6 -1.5 1.5])
title('Chip')
set(gca, 'ytick', [-1 0 1])
xlabel('time (\mus)')
set(gca, 'FontSize', 14)
grid on

figure(3)
t = (0:length(codedPulse)-1)/fs;
plot(t*1e6, codedPulse, 'k', 'LineWidth', 1.5)
title('Coded Excitation Pulse')
set(gca, 'ytick', -1:1)
xlabel('time (\mus)')
set(gca, 'FontSize', 14)
grid on

figure(4)
f = linspace(-1/2, 1/2, M+1);
f = f(1:end-1);
plot(f, abs(C), 'k', 'LineWidth', 1.5)
set(gca, 'xtick', [-0.5, 0 0.5])
set(gca, 'xticklabel', {'-fs/2', '0' 'fs/2'})
xlabel('Normalized Frequency')
ylabel('FT Magnitude')
title('FT of Code')
grid on
set(gca, 'xlim', [-.5, .5])
set(gca, 'FontSize', 14)

figure(5)
plot(g, 'k', 'LineWidth', 1.5)
set(gca, 'xlim', [0, length(g)])
title('FIR Inverse Filter')
set(gca, 'FontSize', 14)
xlabel('Samples')
grid on

figure(6)
plot(logCompressedPulse, 'k', 'LineWidth', 1.25), hold on 
ylabel('Amplitude (dB)')
xlabel('Samples')
grid on
title('Compressed Pulse')
set(gca, 'FontSize', 14)