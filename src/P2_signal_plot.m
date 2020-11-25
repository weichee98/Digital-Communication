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

% plotting bits, modulated and demodulated signals
% ================================================
bits = bit_generator(N);

% OOK
% ===
[~, ook_mod] = ook_modulation(bits, A, FC, FS, DATA_RATE);
n = noise_generator(length(ook_mod), 0, 0.1);
ook_received = ook_mod + n;
[ook_demod, ook_dc] = ook_demodulation(ook_received, b, a, FS, DATA_RATE, 2);
bmin = 300;
bmax = 310;
xmin = (bmin - 1) * (FS/DATA_RATE) + 1;
xmax = (bmax - 1) * (FS/DATA_RATE);

figure(1)
subplot(5, 1, 1) % data waveform
stairs(bmin:1:bmax, bits(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Data Waveform')
subplot(5, 1, 2) % modulated signal 
plot(xmin:1:xmax, ook_mod(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Modulated Signal')
subplot(5, 1, 3) % received signal 
plot(xmin:1:xmax, ook_received(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Received Signal')
subplot(5, 1, 4) % demodulated signal 
plot(xmin:1:xmax, ook_demod(xmin:xmax));
axis([xmin xmax -0.5 5]);
title('Demodulated Signal')
subplot(5, 1, 5) % decoded bits
stairs(bmin:1:bmax, ook_dc(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Decoded Signal')
sgtitle('On-Off Keying (OOK)')


% BPSK
% ===
[~, bpsk_mod] = bpsk_modulation(bits, A, FC, FS, DATA_RATE);
n = noise_generator(length(bpsk_mod), 0, 0.1);
bpsk_received = bpsk_mod + n;
[bpsk_demod, bpsk_dc] = bpsk_demodulation(bpsk_received, b, a, A, FC, FS, DATA_RATE, 2);
bmin = 300;
bmax = 310;
xmin = (bmin - 1) * (FS/DATA_RATE) + 1;
xmax = (bmax - 1) * (FS/DATA_RATE);

figure(2)
subplot(5, 1, 1) % data waveform
stairs(bmin:1:bmax, bits(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Data Waveform')
subplot(5, 1, 2) % modulated signal 
plot(xmin:1:xmax, bpsk_mod(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Modulated Signal')
subplot(5, 1, 3) % received signal 
plot(xmin:1:xmax, bpsk_received(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Received Signal')
subplot(5, 1, 4) % demodulated signal 
plot(xmin:1:xmax, bpsk_demod(xmin:xmax));
axis([xmin xmax -0.5 5]);
title('Demodulated Signal')
subplot(5, 1, 5) % decoded bits
stairs(bmin:1:bmax, bpsk_dc(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Decoded Signal')
sgtitle('Binary Phase Shift Keying (BPSK)')


% BFSK
% ===
[~, bfsk_mod] = bfsk_modulation(bits, A, FC, FS, FD, DATA_RATE);
n = noise_generator(length(bfsk_mod), 0, 0.1);
bfsk_received = bfsk_mod + n;
[bfsk_demod, bfsk_dc] = bfsk_demodulation(bfsk_received, b, a, FC, FS, FD, DATA_RATE, 0);
bmin = 300;
bmax = 310;
xmin = (bmin - 1) * (FS/DATA_RATE) + 1;
xmax = (bmax - 1) * (FS/DATA_RATE);

figure(3)
subplot(5, 1, 1) % data waveform
stairs(bmin:1:bmax, bits(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Data Waveform')
subplot(5, 1, 2) % modulated signal 
plot(xmin:1:xmax, bfsk_mod(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Modulated Signal')
subplot(5, 1, 3) % received signal 
plot(xmin:1:xmax, bfsk_received(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Received Signal')
subplot(5, 1, 4) % demodulated signal 
plot(xmin:1:xmax, bfsk_demod(xmin:xmax));
% axis([xmin xmax -0.5 6.5]);
xlim([xmin xmax]);
title('Demodulated Signal')
subplot(5, 1, 5) % decoded bits
stairs(bmin:1:bmax, bfsk_dc(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Decoded Signal')
sgtitle('Binary Frequency Shift Keying (BFSK)')


% MPSK
% ===
M = 4;
[~, mpsk_mod] = mpsk_modulation(bits, M, A, FC, FS, DATA_RATE);
n = noise_generator(length(mpsk_mod), 0, 0.1);
mpsk_received = mpsk_mod + n;
[mpsk_in_phase, mpsk_quadrature, mpsk_phases, mpsk_dc] = mpsk_demodulation(mpsk_received, M, b, a, FC, FS, DATA_RATE);
bmin = 301;
bmax = 310;
xmin = (bmin - 1) * (FS/DATA_RATE/log2(M)) + 1;
xmax = (bmax - 1) * (FS/DATA_RATE/log2(M));

figure(4)
subplot(5, 1, 1) % data waveform
stairs(bmin:1:bmax, bits(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Data Waveform')
subplot(5, 1, 2) % modulated signal 
plot(xmin:1:xmax, mpsk_mod(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Modulated Signal')
subplot(5, 1, 3) % received signal 
plot(xmin:1:xmax, mpsk_received(xmin:xmax));
axis([xmin xmax -5.5 5.5]);
title('Received Signal')
subplot(5, 1, 4) % demodulated signal 
plot(xmin:1:xmax, mpsk_in_phase(xmin:xmax));
hold on;
plot(xmin:1:xmax, mpsk_quadrature(xmin:xmax));
legend('in phase', 'quadrature');
xlim([xmin xmax]);
title('Demodulated Signal')
subplot(5, 1, 5) % decoded bits
stairs(bmin:1:bmax, mpsk_dc(bmin:bmax));
axis([bmin bmax -0.5, 1.5]);
title('Decoded Signal')
sgtitle('4-ary Phase Shift Keying')
