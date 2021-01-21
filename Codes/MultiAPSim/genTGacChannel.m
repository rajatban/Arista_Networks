%% Generate TGAC channel sampels

% Parameters
nTx = 2;
nRx = 2;
distAP = 5;
N = 250;

% Calculating channel mat

d = 0:(distAP / 40):(distAP);
d = d(2:end-1);
l = length(d);
h = zeros(nTx, nRx, l);


for jj = 1:N
    for kk = 1:(l)
        %fprintf('Dist-%.2f', d(kk));
        
        % Generating channel and noise
        h(:,:,kk) = TGacChanMat(nTx, nRx, abs(d(kk)));
    end
    fprintf('Iter-%d', jj);
        
    h_bar = reshape(h, nTx, nRx*l);
    
    % Write the matices into a file
    writematrix(h_bar,'tgacMats.xlsx','WriteMode','append');

end



% h_bar_bar = reshape(h_bar, nTx, nRx, l);