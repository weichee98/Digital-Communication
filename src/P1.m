N = 1024; % length of signal
THRESHOLD = 0; % threshold value to determine 1 and 0

% bit error rate for different SNR
% ================================
% define SNR(dB) values to be tested
min_snr = 0;
max_snr = 20;
SNR = min_snr:1:max_snr;

% array to store average bit error rate for each value of SNR
avg_error = zeros(1, length(SNR));

SAMPLES = 20; % number of samples to calculate average bit error rate

for i = 1: length(SNR)
    sample_error = zeros(1, SAMPLES);
    for j = 1: SAMPLES
        [transmit, noise, received] = data_generator(N, SNR(i));
        sample_error(j) = bit_error_rate(transmit, received, THRESHOLD);
    end
    avg_error(i) = mean(sample_error);
end

% calculate theoretical bit error rate
% SNR(dB) = 10 log (SNR)
theoretical_error = Q(sqrt(10 .^ (SNR / 10))); 

% result plot using log y-axis
figure(1)
semilogy(SNR, avg_error, 'b*');
ylabel('bit error rate');
xlabel('SNR(dB)')
hold on
semilogy(SNR, theoretical_error, 'k');
legend('simulation', 'theory');
axis([0 20 10^-8 1]);
hold off

% axis range
xmin = 250;
xmax = 750;

% plotting transmitted, received signal and noise
% ===============================================

% data generation
figure(2) 
subplot(3, 1, 1)
stem(xmin:1:xmax, transmit(xmin:xmax), 'Marker', 'none');
axis([xmin xmax -1.5 1.5]);
title('Transmitted Signal')

% noise generation
subplot(3, 1, 2) 
stem(xmin:1:xmax, noise(xmin:xmax), 'Marker', 'none');
axis([xmin xmax -0.5 0.5]);
title('Noise')

% received data generation
subplot(3, 1, 3) 
stem(xmin:1:xmax, received(xmin:xmax), 'Marker', 'none');
axis([xmin xmax -1.5 1.5]);
title('Received Signal')