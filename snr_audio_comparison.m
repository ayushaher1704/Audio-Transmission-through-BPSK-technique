clc;
clear;
close all;

%% 1. Read Audio
[audio, Fs] = audioread('voice sample1.wav');

% Convert stereo to mono
if size(audio,2) == 2
    audio = mean(audio,2);
end

% Normalize
audio = audio / max(abs(audio));

%% 2. PCM Encoding
nBits = 8;
L = 2^nBits;

quantized = round((audio + 1) * (L-1) / 2);

binaryMatrix = dec2bin(quantized, nBits) - '0';

% Create one continuous bit stream
txBits = reshape(binaryMatrix.', [], 1);

%% 3. BPSK Modulation
txSignal = 2*txBits - 1;

%% 4. SNR Values
SNR_values = [5 10 15 20];

BER_values = zeros(size(SNR_values));
MSE_values = zeros(size(SNR_values));

%% 5. Test Different SNR Values

for k = 1:length(SNR_values)

    SNR_dB = SNR_values(k);

    % Calculate noise power
    signalPower = mean(txSignal.^2);
    noisePower = signalPower / (10^(SNR_dB/10));

    % Generate AWGN
    noise = sqrt(noisePower) * randn(size(txSignal));

    % Received signal
    rxSignal = txSignal + noise;

    %% BPSK Demodulation
    rxBits = rxSignal > 0;

    %% BER Calculation
    errors = sum(txBits ~= rxBits);
    BER = errors / length(txBits);

    BER_values(k) = BER;

    %% PCM Decoding
    rxMatrix = reshape(rxBits, nBits, []).';

    weights = 2.^(nBits-1:-1:0);

    rxQuantized = rxMatrix * weights';

    %% Audio Reconstruction
    rxAudio = (2 * rxQuantized / (L-1)) - 1;

    %% MSE
    MSE = mean((audio - rxAudio).^2);

    MSE_values(k) = MSE;

    %% Display Results
    fprintf('\nSNR = %d dB\n', SNR_dB);
    fprintf('Bit Errors = %d\n', errors);
    fprintf('BER = %.8f\n', BER);
    fprintf('MSE = %.10f\n', MSE);

end

%% 6. Final Comparison Table

fprintf('\n============================================\n');
fprintf('       SNR vs AUDIO QUALITY RESULTS\n');
fprintf('============================================\n');

fprintf(' SNR(dB)        BER             MSE\n');
fprintf('--------------------------------------------\n');

for k = 1:length(SNR_values)

    fprintf('   %2d       %.8f       %.10f\n', ...
        SNR_values(k), BER_values(k), MSE_values(k));

end

%% 7. Plot BER vs SNR

figure;

semilogy(SNR_values, BER_values, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

grid on;

title('BER vs SNR for BPSK');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

%% 8. Plot MSE vs SNR

figure;

semilogy(SNR_values, MSE_values, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

grid on;

title('Audio Reconstruction Error vs SNR');
xlabel('SNR (dB)');
ylabel('Mean Squared Error (MSE)');