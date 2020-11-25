% generate random bits

function bits = bit_generator(N)
    % generate random binary digits of length N
    bits = randi([0, 1], 1, N);
end