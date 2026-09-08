clc;
clear;
close all;

%% BPSK BER PERFORMANCE ANALYSIS

% SNR values to test
SNR_dB = 0:2:14;

% Number of bits
N = 1000000;

% Generate random binary data
txBits = randi([0 1], N, 1);

% BPSK Mapping
% 0 -> -1
% 1 -> +1
txSignal = 2*txBits - 1;

% Array for simulated BER
simulatedBER = zeros(size(SNR_dB));

%% Simulation for different SNR values

for i = 1:length(SNR_dB)

    % Calculate noise power
    signalPower = mean(txSignal.^2);

    noisePower = signalPower / ...
        (10^(SNR_dB(i)/10));

    % Generate AWGN noise
    noise = sqrt(noisePower) * randn(size(txSignal));

    % Received signal
    rxSignal = txSignal + noise;

    % BPSK demodulation
    rxBits = rxSignal > 0;

    % Count bit errors
    errors = sum(txBits ~= rxBits);

    % Calculate BER
    simulatedBER(i) = errors / N;

    fprintf('SNR = %2d dB   Errors = %6d   BER = %.8f\n', ...
        SNR_dB(i), errors, simulatedBER(i));

end

%% Theoretical BPSK BER

theoreticalBER = 0.5 * erfc( ...
    sqrt(10.^(SNR_dB/10)));

%% Display Results

fprintf('\n====================================\n');
fprintf('       BPSK BER ANALYSIS\n');
fprintf('====================================\n');

fprintf('Total transmitted bits = %d\n', N);

%% Plot Simulated and Theoretical BER

figure;

semilogy(SNR_dB, simulatedBER, ...
    'o-', 'LineWidth', 1.5);

hold on;

semilogy(SNR_dB, theoreticalBER, ...
    '--', 'LineWidth', 1.5);

grid on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BPSK BER: Simulated vs Theoretical');

legend('Simulated BER', 'Theoretical BER');

xlim([0 14]);
ylim([1e-6 1]);
