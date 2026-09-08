clc;
clear;
close all;

%% 1. Read Audio
[audio, Fs] = audioread('voice sample1.wav');

if size(audio,2) == 2
    audio = mean(audio,2);
end

%% 2. Normalize Audio
audio = audio / max(abs(audio));

%% 3. Quantization
nBits = 8;
L = 2^nBits;

quantized = round((audio + 1) * (L-1) / 2);

%% 4. PCM Encoding
binaryMatrix = dec2bin(quantized, nBits) - '0';
txBits = reshape(binaryMatrix.', [], 1);

%% 5. BPSK Modulation
txSignal = 2*txBits - 1;

%% 6. Add AWGN Noise

SNR_dB = 5;

signalPower = mean(txSignal.^2);
noisePower = signalPower / (10^(SNR_dB/10));

noise = sqrt(noisePower) * randn(size(txSignal));

rxSignal = txSignal + noise;

%% 7. BPSK Demodulation

rxBits = rxSignal > 0;

%% 8. Calculate BER

errors = sum(txBits ~= rxBits);
BER = errors / length(txBits);

fprintf('SNR = %.1f dB\n', SNR_dB);
fprintf('Total Bits = %d\n', length(txBits));
fprintf('Bit Errors = %d\n', errors);
fprintf('BER = %.6f\n', BER);

%% 9. Plot Transmitted and Received Signals

N = 100;

figure;

subplot(2,1,1);
stem(txSignal(1:N), 'filled');
title('Transmitted BPSK Signal');
xlabel('Bit Number');
ylabel('Amplitude');
ylim([-2 2]);
grid on;

subplot(2,1,2);
stem(rxSignal(1:N), 'filled');
title('Received BPSK Signal with AWGN Noise');
xlabel('Bit Number');
ylabel('Amplitude');
grid on;