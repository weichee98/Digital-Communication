% decode signal based on threshold value
% signal greater than threshold is decoded as bit 1
% signal less than threshold is decoded as bit 0

function decoded = threshold_logic(signal, threshold)
    N = length(signal);
    decoded = zeros(1, N);
    for i = 1: N
        if signal(i) >= threshold
            decoded(i) = 1;
        else
            decoded(i) = 0;
        end
    end
end