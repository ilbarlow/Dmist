%qPCR analysis

%% open qpcr excel sheet
fname = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\qPCR\Data\Dmisti8\201016\201016dmistqPCR_crispr.xlsx'
uiopen(fname,1)


%% sort data - 1st cell housekeeping, 2nd cell dmist 3rd cell ankrd13a, 4th
%cell slc6a4b
data {1} (1:3,1) = dmistqPCRcrispr(1:3); %-/-
data {1}(1:3,2) = dmistqPCRcrispr(4:6); % +/+
data {1} (1:3,3) = dmistqPCRcrispr(7:9); %+/+
data {2}(1:3,1) = dmistqPCRcrispr(10:12);
data {2} (1:3,2) = dmistqPCRcrispr (13:15);
data {2} (1:3,3) = dmistqPCRcrispr (16:18);
data{3}(1:3,1) = dmistqPCRcrispr (19:21);
data{3}(1:3,2) = dmistqPCRcrispr(22:24);
data{3} (1:3,3) = dmistqPCRcrispr(25:27);
data{4} (1:3,1) = dmistqPCRcrispr(28:30);
data{4} (1:3,2) = dmistqPCRcrispr(31:33);
data{4}(1:3,3) = dmistqPCRcrispr(34:36);
% data{5} (1:4,1) = dmistqPCRcrispr(37:40); %slc6a4b efficiency
% data{6} (1:4,1) = dmistqPCRcrispr (41:44); %ankrd13a efficiency

%% dmist primer eff
x  = [1 10 100 1000];
dmist_eff = [26.16 28.15 28.90 29.30]; %values from qPCR done in march 2015

figure;
scatter (log10(x), dmist_eff);
l = lsline;
slope_d = (l.YData(2) - l.YData(1))/(l.XData(2) - l.XData(1));
eff_d = 10^(-1/slope_d); %dmist

%calculate primer efficiencies for slc6a4b and ankrd13a
figure; scatter (log10(x), data{5});
l = lsline;
slope_s = (l.YData(2) - l.YData(1))/(l.XData(2) - l.XData(1));
eff_s = 10^(-1/slope_s); %slc6a4b

%ankrd13a
figure; scatter (log10(x), data{6});
l = lsline;
slope_a = (l.YData(2) - l.YData(1))/(l.XData(2) - l.XData(1));
eff_a = 10^(-1/slope_a);


%% normalise to housekeeping gene
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
bar(flip(mean_express(1,:)), 'k', 'Barwidth', 0.5)
hold on;
errorbar(1:3, flip(mean_express(1,:)), flip(std_express(1,:)), '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'+/+' '+/-' '-/-'}
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
errorbar(1:3, flip(mean_express(2,:)), flip(std_express(2,:)), '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'+/+' '+/-' '-/-'}
ax.YTick = [0:0.2:1.5]
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 16);
title ('Ankrd13a', 'Fontsize', 22)
box off

%slc6a4b
figure;
bar(flip(mean_express(3,:)), 'k', 'Barwidth', 0.5)
hold on;
errorbar(1:3, flip(mean_express(3,:)), flip(std_express(3,:)), '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'+/+' '+/-' '-/-'}
ax.YTick = [0:0.2:1.5];
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
[h,p,ci,stats] = ttest2(x1,y1)


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
ax.XTickLabel = {'+/+' 'i8/ +' 'i8/i8'}
ax.YTick = [0:0.2:2];
legend ('Dmist', 'Ankrd13a', 'Slc6a4b')
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Slc6a4b', 'Fontsize', 22)
box off


%% add in the other experiments
fname2 = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\qPCR\Data\Dmisti8\151016\151016dmistqPCR_crispr.xlsx'
uiopen(fname2,1)

data2 {1} (1:3,1) = dmistqPCRcrispr1(1:3); %-/- EF1alpha
data2 {1}(1:3,2) = dmistqPCRcrispr1(4:6); % +/+
data2 {1} (1:3,3) = dmistqPCRcrispr1(7:9); %+/+
data2 {2}(1:3,1) = dmistqPCRcrispr1(10:12);%dmist
data2 {2} (1:3,2) = dmistqPCRcrispr1 (13:15);
data2 {2} (1:3,3) = dmistqPCRcrispr1 (16:18);
data2{3}(1:3,1) = dmistqPCRcrispr1 (19:21);%ankrd13a
data2{3}(1:3,2) = dmistqPCRcrispr1(22:24);
data2{3} (1:3,3) = dmistqPCRcrispr1(25:27);

%normalise
dmist_norm2 = data2{1} - data2{2};
ankrd13a_norm2 = data2{1} - data2{3};

%calculate relative cDNA value
for i =1:3 %each
    cDNA_dmist2 (:,i) = power(2,dmist_norm2(:,i));
    cDNA_ankrd13a2 (:,i) = power(2,ankrd13a_norm2(:,i));
end

%calculate mean
mean_dmist2 = nanmean(cDNA_dmist2);
mean_ankrd13a2 = nanmean (cDNA_ankrd13a2);

%make table for plotting bar chart
for i =1:3
mean_express2 (1,i) = mean_dmist2(1,i)/mean_dmist2(1,3); %dmist
mean_express2 (2,i) = mean_ankrd13a2(1,i)/mean_ankrd13a2(1,3); %ankrd13a
end

%relative expression average from three experiment (031016, 151016, 201016)
all{1} = [mean_express(1,:); mean_express2(1,:)]; %dmist
all{2} = [mean_express(2,:); mean_express2(2,:)] %ankrd13a
all{3} = [mean_express(3,:)]; %slc6ab

cmap = [1 0 1; 0 0 1; 0 1 1];
genenames = {'dmist', 'ankrd13a', 'slc6a4b'};

for p=1:3
    [P{p},anovatab,stats] = anova1(all{p});
    Pt{p} = multcompare(stats)
end

for p=1:2
    xlswrite(fullfile(fileparts(fileparts(fname)), 'i8qPCRStats.xls'), Pt{p}, genenames{p});
end


%make figures
for p=1:size(all,2)
    figure;
    b = bar(flip(nanmean(all{p})), 'Barwidth', 0.5);
    b.FaceColor = cmap(p,:);
    hold on;
    errorbar (flip(nanmean(all{p})), flip(nanstd(all{p})), '.k', 'Linewidth', 2)
    ax = gca;
    ax.XTickLabel = {'+/+' 'i8/+' 'i8'}
    ax.YTick = [0:0.2:2];
    ylim ([0 2])
    set(gca, 'Fontsize', 16)
    ylabel('Relative expression', 'Fontsize' ,18);
    xlabel('Genotype', 'FontSize', 18);
    box off
    legend({strcat(genenames{p}, ', n=', num2str(size(all{p},1)))})
    text(1,1.5, strcat('anova1, p=', num2str(Pt{p}(2,end))));
    print(fullfile(fileparts(fileparts(fname)),'Figures', strcat(genenames{p}, 'DmistqPCR')), '-depsc', '-tiff')
    savefig(fullfile(fileparts(fileparts(fname)),'Figures', strcat(genenames{p},'DmistqPCR.fig')));
    saveas(gcf, fullfile(fileparts(fileparts(fname)),'Figures',strcat(genenames{p}, 'DmistqPCR')), 'tiff');
end



%% SCRAP

%dmist primer eff
dmist_eff = [26.16 28.15 28.90 29.30];


figure;
scatter (log10(x), dmist_eff);
l = lsline;
slope_d = (l.YData(2) - l.YData(1))/(l.XData(2) - l.XData(1));
eff_d = 10^(-1/slope_d); %dmist