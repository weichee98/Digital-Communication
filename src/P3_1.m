FC = 10000; % carrier frequency
FS = 16 * FC; % sampling frequency
DATA_RATE = 1000; % data rate
FD = DATA_RATE * 5; % frequency deviation for FSK
N = 1024; % length of signal
ENC_N_BIT = 1792; % num bit after encoding

SIGNAL_LENGTH = FS*ENC_N_BIT/DATA_RATE + 1; % signal length
t = 0 : 1/FS : ENC_N_BIT/DATA_RATE; % time

A = 5; % amplitude
Carrier = A .* cos(2*pi*FC*t);

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
        
        % Generate data
        bits = bit_generator(N);
        
        % Encode data
        encodeHamming = encode(bits, 7, 4, 'hamming/binary');
        encodeCyclic = encode(bits, 7, 4, 'cyclic/binary');
        
        DataStream = encodeHamming;
%         DataStream = zeros(1, SIGNAL_LENGTH);
%         for k = 1: SIGNAL_LENGTH - 1
%             DataStream(k) = encodeHamming(ceil(k*DATA_RATE/FS));
%             %DataStream(k) = encodeCyclic(ceil(k*DATA_RATE/FS));
%         end
%         DataStream(SIGNAL_LENGTH) = DataStream(SIGNAL_LENGTH - 1);
        
        % OOK
        [~, ook_mod] = ook_modulation(DataStream, A, FC, FS, DATA_RATE);
        S = sum(ook_mod .^ 2) / length(ook_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(ook_mod), 0, noise_power);
        [~, ook_dc] = ook_demodulation(ook_mod + n, b, a, FS, DATA_RATE, 2);
        
        % BFSK
        [~, bfsk_mod] = bfsk_modulation(DataStream, A, FC, FS, FD, DATA_RATE);
        S = sum(bfsk_mod .^ 2) / length(bfsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bfsk_mod), 0, noise_power);
        [~, bfsk_dc] = bfsk_demodulation(bfsk_mod + n, b, a, FC, FS, FD, DATA_RATE, 0);
        
        % BPSK
        [~, bpsk_mod] = bpsk_modulation(DataStream, A, FC, FS, DATA_RATE);
        S = sum(bpsk_mod .^ 2) / length(bfsk_mod);
        noise_power = S / (10 ^ (SNR(i) / 10));
        n = noise_generator(length(bfsk_mod), 0, noise_power);
        [~, bpsk_dc] = bpsk_demodulation(bpsk_mod + n, b, a, A, FC, FS, DATA_RATE, 2);
        
        % Decode signals & calculate error
        decoded_ook = decode(ook_dc,7,4, 'hamming/binary');
        decoded_bfsk = decode(bfsk_dc,7,4, 'hamming/binary');
        decoded_bpsk = decode(bpsk_dc,7,4, 'hamming/binary');
        
        ook_sample_error(j) = sum(bits ~= decoded_ook(1:N)) / N;
        bfsk_sample_error(j) = sum(bits ~= decoded_bfsk(1:N)) / N;
        bpsk_sample_error(j) = sum(bits ~= decoded_bpsk(1:N)) / N;
        
    end
    
    ook_error(i) = mean(ook_sample_error);
    bfsk_error(i) = mean(bfsk_sample_error);
    bpsk_error(i) = mean(bpsk_sample_error);
    
end

% result plot using semilogy
figure(1)
ylabel('bit error rate');
xlabel('SNR(dB)')
semilogy(SNR, ook_error, 'b-*');
hold on
semilogy(SNR, bfsk_error, 'r-*');
hold on
semilogy(SNR, bpsk_error, 'g-*');
hold on
legend('OOK', 'BFSK', 'BPSK');
axis([0 10 10^-4 10^0]);
hold off
