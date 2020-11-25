clear;

FC = 10000; % carrier frequency
FS = 16 * FC; % sampling frequency
DATA_RATE = 1000; % data rate
FD = DATA_RATE * 5; % frequency deviation for FSK
N = 1024; % length of signal

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
ook_error = zeros(1, length(SNR));
bfsk_error = zeros(1, length(SNR));
bpsk_error = zeros(1, length(SNR));

for i = 1: length(SNR)
    
    ook_sample_error = zeros(1, SAMPLES);
    bfsk_sample_error = zeros(1, SAMPLES);
    bpsk_sample_error = zeros(1, SAMPLES);
    
    for j = 1: SAMPLES
        bits = bit_generator(N);
        
        % OOK
        [~, ook_mod] = ook_modulation(bits, A, FC, FS, DATA_RATE);
        S = sum(ook_mod .^ 2) / length(ook_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(ook_mod), 0, noise_power);
        [~, ook_dc] = ook_demodulation(ook_mod + n, b, a, FS, DATA_RATE, 2);
        ook_sample_error(j) = sum(bits ~= ook_dc) / N;
        
        % BFSK
        [~, bfsk_mod] = bfsk_modulation(bits, A, FC, FS, FD, DATA_RATE);
        S = sum(bfsk_mod .^ 2) / length(bfsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bfsk_mod), 0, noise_power);
        [~, bfsk_dc] = bfsk_demodulation(bfsk_mod + n, b, a, FC, FS, FD, DATA_RATE, 0);
        bfsk_sample_error(j) = sum(bits ~= bfsk_dc) / N;
        
        % BPSK
        [~, bpsk_mod] = bpsk_modulation(bits, A, FC, FS, DATA_RATE);
        S = sum(bpsk_mod .^ 2) / length(bpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bpsk_mod), 0, noise_power);
        [~, bpsk_dc] = bpsk_demodulation(bpsk_mod + n, b, a, A, FC, FS, DATA_RATE, 2);
        bpsk_sample_error(j) = sum(bits ~= bpsk_dc) / N;
        
    end
    
    ook_error(i) = mean(ook_sample_error);
    bfsk_error(i) = mean(bfsk_sample_error);
    bpsk_error(i) = mean(bpsk_sample_error);
    
end

% result plot using semilogy
figure(5)
semilogy(SNR, ook_error, 'b-*');
hold on
semilogy(SNR, bfsk_error, 'r-*');
hold on
semilogy(SNR, bpsk_error, 'g-*');
hold on
legend('OOK', 'BFSK', 'BPSK');
axis([0 10 10^-4 10^0]);
ylabel('bit error rate');
xlabel('SNR(dB)')
hold off
