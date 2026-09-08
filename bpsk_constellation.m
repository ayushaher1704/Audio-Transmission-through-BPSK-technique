%% BPSK Constellation

if ~exist('txBits','var')
    error('txBits is not available. Run the main transmission program first.');
end

bits = txBits(1:min(12,length(txBits)));

bpskSymbols = 2*bits - 1;

figure;
stem(1:length(bits), bpskSymbols, 'filled', 'LineWidth', 1.2);

title('BPSK Symbols');
xlabel('Bit Number');
ylabel('BPSK Symbol');
ylim([-1.5 1.5]);
grid on;

for k = 1:length(bits)
    text(k, bpskSymbols(k)+0.15, num2str(bits(k)), ...
        'HorizontalAlignment','center', ...
        'FontWeight','bold');
end