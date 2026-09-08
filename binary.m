fprintf('Number of 0 bits = %d\n', sum(txBits == 0));
fprintf('Number of 1 bits = %d\n', sum(txBits == 1));

fprintf('\nFirst 100 bits:\n');
disp(txBits(1:100));