clc;
clear;
close all;

%% 1. Read Audio
[audio, Fs] = audioread('voice sample1.wav');

% Convert stereo to mono
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

% Convert each sample's 8 bits into a sequential bit stream
txBits = reshape(binaryMatrix.', [], 1);
%% 5. BPSK Modulation
txSignal = 2*txBits - 1;

%% 6. Add AWGN Noise
SNR_dB = 5 ;

signalPower = mean(txSignal.^2);
noisePower = signalPower / (10^(SNR_dB/10));

noise = sqrt(noisePower) * randn(size(txSignal));

rxSignal = txSignal + noise;

%% 7. BPSK Demodulation

rxBits = rxSignal > 0;

%% 8. Calculate BER

errors = sum(txBits ~= rxBits);
BER = errors / length(txBits);

fprintf('\n----- TRANSMISSION RESULTS -----\n');
fprintf('SNR = %.1f dB\n', SNR_dB);
fprintf('Total Bits = %d\n', length(txBits));
fprintf('Bit Errors = %d\n', errors);
fprintf('BER = %.6f\n', BER);

%% 9. Convert Received Bits Back to PCM

% Arrange bits into groups of 8
rxMatrix = reshape(rxBits, nBits, []).';

% Convert binary groups to decimal values
weights = 2.^(nBits-1:-1:0);

rxQuantized = rxMatrix * weights';

%% 10. Reconstruct Audio

rxAudio = (2 * rxQuantized / (L-1)) - 1;
%% CHECK RECOVERED AUDIO

fprintf('\n----- AUDIO CHECK -----\n');

fprintf('Original min = %.4f\n', min(audio));
fprintf('Original max = %.4f\n', max(audio));

fprintf('Recovered min = %.4f\n', min(rxAudio));
fprintf('Recovered max = %.4f\n', max(rxAudio));

fprintf('Maximum difference = %.6f\n', ...
    max(abs(audio - rxAudio)));

fprintf('Mean squared error = %.10f\n', ...
    mean((audio - rxAudio).^2));

%% 11. Plot Original and Recovered Audio

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

%% 12. Play Original Audio

disp('Playing ORIGINAL audio...');
sound(audio, Fs);

pause(length(audio)/Fs + 1);

%% 13. Play Recovered Audio

disp('Playing RECOVERED audio...');
sound(rxAudio, Fs);