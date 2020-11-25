% generate transmitted signal

function signal = signal_generator(N)
    % generate random binary digits of length N
    bits = bit_generator(N);
    % convert binary digits to +1 and -1
    signal = bits * 2 - 1;
end