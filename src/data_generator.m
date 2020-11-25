% generate transmitted signal, noise and received signal

function [transmit, noise, received] = data_generator(N, SNR)
    % generate data bits
    transmit = signal_generator(N);
    % calculate noise variance from SNR in dB
    % assume signal power S = 2
    % SNR(dB) = 10 log (S/N) where N is the noise power
    % N = S / (10 ^ (SNR / 10))
    noise_power = 1 / (10 ^ (SNR / 10));
    % the noise generated using randn is double sided
    noise = noise_generator(N, 0, noise_power);
    % add noise to data bits
    received = transmit + noise;
end