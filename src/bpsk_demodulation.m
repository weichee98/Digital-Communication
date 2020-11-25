% coherent detection

function [demodulated, decoded] = bpsk_demodulation(received, b, a, amplitude, fc, fs, data_rate, threshold)
    N = length(received);
    n = fs / data_rate;

    % carrier recovery method
    % b, a are the filter coefficients of low pass filter
    % d, c are the filter coefficients of high pass filter
    % derive reference signal from incoming signal
    % squared = received .^ 2;
    % high_passed = filtfilt(d, c, squared);
    % divided = interp(high_passed, 2); % double sample rate
    % reference = divided(1:length(high_passed)); % frequency divider
    
    t = 0: 1/fs: ((N - 1)/fs);
    reference = amplitude .* cos(2 * pi * fc * t);
    
    multiplied = reference .* received;
    filtered = filtfilt(b, a, multiplied);
    demodulated = real(sqrt(filtered));
    
    decision = threshold_logic(demodulated, threshold);
    decoded = zeros(1, N / n);
    for i = 1: (N / n)
        decoded(i) = decision((2 * i - 1) * n / 2);
    end
end