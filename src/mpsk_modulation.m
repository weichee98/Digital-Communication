function [data, signal] = mpsk_modulation(data_bits, M, amplitude, fc, fs, data_rate)
    N = length(data_bits);
    b = log2(M); % number of bits in one symbol
    t = 0: 1/fs: (N/b/data_rate - 1/fs); % time
    carrier = zeros(M, length(t)); % carrier signals
    for i = 1: M
        carrier(i, :) = amplitude .* cos(2 * pi * fc * t - 2 * pi * (i - 1) / M);
    end
    data = repelem(data_bits, fs/data_rate/b);
    
    n = fs / data_rate; % number of samples in one symbol
    signal = zeros(1, length(t));
    for i = 1: N/b
        m = data_bits((i - 1) * b + 1: i * b);
        m = bin2dec(char(m + '0'));
        signal((i - 1) * n + 1: i * n) = carrier(m + 1, (i - 1) * n + 1: i * n);
    end
end

