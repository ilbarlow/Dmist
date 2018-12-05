%dmist viral qPCR analysis

%import data
uiopen('/Users/idabarlow/Documents/MATLAB/qPCR/031016/dmistviralqPCR3_10_16.xlsx',1)
%select entire sheet as matrix

%sort data - 1st cell housekeeping, 2nd cell dmist 3rd cell ankrd13a
data {1} (1:3,1) = dmistviralqPCR31016(1:3); %vir/ vir
data {1}(1:3,2) = dmistviralqPCR31016(4:6); % vir/+
data {1} (1:3,3) = dmistviralqPCR31016(7:9); %+/+
data {2}(1:3,1) = dmistviralqPCR31016(10:12);
data {2} (1:3,2) = dmistviralqPCR31016 (13:15);
data {2} (1:3,3) = dmistviralqPCR31016 (16:18);
data{3}(1:3,1) = dmistviralqPCR31016 (19:21);
data{3}(1:3,2) = dmistviralqPCR31016(22:24);
data{3} (1:3,3) = dmistviralqPCR31016(25:27);

%now calculate expression levels

%calculate mean Cq values among repeats
for i =1:size(data,2)
   mean_Cq {i} = nanmean(data{i});
end

%normalise to housekeeping gene
dmist_norm = data{1} - data{2};
ankrd13a_norm = data{1} - data{3};

%calculate relative cDNA value
for i =1:3
    cDNA_dmist (:,i) = power(2,dmist_norm(:,i));
    cDNA_ankrd13a (:,i) = power(2,ankrd13a_norm(:,i));
end

%calculate mean
mean_dmist = nanmean(cDNA_dmist);
mean_ankrd13a = nanmean (cDNA_ankrd13a);

%calculate std
std_dmist = nanstd(cDNA_dmist);
std_ankrd13a = nanstd (cDNA_ankrd13a);

%make table for plotting bar chart
for i =1:3
mean_express (1,i) = mean_dmist(1,i)/mean_dmist(1,3); %dmist
mean_express (2,i) = mean_ankrd13a(1,i)/mean_ankrd13a(1,3); %ankrd13a
std_express (1,i) =std_dmist (1,i)/ mean_dmist(1,3);
std_express (2,i) =std_ankrd13a (1,i)/ mean_ankrd13a(1,3);
end

%now plot

%dmist
figure;
bar(flip(mean_express(1,:)), 'k', 'Barwidth', 0.5)
hold on;
errorbar(1:3, flip(mean_express(1,:)), flip(std_express(1,:)), '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:1.5];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Dreammist', 'Fontsize', 22)
box off

%ankrd13a
figure;
bar(flip(mean_express(2,:)), 'k', 'Barwidth', 0.5)
hold on;
errorbar(1:3, flip(mean_express(2,:)), flip(std_express(2,:)), '.k');
ax = gca;
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:1.5]
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 16);
title ('Ankrd13a', 'Fontsize', 22)
box off

% perfom stats to compare expression between wts and homs
x = cDNA_dmist(:,1);
y = cDNA_dmist(:,3);

%two sample t test
[h,p,ci,stats] = ttest2(x,y)