clc;
clear;
close all;

%% =========================================================
%       BPSK DIGITAL AUDIO COMMUNICATION SYSTEM
% ==========================================================

%% 1. AUDIO INPUT

[audio, Fs] = audioread('Audio/voice sample1.wav');

% Convert stereo audio to mono
if size(audio,2) == 2
    audio = mean(audio,2);
end

% Normalize audio
audio = audio / max(abs(audio));

fprintf('\n===== AUDIO INFORMATION =====\n');
fprintf('Sampling Frequency = %d Hz\n', Fs);
fprintf('Number of Samples  = %d\n', length(audio));
fprintf('Audio Duration     = %.2f seconds\n', length(audio)/Fs);


%% 2. PCM ENCODING

nBits = 8;
L = 2^nBits;

% Quantization
quantized = round((audio + 1) * (L-1) / 2);

% Convert samples to binary
binaryMatrix = dec2bin(quantized, nBits) - '0';

% Create serial bit stream
txBits = reshape(binaryMatrix.', [], 1);

fprintf('\n===== PCM ENCODING =====\n');
fprintf('Bits per sample = %d\n', nBits);
fprintf('Total transmitted bits = %d\n', length(txBits));


%% 3. BPSK MODULATION

% 0 -> -1
% 1 -> +1
txSymbols = 2*txBits - 1;

fprintf('\n===== BPSK MODULATION =====\n');
fprintf('0 is mapped to -1\n');
fprintf('1 is mapped to +1\n');


%% 4. BPSK CARRIER GENERATION

% Use only first 12 bits for a clean waveform display
displayBits = txBits(1:12);

Rb = 1000;          % Bit rate
Fc = 4000;          % Carrier frequency
samplesPerBit = 100;

Tb = 1/Rb;

tBit = (0:samplesPerBit-1) / (Rb*samplesPerBit);

bpskWaveform = [];

for k = 1:length(displayBits)

    if displayBits(k) == 1
        carrier = cos(2*pi*Fc*tBit);
    else
        carrier = -cos(2*pi*Fc*tBit);
    end

    bpskWaveform = [bpskWaveform carrier];

end

tWave = (0:length(bpskWaveform)-1) / (Rb*samplesPerBit);


%% 5. TRANSMISSION THROUGH AWGN CHANNEL

SNR_dB = 10;

signalPower = mean(txSymbols.^2);

noisePower = signalPower / (10^(SNR_dB/10));

noise = sqrt(noisePower) * randn(size(txSymbols));

rxSignal = txSymbols + noise;


%% 6. BPSK DEMODULATION

rxBits = rxSignal > 0;

fprintf('\n===== BPSK RECEIVER =====\n');
fprintf('SNR = %.1f dB\n', SNR_dB);


%% 7. BER CALCULATION

errors = sum(txBits ~= rxBits);

BER = errors / length(txBits);

fprintf('\n===== TRANSMISSION RESULTS =====\n');
fprintf('SNR = %.1f dB\n', SNR_dB);
fprintf('Total Bits = %d\n', length(txBits));
fprintf('Bit Errors = %d\n', errors);
fprintf('BER = %.8f\n', BER);


%% 8. PCM DECODING

% Arrange received bits into groups of 8
rxMatrix = reshape(rxBits, nBits, []).';

% Binary weights
weights = 2.^(nBits-1:-1:0);

% Convert binary back to decimal
rxQuantized = rxMatrix * weights';


%% 9. AUDIO RECONSTRUCTION

rxAudio = (2 * rxQuantized / (L-1)) - 1;


%% 10. AUDIO QUALITY CHECK

maximumDifference = max(abs(audio - rxAudio));

MSE = mean((audio - rxAudio).^2);

fprintf('\n===== AUDIO CHECK =====\n');
fprintf('Original minimum = %.4f\n', min(audio));
fprintf('Original maximum = %.4f\n', max(audio));

fprintf('Recovered minimum = %.4f\n', min(rxAudio));
fprintf('Recovered maximum = %.4f\n', max(rxAudio));

fprintf('Maximum difference = %.6f\n', maximumDifference);
fprintf('Mean squared error = %.10f\n', MSE);


%% 11. ORIGINAL VS RECOVERED AUDIO

t = (0:length(audio)-1) / Fs;

figure;

subplot(2,1,1);
plot(t, audio);
title('Original Audio Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t, rxAudio);
title('Recovered Audio Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;


%% 12. BPSK SYMBOL DISPLAY

figure;

stem(1:12, txSymbols(1:12), 'filled');

title('BPSK Symbols');
xlabel('Bit Number');
ylabel('BPSK Symbol');

ylim([-1.5 1.5]);
grid on;


% Display bit values
for k = 1:12
    text(k, txSymbols(k) + 0.15, ...
        num2str(txBits(k)), ...
        'HorizontalAlignment','center', ...
        'FontWeight','bold');
end


%% 13. ACTUAL BPSK CARRIER WAVEFORM

figure;

plot(tWave, bpskWaveform, 'LineWidth', 1.2);

hold on;

% Draw bit boundaries
for k = 1:13
    x = (k-1)*Tb;
    xline(x, '--');
end

% Display bits
for k = 1:12

    centerTime = (k-0.5)*Tb;

    text(centerTime, 1.12, ...
        num2str(displayBits(k)), ...
        'HorizontalAlignment','center', ...
        'FontWeight','bold');

end

title('Actual BPSK Modulated Carrier');

xlabel('Time (seconds)');
ylabel('Amplitude');

ylim([-1.25 1.3]);
xlim([0 12*Tb]);

grid on;

legend('BPSK Signal');


%% 14. RECEIVED SIGNAL WITH NOISE

figure;

stem(1:100, rxSignal(1:100), 'filled');

hold on;

yline(0, '--');

title('Received BPSK Signal with AWGN Noise');

xlabel('Bit Number');
ylabel('Amplitude');

grid on;


%% 15. PLAY ORIGINAL AUDIO

disp(' ');
disp('Playing ORIGINAL audio...');

sound(audio, Fs);

pause(length(audio)/Fs + 1);


%% 16. PLAY RECOVERED AUDIO

disp('Playing RECOVERED audio...');

sound(rxAudio, Fs);


%% =========================================================
%                    END OF SYSTEM
% ==========================================================