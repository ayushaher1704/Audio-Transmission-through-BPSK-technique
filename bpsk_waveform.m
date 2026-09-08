%% BPSK WAVEFORM VISUALIZATION

clc;
close all;

%% 1. Check transmitted bits

if ~exist('txBits','var')
    error('txBits not found. Run pcm_encoding.m first.');
end

%% 2. Find a good section containing both 0 and 1

windowSize = 12;
startIndex = 1;

for k = 1:(length(txBits)-windowSize)

    testBits = txBits(k:k+windowSize-1);

    if any(testBits == 0) && any(testBits == 1)

        transitions = sum(testBits(1:end-1) ~= testBits(2:end));

        if transitions >= 3
            startIndex = k;
            break;
        end
    end
end

% Select bits for display
bits = txBits(startIndex:startIndex+windowSize-1);

%% 3. BPSK Parameters

Rb = 1000;              % Bit rate
fc = 5000;              % Carrier frequency
samplesPerBit = 100;    % Samples per bit

Fs = Rb * samplesPerBit;
Tb = 1/Rb;

%% 4. Generate BPSK waveform

t = (0:length(bits)*samplesPerBit-1) / Fs;

bpskSignal = zeros(size(t));

for i = 1:length(bits)

    index1 = (i-1)*samplesPerBit + 1;
    index2 = i*samplesPerBit;

    currentTime = t(index1:index2);

    if bits(i) == 1

        % Bit 1 → 0° phase
        bpskSignal(index1:index2) = ...
            cos(2*pi*fc*currentTime);

    else

        % Bit 0 → 180° phase
        bpskSignal(index1:index2) = ...
            -cos(2*pi*fc*currentTime);

    end
end

%% 5. Create clean figure

figure('Name','BPSK Waveform','NumberTitle','off');

plot(t, bpskSignal, ...
    'LineWidth',1.5);

hold on;

%% 6. Draw bit boundaries

for i = 1:length(bits)

    xline((i-1)*Tb, '--', ...
        'Color',[0.5 0.5 0.5], ...
        'LineWidth',0.8);

end

%% 7. Display bit values

for i = 1:length(bits)

    centerTime = (i-0.5)*Tb;

    text(centerTime,1.13,num2str(bits(i)), ...
        'HorizontalAlignment','center', ...
        'FontWeight','bold', ...
        'FontSize',11);

end

%% 8. Highlight ONLY actual phase changes

for i = 2:length(bits)

    if bits(i) ~= bits(i-1)

        transitionTime = (i-1)*Tb;

        xline(transitionTime,'r-', ...
            'LineWidth',1.2);

    end

end

%% 9. Graph formatting

title('Actual BPSK Modulated Carrier', ...
    'FontWeight','bold');

xlabel('Time (seconds)');
ylabel('Amplitude');

xlim([0 length(bits)*Tb]);
ylim([-1.25 1.25]);

yticks([-1 -0.5 0 0.5 1]);

grid on;

legend('BPSK Signal', ...
    'Location','northeast');

set(gca,'FontSize',11);

%% 10. Explanation on graph

text(mean(xlim),-1.18, ...
    'Phase changes by 180° when the bit changes from 1 to 0 or 0 to 1', ...
    'HorizontalAlignment','center', ...
    'FontSize',10, ...
    'Color','r');

hold off;

%% 11. Display information

fprintf('\n----- BPSK WAVEFORM -----\n');

fprintf('Starting bit position = %d\n',startIndex);

fprintf('Number of displayed bits = %d\n',length(bits));

fprintf('Selected bits:\n');

disp(bits);

fprintf('Number of phase transitions = %d\n', ...
    sum(bits(1:end-1) ~= bits(2:end)));