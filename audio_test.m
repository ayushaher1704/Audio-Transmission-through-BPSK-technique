clc;
clear;
close all;

% Create a simple audio-like signal
Fs = 8000;              % Sampling frequency
t = 0:1/Fs:1;           % 1 second

% Simple test signal
audio = sin(2*pi*500*t);

% Plot the signal
figure;
plot(t, audio);

title('Original Audio Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;