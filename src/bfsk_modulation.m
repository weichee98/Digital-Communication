function [data, signal] = bfsk_modulation(data_bits, amplitude, fc, fs, fd, data_rate)
    if (fd < data_rate)
        ME = MException('fd is less than data_rate');
        throw(ME)
    end
    N = length(data_bits);
    % fd is the frequency deviation
    fh = fc + fd; % frequency for bit 1
    fl = fc - fd; % frequency for bit 0
    t = 0: 1/fs: (N/data_rate - 1/fs); % time
    carrier1 = amplitude .* cos(2 * pi * fh * t); % carrier signal for bit 1
    carrier0 = amplitude .* cos(2 * pi * fl * t); % carrier signal for bit 0
    data = repelem(data_bits, fs / data_rate);
    signal = zeros(1, length(data));
    for i = 1: length(data)
        if (data(i) == 1)
            signal(i) = carrier1(i);
        else
            signal(i) = carrier0(i);
        end
    end
end