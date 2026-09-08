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

% Convert audio from [-1,1] to [0,255]
quantized = round((audio + 1) * (L-1) / 2);

%% 4. Convert Quantized Samples to Binary
binaryMatrix = dec2bin(quantized, nBits) - '0';

% Convert matrix into one long stream of bits
txBits = binaryMatrix(:);

%% 5. Display Results

fprintf('Original samples = %d\n', length(audio));
fprintf('Number of bits per sample = %d\n', nBits);
fprintf('Total transmitted bits = %d\n', length(txBits));

disp('First 10 quantized samples:');
disp(quantized(1:10));

disp('Binary representation of first 10 samples:');
disp(binaryMatrix(1:10,:));

%% 6. Plot Quantized Signal
figure;

plot(quantized);

title('8-bit Quantized Audio Signal');
xlabel('Sample Number');
ylabel('Quantized Level');
grid on;