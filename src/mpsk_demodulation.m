% coherent detection

function [in_phase, quadrature, phases, decoded] = mpsk_demodulation(received, M, b, a, fc, fs, data_rate)
    N = length(received);
    n = fs / data_rate; % number of samples per data bit
    
    % coherent reference carrier
    t = 0: 1/fs: ((N - 1)/fs);
    refcos = cos(2 * pi * fc * t);
    refsin = sin(2 * pi * fc * t);

    in_phase = refcos .* received;
    in_phase = filtfilt(b, a, in_phase);
    in_phase = real(in_phase);
    
    quadrature = refsin .* received;
    quadrature = filtfilt(b, a, quadrature);
    quadrature = real(quadrature);

    phases = atan(quadrature ./ in_phase);
    phases = phases + (phases < 0) * (2 * pi);
    n_negative = quadrature < 0;
    d_negative = in_phase < 0;
    phases = phases - d_negative .* pi + (n_negative .* d_negative) .* (2 * pi);
    
    b = log2(M); % number of bits per symbol
    decoded = zeros(1, b * N / n);
    threshold = 0: 2 * pi / M: 2 * pi;
    for i = 1: (N / n)
        diff_phase = abs(threshold - phases((2 * i - 1) * n / 2));
        [~, idx] = min(diff_phase);
        m = dec2bin(mod(idx - 1, M), b) - '0';
        decoded(b * (i - 1) + 1:b * i) = m;
    end
end