%% open qpcr excel sheet

uiopen('/Users/idabarlow/Documents/MATLAB/qPCR/151016/151016dmist_viralqPCR.xlsx',1)


%sort data - 1st cell housekeeping, 2nd cell dmist 3rd cell ankrd13a, 4th
%cell slc6a4b
data {1} (1:3,1) = dmistviralqPCR(1:3); %vir/ vir
data {1}(1:3,2) = dmistviralqPCR(4:6); % vir/+
data {1} (1:3,3) = dmistviralqPCR(7:9); %+/+
data {2}(1:3,1) = dmistviralqPCR(10:12);
data {2} (1:3,2) = dmistviralqPCR (13:15);
data {2} (1:3,3) = dmistviralqPCR (16:18);
data{3}(1:3,1) = dmistviralqPCR (19:21);
data{3}(1:3,2) = dmistviralqPCR(22:24);
data{3} (1:3,3) = dmistviralqPCR(25:27);
data{4} (1:3,1) = dmistviralqPCR(28:30);
data{4} (1:3,2) = dmistviralqPCR(31:33);
data{4}(1:3,3) = dmistviralqPCR(34:36);

%now calculate expression levels

%calculate mean Cq values among repeats
for i =1:size(data,2)
   mean_Cq {i} = nanmean(data{i});
end

%normalise to housekeeping gene
dmist_norm = data{1} - data{2};
ankrd13a_norm = data{1} - data{3};
slc6a4b_norm = data{1} - data{4};

%calculate relative cDNA value
for i =1:3 %each
    cDNA_dmist (:,i) = power(2,dmist_norm(:,i));
    cDNA_ankrd13a (:,i) = power(2,ankrd13a_norm(:,i));
    cDNA_slc6a4b (:,i) = power(2, slc6a4b_norm(:,i));
end

%calculate mean
mean_dmist = nanmean(cDNA_dmist);
mean_ankrd13a = nanmean (cDNA_ankrd13a);
mean_slc6a4b = nanmean(cDNA_slc6a4b);

%calculate std
std_dmist = nanstd(cDNA_dmist);
std_ankrd13a = nanstd (cDNA_ankrd13a);
std_slc6a4b = nanstd(cDNA_slc6a4b);

%make table for plotting bar chart
for i =1:3
mean_express (1,i) = mean_dmist(1,i)/mean_dmist(1,3); %dmist
mean_express (2,i) = mean_ankrd13a(1,i)/mean_ankrd13a(1,3); %ankrd13a
mean_express (3,i) = mean_slc6a4b(1,i)/ mean_slc6a4b(1,3); %slc6a4b
std_express (1,i) =std_dmist (1,i)/ mean_dmist(1,3);
std_express (2,i) =std_ankrd13a (1,i)/ mean_ankrd13a(1,3);
std_express (3,i) = std_slc6a4b(1,i)/ mean_slc6a4b(1,3);
end

%now plot

%dmist
figure;
errorbar(1:3, flip(mean_express(1,:)), flip(std_express(1,:)), '.k', 'Linewidth', 2);
hold on;
bar(flip(mean_express(1,:)), 'Barwidth', 0.5, 'Facecolor', [1 0 1])
ylim ([0 2.5])
ax = gca;
ax.XTick = [1 2 3];
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:2.5];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Dreammist', 'Fontsize', 22)
box off

%ankrd13a
figure;
errorbar(1:3, flip(mean_express(2,:)), flip(std_express(2,:)), '.k', 'Linewidth', 2);
hold on;
bar(flip(mean_express(2,:)), 'Barwidth', 0.5, 'Facecolor', [0 0.4 1])
ylim ([0 2.5])
ax = gca;
ax.XTick = [1 2 3];
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:2.5]
set(gca, 'Fontsize', 18)
ylabel('Relative expression', 'Fontsize' ,20);
xlabel('Genotype', 'FontSize', 20);
title ('Ankrd13a', 'Fontsize', 24)
box off

%slc6a4b
figure;
errorbar(1:3, flip(mean_express(3,:)), flip(std_express(3,:)), '.k', 'Linewidth', 2);
hold on;
bar(flip(mean_express(3,:)), 'Barwidth', 0.5, 'Facecolor' , [0 0.6 0])
ylim ([0 2.5])
ax = gca;
ax.XTick = [1 2 3];
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:2.5];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Slc6a4b', 'Fontsize', 22)
box off

% perfom stats to compare expression between wts and homs

x1 = cDNA_dmist(:,1);
y1 = cDNA_dmist(:,3);
x2 = cDNA_ankrd13a(:,1);
y2 = cDNA_ankrd13a(:,3);
x3 = cDNA_slc6a4b(:,1);
y3 = cDNA_slc6a4b (:,3);



%two sample t test
[p1, tbl, stats] = anova1(cDNA_dmist);
[p2, tbl, stats] = anova1(cDNA_ankrd13a);
[p3, tbl, stats] = anova1(cDNA_slc6a4b);


%make nice figure with all qPCR data on one axes
%need table with all WT, all Het and then all Hom

final (1:3) = mean_express(:,1);
final (4:6) = mean_express(:,2);
final (7:9) = mean_express(:,3);

figure;
b = bar(flip(mean_express'), 'Barwidth', 0.5);
b(1).FaceColor = [0 0 0];
b(2).FaceColor = [0.4 0.4 0.4];
b(3).FaceColor = [0.8 0.8 0.8];
ax = gca;
ax.XTickLabel = {'+/+' 'virus/ +' 'virus/virus'}
ax.YTick = [0:0.2:2];
legend ('Dmist', 'Ankrd13a', 'Slc6a4b')
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Slc6a4b', 'Fontsize', 22)
box off

