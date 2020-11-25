FC = 10000; % carrier frequency
FS = 16 * FC; % sampling frequency
DATA_RATE = 1000; % data rate
FD = DATA_RATE * 5; % frequency deviation for FSK
N = 1024; % length of signal
ENC_N_BIT = 1792; % num bit after encoding

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
qpsk_error = zeros(1, length(SNR)); % 4-ary PSK
hpsk_error = zeros(1, length(SNR)); % 16-ary PSK

ook_cerror = zeros(1, length(SNR));
bfsk_cerror = zeros(1, length(SNR));
bpsk_cerror = zeros(1, length(SNR));
qpsk_cerror = zeros(1, length(SNR)); % 4-ary PSK
hpsk_cerror = zeros(1, length(SNR)); % 16-ary PSK

for i = 1: length(SNR)
    
    ook_sample_error = zeros(1, SAMPLES);
    bfsk_sample_error = zeros(1, SAMPLES);
    bpsk_sample_error = zeros(1, SAMPLES);
    qpsk_sample_error = zeros(1, SAMPLES);
    hpsk_sample_error = zeros(1, SAMPLES);
    ook_sample_cerror = zeros(1, SAMPLES);
    bfsk_sample_cerror = zeros(1, SAMPLES);
    bpsk_sample_cerror = zeros(1, SAMPLES);
    qpsk_sample_cerror = zeros(1, SAMPLES);
    hpsk_sample_cerror = zeros(1, SAMPLES);
    
    for j = 1: SAMPLES
        
        % Generate data
        bits = bit_generator(N);
        
        % Encode data
        encodeHamming = encode(bits, 7, 4, "hamming/binary");
        encodeCyclic = encode(bits, 7, 4, "cyclic/binary");
        
        % Using Hamming encoder
        % ==================================
        % OOK
        [~, ook_mod] = ook_modulation(encodeHamming, A, FC, FS, DATA_RATE);
        S = sum(ook_mod .^ 2) / length(ook_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(ook_mod), 0, noise_power);
        [~, ook_dc] = ook_demodulation(ook_mod + n, b, a, FS, DATA_RATE, 2);
        
        % BFSK
        [~, bfsk_mod] = bfsk_modulation(encodeHamming, A, FC, FS, FD, DATA_RATE);
        S = sum(bfsk_mod .^ 2) / length(bfsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bfsk_mod), 0, noise_power);
        [~, bfsk_dc] = bfsk_demodulation(bfsk_mod + n, b, a, FC, FS, FD, DATA_RATE, 0);
        
        % BPSK
        [~, bpsk_mod] = bpsk_modulation(encodeHamming, A, FC, FS, DATA_RATE);
        S = sum(bpsk_mod .^ 2) / length(bpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bpsk_mod), 0, noise_power);
        [~, bpsk_dc] = bpsk_demodulation(bpsk_mod + n, b, a, A, FC, FS, DATA_RATE, 2);
        
        % QPSK
        M = 4;
        [~, mpsk_mod] = mpsk_modulation(encodeHamming, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, qpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        
        % HPSK
        M = 16;
        [~, mpsk_mod] = mpsk_modulation(encodeHamming, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, hpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        
        % Decode signals & calculate error
        decoded_ook = decode(ook_dc,7,4, 'hamming/binary');
        decoded_bfsk = decode(bfsk_dc,7,4, 'hamming/binary');
        decoded_bpsk = decode(bpsk_dc,7,4, 'hamming/binary');
        decoded_qpsk = decode(qpsk_dc,7,4, 'hamming/binary');
        decoded_hpsk = decode(hpsk_dc,7,4, 'hamming/binary');
        
        ook_sample_error(j) = sum(bits ~= decoded_ook) / N;
        bfsk_sample_error(j) = sum(bits ~= decoded_bfsk) / N;
        bpsk_sample_error(j) = sum(bits ~= decoded_bpsk) / N;
        qpsk_sample_error(j) = sum(bits ~= decoded_qpsk) / N;
        hpsk_sample_error(j) = sum(bits ~= decoded_hpsk) / N;
        
        % Using Cyclic encoder
        % ==================================
        % OOK
        [~, ook_mod] = ook_modulation(encodeCyclic, A, FC, FS, DATA_RATE);
        S = sum(ook_mod .^ 2) / length(ook_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(ook_mod), 0, noise_power);
        [~, ook_dc] = ook_demodulation(ook_mod + n, b, a, FS, DATA_RATE, 2);
        
        % BFSK
        [~, bfsk_mod] = bfsk_modulation(encodeCyclic, A, FC, FS, FD, DATA_RATE);
        S = sum(bfsk_mod .^ 2) / length(bfsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bfsk_mod), 0, noise_power);
        [~, bfsk_dc] = bfsk_demodulation(bfsk_mod + n, b, a, FC, FS, FD, DATA_RATE, 0);
        
        % BPSK
        [~, bpsk_mod] = bpsk_modulation(encodeCyclic, A, FC, FS, DATA_RATE);
        S = sum(bpsk_mod .^ 2) / length(bpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bpsk_mod), 0, noise_power);
        [~, bpsk_dc] = bpsk_demodulation(bpsk_mod + n, b, a, A, FC, FS, DATA_RATE, 2);
        
        % QPSK
        M = 4;
        [~, mpsk_mod] = mpsk_modulation(encodeCyclic, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, qpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        
        % HPSK
        M = 16;
        [~, mpsk_mod] = mpsk_modulation(encodeCyclic, M, A, FC, FS, DATA_RATE);
        S = sum(mpsk_mod .^ 2) / length(mpsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(mpsk_mod), 0, noise_power);
        [~, ~, ~, hpsk_dc] = mpsk_demodulation(mpsk_mod + n, M, b, a, FC, FS, DATA_RATE);
        
        decoded_ook = decode(ook_dc,7,4, 'cyclic/binary');
        decoded_bfsk = decode(bfsk_dc,7,4, 'cyclic/binary');
        decoded_bpsk = decode(bpsk_dc,7,4, 'cyclic/binary');
        decoded_qpsk = decode(qpsk_dc,7,4, 'cyclic/binary');
        decoded_hpsk = decode(hpsk_dc,7,4, 'cyclic/binary');
        
        ook_sample_cerror(j) = sum(bits ~= decoded_ook) / N;
        bfsk_sample_cerror(j) = sum(bits ~= decoded_bfsk) / N;
        bpsk_sample_cerror(j) = sum(bits ~= decoded_bpsk) / N;
        qpsk_sample_cerror(j) = sum(bits ~= decoded_qpsk) / N;
        hpsk_sample_cerror(j) = sum(bits ~= decoded_hpsk) / N;
        
    end
    
    ook_error(i) = mean(ook_sample_error);
    bfsk_error(i) = mean(bfsk_sample_error);
    bpsk_error(i) = mean(bpsk_sample_error);
    qpsk_error(i) = mean(qpsk_sample_error);
    hpsk_error(i) = mean(hpsk_sample_error);
    
    ook_cerror(i) = mean(ook_sample_cerror);
    bfsk_cerror(i) = mean(bfsk_sample_cerror);
    bpsk_cerror(i) = mean(bpsk_sample_cerror);
    qpsk_cerror(i) = mean(qpsk_sample_cerror);
    hpsk_cerror(i) = mean(hpsk_sample_cerror);
    
end

% result plot using semilogy
figure(1)
semilogy(SNR, ook_error, 'b-*');
hold on
semilogy(SNR, bfsk_error, 'r-*');
hold on
semilogy(SNR, bpsk_error, 'g-*');
hold on
semilogy(SNR, qpsk_error, 'c-*');
hold on
semilogy(SNR, hpsk_error, 'm-*');
hold on
legend('OOK', 'BFSK', 'BPSK', '4-ary PSK', '16-ary PSK');
axis([0 10 10^-4 10^0]);
hold off
ylabel('bit error rate');
xlabel('SNR(dB)');
saveas(gcf,'Hammings.png');

figure(2)
semilogy(SNR, ook_cerror, 'b-*');
hold on
semilogy(SNR, bfsk_cerror, 'r-*');
hold on
semilogy(SNR, bpsk_cerror, 'g-*');
hold on
semilogy(SNR, qpsk_cerror, 'c-*');
hold on
semilogy(SNR, hpsk_cerror, 'm-*');
hold on
legend('OOK', 'BFSK', 'BPSK', '4-ary PSK', '16-ary PSK');
axis([0 20 10^-5 10^0]);
hold off
ylabel('bit error rate');
xlabel('SNR(dB)');
saveas(gcf,'Cyclic.png');