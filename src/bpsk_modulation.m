function [data, signal] = bpsk_modulation(data_bits, amplitude, fc, fs, data_rate)
    N = length(data_bits);
    t = 0: 1/fs: (N/data_rate - 1/fs); % time
    carrier = amplitude .* cos(2 * pi * fc * t); % carrier signal
    data = repelem(data_bits, fs / data_rate);
    data = data * 2 - 1;
    signal = data .* carrier;
end

