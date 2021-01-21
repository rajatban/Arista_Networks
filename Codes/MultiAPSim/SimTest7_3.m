%% abc
distAP = 5;

D = 0:0.25:(distAP);      % distances
D = D(2:end-1);
ll = length(D);

P = 1;            % total tx power
l = 1;


filename = ['Data/SimData-BER_P-',num2str(P),'_v-2.mat'];
load(filename, "d", "BER1", "BER2", "BERsum");

figure
plot(d, BERsum);
hold on
plot(d, BER1);
plot(d, BER2);
legend("BER JT", "BER AP1", "BER AP2");
xlabel("dist from AP1");
ylabel("BER");
title("BER plot");