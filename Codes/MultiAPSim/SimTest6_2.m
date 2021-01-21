%% abc
distAP = 5;

D = 0:0.25:(distAP);      % distances
D = D(2:end-1);
ll = length(D);

P = 4;            % total tx power
p = 0:(P/10):P;      % powers
l = length(p);

BER_plot = zeros(ll, l);

best_pwr = cell(ll,1);  % best power points
best_pwr_g = [];        % variable for graph

BER_min = zeros(1,ll);

for i = 1:ll
    filename = ['Data/SimData-BER2_P-',num2str(P),'_d-',num2str(D(i)),'_v-0.mat'];
    load(filename, "BER2");
    BER_plot(i,:) = BER2;
    
    
    
    
%     %% calculating optimal power
%     BER_min(i) = min(BER1);
%     for ii = 1:l
%         if BER_min(i) == BER1(ii)
%             best_pwr{i}(end + 1) = p(ii);
%             best_pwr_g(:,end+1) = [D(i); p(ii)];
%         end
%     end
    
end

BER2 = BER_plot;
d = D;

filename = ['Data/SimData-BER2_P-',num2str(P),'_v-1.mat'];
save(filename, 'P', 'd', "BER2");


disp(BER_plot);

% figure
% [X ,Y] = meshgrid(p,D);
% mesh(X,Y,BER_plot,'EdgeColor','interp');
% 
% figure
% scatter(best_pwr_g(1,:), best_pwr_g(2,:));