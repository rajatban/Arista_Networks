x = cos(pi/4*(0:99));
y = awgn(x,5,'measured');
sigp = 10*log10(norm(x,2)^2/numel(x));
snr = sigp-5;
noisep = 10^(snr/10);
noise = sqrt(noisep)*randn(size(x));
plot(y)
hold on
plot(noise)