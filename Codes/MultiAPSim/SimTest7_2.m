%% abc
distAP = 5;

D = 0:0.25:(distAP);      % distances
D = D(2:end-1);
ll = length(D);

P = 1;            % total tx power
l = 1;

BER_1 = zeros(ll, l);
BER_2 = zeros(ll, l);
BER_sum = zeros(ll, l);


for i = 1:ll
    filename = ['Data/SimData-BER_P-',num2str(P),'_d-',num2str(D(i)),'_v-2.mat'];
    load(filename, "BER1", "BER2", "BERsum");
    
    BER_1(i) = BER1;
    BER_2(i) = BER2;
    BER_sum(i) = BERsum;
end
d = D;
BER1 = BER_1./1000;
BER2 = BER_2./1000;
BERsum = BER_sum./1000;

filename = ['Data/SimData-BER_P-',num2str(P),'_v-2.mat'];
save(filename, 'P', 'd', "BER1", "BER2", "BERsum");
