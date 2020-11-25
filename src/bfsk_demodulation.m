% non-coherent detection
% quadrature detector

function [demodulated, decoded] = bfsk_demodulation(received, b, a, fc, fs, fd, data_rate, threshold)
    N = length(received);
    
    % fd is the frequency deviation
    fh = fc + fd; % frequency for bit 1
    fl = fc - fd; % frequency for bit 0
    t = 0: 1/fs: ((N - 1)/fs); % time
    refcos1 = cos(2 * pi * fh * t) .* received;
    refsin1 = sin(2 * pi * fh * t) .* received;
    refcos0 = cos(2 * pi * fl * t) .* received;
    refsin0 = sin(2 * pi * fl * t) .* received;
    
    n = fs / data_rate; % number of samples per data bit
    j = 0;
    
    f_refcos1 = filtfilt(b, a, refcos1);
    f_refsin1 = filtfilt(b, a, refsin1);
    f_refcos0 = filtfilt(b, a, refcos0);
    f_refsin0 = filtfilt(b, a, refsin0);
    
    demodulated = real(f_refcos1) - real(f_refsin1) - real(f_refcos0) + real(f_refsin0);
    
    % integrator
    % demodulated = zeros(1, N);
    % for i = 1: N
    %     if (j == 0)
    %         demodulated(i) = refcos1(i) - refsin1(i) - refcos0(i) + refsin0(i);
    %     else
    %         demodulated(i) = demodulated(i - 1) + refcos1(i) - refsin1(i) - refcos0(i) + refsin0(i);
    %     end
    %     j = mod(j + 1, n);
    % end
    
    decision = threshold_logic(demodulated, threshold);
    decoded = zeros(1, N / n);
    for i = 1: (N / n)
        decoded(i) = decision((2 * i - 1) * n / 2);
    end
end