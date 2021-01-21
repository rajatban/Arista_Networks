%% abc
distAP = 5;

D = 0:0.25:(distAP);      % distances
D = D(2:end-1);
ll = length(D);

P = 4;            % total tx power
p = 0:(P/10):P;      % powers
l = length(p);

best_pwr = cell(ll,1);  % best power points
best_pwr_g = [];        % variable for graph

BER_min = zeros(1,ll);

filename = ['Data/SimData-BERsum_P-',num2str(P),'_v-1.mat'];
load(filename, "BERsum");

filename = ['Data/SimData-BER1_P-',num2str(P),'_v-1.mat'];
load(filename, "BER1");

filename = ['Data/SimData-BER2_P-',num2str(P),'_v-1.mat'];
load(filename, "BER2");

for i = 1:ll
    %% calculating optimal power
    BER_min(i) = min(BERsum(i,:));
    for ii = 1:l
        if BER_min(i) == BERsum(i,ii)
            best_pwr{i}(end + 1) = p(ii);
            best_pwr_g(:,end+1) = [D(i); p(ii)];
        end
    end
end

BER_plot = BER1 - BERsum;

disp(BER_plot);

figure
mesh(X,Y,BERsum,'EdgeColor','interp');

figure
mesh(X,Y,BER1,'EdgeColor','interp');

figure
[X ,Y] = meshgrid(p,D);
mesh(X,Y,BER_plot,'EdgeColor','interp');
% 
% figure
% scatter(best_pwr_g(1,:), best_pwr_g(2,:));