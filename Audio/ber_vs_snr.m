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

%% 3. 8-bit Quantization
nBits = 8;
L = 2^nBits;

quantized = round((audio + 1) * (L-1) / 2);

%% 4. PCM Encoding
binaryMatrix = dec2bin(quantized, nBits) - '0';

% Correct sample-by-sample bit ordering
txBits = reshape(binaryMatrix.', [], 1);

%% 5. BPSK Modulation
txSignal = 2*txBits - 1;

%% 6. SNR Range
SNR_values = 0:2:20;

BER_values = zeros(size(SNR_values));
error_values = zeros(size(SNR_values));

%% 7. Test Each SNR

rng(1);

for k = 1:length(SNR_values)

    SNR_dB = SNR_values(k);

    signalPower = mean(txSignal.^2);
    noisePower = signalPower / (10^(SNR_dB/10));

    noise = sqrt(noisePower) * randn(size(txSignal));

    rxSignal = txSignal + noise;

    %% BPSK Demodulation
    rxBits = rxSignal > 0;

    %% Calculate Errors
    errors = sum(txBits ~= rxBits);

    BER_values(k) = errors / length(txBits);
    error_values(k) = errors;

    fprintf('SNR = %2d dB   Errors = %6d   BER = %.8f\n', ...
        SNR_dB, errors, BER_values(k));

end

%% 8. Display Total Bits

fprintf('\nTotal transmitted bits = %d\n', length(txBits));

%% 9. BER vs SNR Graph

figure;

semilogy(SNR_values, BER_values, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

grid on;

title('BER vs SNR for BPSK Audio Transmission');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

%% 10. Theoretical BPSK BER

EbN0_linear = 10.^(SNR_values/10);

theoretical_BER = 0.5 * erfc(sqrt(EbN0_linear));

%% 11. Compare Simulated and Theoretical BER

figure;

semilogy(SNR_values, BER_values, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

hold on;

semilogy(SNR_values, theoretical_BER, '--', ...
    'LineWidth', 1.5);

grid on;

title('BPSK BER: Simulated vs Theoretical');

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

legend('Simulated BER', 'Theoretical BER');

hold off;
