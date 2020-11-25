% non-coherent detection

function [demodulated, decoded] = ook_demodulation(received, b, a, fs, data_rate, threshold)
    % b, a are the filter coefficients of low pass filter
    squared = received .^ 2;
    filtered = filtfilt(b, a, squared);
    demodulated = real(sqrt(filtered));
    
    N = length(received);
    n = fs / data_rate;
    decision = threshold_logic(demodulated, threshold);
    decoded = zeros(1, N / n);
    for i = 1: (N / n)
        decoded(i) = decision((2 * i - 1) * n / 2);
    end
end