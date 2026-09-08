clc;
clear;
close all;

%% Read the voice file
[audio, Fs] = audioread('voice sample1.wav');

%% Convert stereo audio to mono
if size(audio,2) == 2
    audio = mean(audio,2);
end

%% Display information
fprintf('Sampling Frequency = %d Hz\n', Fs);
fprintf('Number of Samples = %d\n', length(audio));
fprintf('Duration = %.2f seconds\n', length(audio)/Fs);

%% Create time axis
t = (0:length(audio)-1)/Fs;

%% Plot original voice
figure;
plot(t, audio);

title('Original Voice Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;

%% Play voice
disp('Playing original voice...');
sound(audio, Fs);