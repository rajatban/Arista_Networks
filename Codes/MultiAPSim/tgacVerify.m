%% Verifying pathloss in TGac channel


N = 1000;
nTx = 2;
nRx = 2;
% d = [2 3 4 5 6];
d = [5 10 15 25 50];
l = length(d);

avg_h = zeros(l, nTx, nRx);
% Generating channels
for ii = 1:N
    for jj = 1:l
        h = TGacChanMat(nTx,nRx,d(jj));
        avg_h(jj,:,:) = avg_h(jj,:,:) + reshape(h,1,nTx,nRx);
    end
%     h1 = TGacChanMat(nTx,nRx,d(1));
%     h2 = TGacChanMat(nTx,nRx,d(2));
%     avg_h = avg_h + h1;
%     avg_h2 = avg_h2 + h2;
end

avg_h = avg_h / N;
% avg_h2 = avg_h2 / N;

disp(avg_h);
% disp(avg_h2);

figure

bar(d,squeeze(abs(avg_h(:,1,1))));