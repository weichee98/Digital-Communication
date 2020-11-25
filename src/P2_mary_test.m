clear;

FC = 10000; % carrier frequency
FS = 12 * FC; % sampling frequency
DATA_RATE = 1000; % data rate
N = 1080; % length of signal
A = 5; % amplitude

ORDER = 6; % order of filter
FH = 0.2; % cutoff frequency for low pass filter
FL = 0.2; % cutoff frequency for high pass filter
[b, a] = butter(ORDER, FH); % low pass filter
[d, c] = butter(ORDER, FL, 'high'); % high pass filter

% bit error rate for different SNR
% ================================
% define SNR(dB) values to be tested
min_snr = 0;
max_snr = 20;
SNR = min_snr:1:max_snr;

SAMPLES = 20; % number of samples to calculate average bit error rate

% array to store average bit error rate for each value of SNR
bpsk_error = zeros(1, length(SNR));
qpsk_error = zeros(1, length(SNR)); % 4-ary PSK
opsk_error = zeros(1, length(SNR)); % 8-ary PSK
hpsk_error = zeros(1, length(SNR)); % 16-ary PSK

for i = 1: length(SNR)

    bpsk_sample_error = zeros(1, SAMPLES);
    qpsk_sample_error = zeros(1, SAMPLES);
    opsk_sample_error = zeros(1, SAMPLES);
    hpsk_sample_error = zeros(1, SAMPLES);
    
    for j = 1: SAMPLES
        bits = bit_generator(N);
        
        % BPSK
        [~, bpsk_mod] = bpsk_modulation(bits, A, FC, FS, DATA_RATE);
        S = sum(bpsk_mod .^ 2) / length(bpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bpsk_mod), 0, noise_power);
        [~, bpsk_dc] = bpsk_demodulation(bpsk_mod + n, b, a, A, FC, FS, DATA_RATE, 2);
        bpsk_sample_error(j) = sum(bits ~= bpsk_dc) / N;
        
        % QPSK
        M = 4;
        [~, mpsk_mod] = mpsk_modulation(bits, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, mpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        qpsk_sample_error(j) = sum(bits ~= mpsk_dc) / N;
        
        % OPSK
        M = 8;
        [~, mpsk_mod] = mpsk_modulation(bits, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, mpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        opsk_sample_error(j) = sum(bits ~= mpsk_dc) / N;
        
        % HPSK
        M = 16;
        [~, mpsk_mod] = mpsk_modulation(bits, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, mpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        hpsk_sample_error(j) = sum(bits ~= mpsk_dc) / N;
        
    end
    
    bpsk_error(i) = mean(bpsk_sample_error);
    qpsk_error(i) = mean(qpsk_sample_error);
    opsk_error(i) = mean(opsk_sample_error);
    hpsk_error(i) = mean(hpsk_sample_error);
    
end

% result plot using semilogy
figure(5)
semilogy(SNR, bpsk_error, 'b-*');
hold on
semilogy(SNR, qpsk_error, 'r-*');
hold on
semilogy(SNR, opsk_error, 'g-*');
hold on
semilogy(SNR, hpsk_error, 'c-*');
hold on
legend('BPSK', '4-ary PSK', '8-ary PSK', '16-ary PSK');
axis([0 20 10^-4 10^0]);
ylabel('bit error rate');
xlabel('SNR(dB)')
hold off
