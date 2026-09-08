%% BPSK MODULATION

clc;

% Check if txBits already exists
if ~exist('txBits','var')

    % Run PCM encoding to generate transmitted bits
    pcm_encoding;

end

% Make sure txBits was created
if ~exist('txBits','var')
    error('txBits was not created. Check pcm_encoding.m');
end

% BPSK Mapping
% 1 -> +1
% 0 -> -1
bpskSymbols = 2*txBits - 1;

% Display first 20 transmitted bits
disp(' ');
disp('----- BPSK MODULATION -----');

disp('First 20 transmitted bits:');
disp(txBits(1:20));

% Display corresponding BPSK symbols
disp('Corresponding BPSK symbols:');
disp(bpskSymbols(1:20));

% Display number of bits
fprintf('Total transmitted bits = %d\n', length(txBits));

% Plot first 100 BPSK symbols
figure;

plotBits = min(100,length(bpskSymbols));

stem(1:plotBits, bpskSymbols(1:plotBits), ...
    'filled','LineWidth',1.2);

title('BPSK Symbols');
xlabel('Bit Number');
ylabel('BPSK Symbol');

ylim([-1.5 1.5]);
yticks([-1 0 1]);

grid on;