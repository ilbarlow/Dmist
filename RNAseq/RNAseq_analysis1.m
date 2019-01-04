%Script for analysing Dmist i8 and vir RNAseq data
    %1. Import raw normalised reads
    %2. PCA to see where most variance is
    %3. Stats to identify commonly misregulated genes

%load data
[filename, pathname] = uigetfile({'*.txt'})
data = readtable(fullfile(pathname,filename),'Delimiter', '\t');

%separate into appropriate format
reads = table2array(data(:,2:13));
genes = table2array(data(:,1));
description = table2array(data(:,14));
chromosome = table2array(data(:,15));
var_names = data.Properties.VariableNames;

%filter the data to remove genes with expression below 2 standard
%deviations of average across all genes in all genotypes

%find cutoff value
figure;
sort_reads = sort(reads(:));
[pks,locs] = findpeaks(diff(sort_reads),'MinPeakHeight',0.3);

semilogy(sort_reads);
ylabel ('expression level (log)');
xlabel ('sorted gene expression');
hold on;
stem (locs(2),100)
stem (locs(3), 100)

%plot on the cutoff point
cut = sort_reads(locs(3));

to_exclude =ones(size(reads,1),size(reads,2));
for i=1:size(reads,1)
    if sum(reads(i,:)<cut)==12
        to_exclude(i,:) = zeros;
    end
end
%index out
reads2 = reshape(reads(logical(to_exclude)), [], size(reads,2));
genes2 = genes(logical(to_exclude(:,1)));
chromosome2 = chromosome(logical(to_exclude(:,1)));
description2 = description(logical(to_exclude(:,1)));

%calculate zscore
dataZ = zscore(reads2, [], 2);

%need to impute nan values before doing the PCA
    %no NaNs in the data
[coeff,score,latent,tsquared,explained,mu] = pca(dataZ);

%plot the first two PCs
figure;
clf;
scatter(coeff(1:3,1), coeff(1:3,2))
hold on
scatter(coeff(4:6,1), coeff(4:6,2))
scatter(coeff(7:9, 1), coeff(7:9, 2))
scatter(coeff(10:12,1), coeff(10:12,2))
legend ({var_names{2}, var_names{5}, var_names{8}, var_names{11}})

%so it looks like the biggest difference is between Vir and i8 background

%Make two figures for this:
    %1. Show down regulation of dmist the mutant fish
    %2. Show that the main difference is in the background with PC1
    
figure;
plot(cumsum(explained)/sum(explained), 'k', 'linewidth', 3)
box off;
ylim ([0 1]);
ylabel('Variance Explained', 'FontSize', 14)
xlabel('Number of Principal Components', 'FontSize', 14)
xlim ([0 15])
ax=gca;
ax.XTick=[1:2:15]
ax.YTick = [0:0.2:1]
hold on;
stem(find(cumsum(explained)>95,1), 1, '.', 'color', [0.8 0.8 0.8], 'linewidth', 2)
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained'), 'tiff')

%find row containing dmist 
for i =1:size(genes2,1)
   if strfind('ENSDARG00000095754', genes2{i}) == 1
       dmist = i;
   end
end

%rearrange z-score data
dmistExp = NaN(3,4);
dmistExp(:,1) = dataZ(dmist,1:3); %i8 WT
dmistExp(:,2) = dataZ(dmist,4:6); %i8 Hom
dmistExp (:,3) = dataZ(dmist,7:9); %vir WT
dmistExp(:,4) = dataZ(dmist,10:12); %vir Hom

%do the stats
background(1:6) = 'i';
background (7:12) = 'v';
geno(1:3) = 'w';
geno(4:6) = 'h';
geno = repmat(geno,1,2);
[P,T,STATS,TERMS] = anovan(dmistExp(:), { background, geno}, 'model', 'interaction', 'display', 'off');

%set a colormap for these plots
cmap = [0 0 0; 1 0 1; 0.5 0.5 0.5; 1 0 0];
%plot this
figure;
h=plotSpread(dmistExp, 'distributionColors', cmap, 'showMM', 2);
ax=gca;   
ax.XTickLabel ={var_names{2}, var_names{5}, var_names{8}, var_names{11}};
ax.XTickLabelRotation = 45;   
ax.FontSize = 14;
set(findall(gca, 'type', 'line'), 'markersize', 16) 
h{2}(1).LineWidth = 2;
h{2}(1).Color = [0.8 0.8 0.8];
h{2}.MarkerSize = 8
ylabel ('Z-score expression', 'Fontsize', 12) 
ylim([-2 2]);
%ax.YTick=[-2:0.5:2];
hold on;
text(0.5,2,strcat('bgd interaction, p= ', num2str(P(1))));
text(2,2, strcat('geno interaction, p= ', num2str(P(2))));
text(4,2, strcat('bgd*geno interaction, p= ' , num2str(P(3))));
print(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'DmistExpression'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'DmistExpression.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'DmistExpression'), 'tiff')

%bar charts for dmist expression as well
[h,p] = ttest(dmistExp(:,3), dmistExp(:,4))
figure;
errorbar(nanmean(dmistExp(:,3:4)), nanstd(dmistExp(:,3:4)), '.k', 'Linewidth', 2)
hold on;
b=bar(nanmean(dmistExp(:,3:4)));
b(1).FaceColor = cmap(4,:);
xlim([0 3]);
ylim ([-2 2]);
yticks([-2:0.2:2])
xticks([1:2])
xticklabels({'WT', 'vir'});
box off
ylabel('Z-score expression', 'Fontsize', 14);
text(2, 2, strcat('ttest, p =', num2str(p)));
print(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'VirDmistExpressionBar'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'VirDmistExpressionBar.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'VirDmistExpressionBar'), 'tiff')

%and for i8
[h,p] = ttest(dmistExp(:,1), dmistExp(:,2))
figure;
errorbar(nanmean(dmistExp(:,1:2)), nanstd(dmistExp(:,1:2)), '.k', 'Linewidth', 2)
hold on;
b=bar(nanmean(dmistExp(:,1:2)));
b(1).FaceColor = cmap(2,:);
xlim([0 3]);
ylim ([-2 2]);
yticks([-2:0.2:2])
xticks([1:2])
xticklabels({'WT', 'i8'});
box off
ylabel('Z-score expression', 'Fontsize', 14);
text(2, 2, strcat('ttest, p =', num2str(p)));
print(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'i8DmistExpressionBar'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'i8DmistExpressionBar.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)),'FinalFigures', 'i8DmistExpressionBar'), 'tiff')


%2. Average PC1 score compared as violin plot and do stats
PC1coffs (:,1) = coeff(1:3,1); %i8 wt
PC1coffs(:,2) = coeff(4:6,1); %i8 hom
PC1coffs (:,3) = coeff(7:9,1); %vir wt
PC1coffs(:,4) = coeff(10:12,1); %vir hom
%first do the stats
[P,T,STATS,TERMS] = anovan(PC1coffs(:), { background, geno}, 'model', 'interaction', 'display', 'off');

%plot this
figure;
h=plotSpread(PC1coffs, 'distributionColors', cmap, 'showMM', 2);
ax=gca;   
ax.XTickLabel ={var_names{2}, var_names{5}, var_names{8}, var_names{11}};
ax.XTickLabelRotation = 45;   
ax.FontSize = 14;
set(findall(gca, 'type', 'line'), 'markersize', 16) 
h{2}(1).LineWidth = 2;
h{2}(1).Color = [0.8 0.8 0.8];
h{2}.MarkerSize = 8
ylabel ('PC1 score', 'Fontsize', 12) 
ylim([-0.6 0.8]);
hold on;
text(0.5,0.6,strcat('bgd interaction, p= ', num2str(P(1))));
text(2,0.6, strcat('geno interaction, p= ', num2str(P(2))));
text(4,0.6, strcat('bgd*geno interaction, p= ' , num2str(P(3))));
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC1'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC1.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC1'), 'tiff')

%do the same for PC2 for the supplemental
PC2coffs (:,1) = coeff(1:3,2); %i8 wt
PC2coffs(:,2) = coeff(4:6,2); %i8 hom
PC2coffs (:,3) = coeff(7:9,2); %vir wt
PC2coffs(:,4) = coeff(10:12,2); %vir hom
%first do the stats
[P,T,STATS,TERMS] = anovan(PC2coffs(:), { background, geno}, 'model', 'interaction', 'display', 'off');

%set a colormap for these plots
cmap = [0 0 0; 1 0 1; 0.5 0.5 0.5; 1 0 0];
%plot this
figure;
h=plotSpread(PC2coffs, 'distributionColors', cmap, 'showMM', 2);
ax=gca;   
ax.XTickLabel ={var_names{2}, var_names{5}, var_names{8}, var_names{11}};
ax.XTickLabelRotation = 45;   
ax.FontSize = 14;
set(findall(gca, 'type', 'line'), 'markersize', 16) 
h{2}(1).LineWidth = 2;
h{2}(1).Color = [0.8 0.8 0.8];
h{2}.MarkerSize = 8
ylabel ('PC2 score', 'Fontsize', 12) 
ylim([-0.8 0.8]);
hold on;
text(0.5,0.6,strcat('bgd interaction, p= ', num2str(P(1))));
text(2,0.6, strcat('geno interaction, p= ', num2str(P(2))));
text(4,0.6, strcat('bgd*geno interaction, p= ' , num2str(P(3))));
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC2'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC2.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC2'), 'tiff')

%and PC3
PC3coffs (:,1) = coeff(1:3,3); %i8 wt
PC3coffs(:,2) = coeff(4:6,3); %i8 hom
PC3coffs (:,3) = coeff(7:9,3); %vir wt
PC3coffs(:,4) = coeff(10:12,3); %vir hom
%first do the stats
[P,T,STATS,TERMS] = anovan(PC3coffs(:), { background, geno}, 'model', 'interaction', 'display', 'off');

%set a colormap for these plots
cmap = [0 0 0; 1 0 1; 0.5 0.5 0.5; 1 0 0];
%plot this
figure;
h=plotSpread(PC3coffs, 'distributionColors', cmap, 'showMM', 2);
ax=gca;   
ax.XTickLabel ={var_names{2}, var_names{5}, var_names{8}, var_names{11}};
ax.XTickLabelRotation = 45;   
ax.FontSize = 14;
set(findall(gca, 'type', 'line'), 'markersize', 16) 
h{2}(1).LineWidth = 2;
h{2}(1).Color = [0.8 0.8 0.8];
h{2}.MarkerSize = 8
ylabel ('PC2 score', 'Fontsize', 12) 
ylim([-0.8 0.8]);
hold on;
text(0.5,0.6,strcat('bgd interaction, p= ', num2str(P(1))));
text(2,0.6, strcat('geno interaction, p= ', num2str(P(2))));
text(4,0.6, strcat('bgd*geno interaction, p= ' , num2str(P(3))));
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC3'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC3.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PC3'), 'tiff')
%%
%which genes contribute the most to PC1 and PC2
[B,I] = sort(score(:,1).^2);
I = flip (I);
B = flip (B);

%top_genes
rankPC1 = description2(I(1:10000));
rankPC1_chromosome= chromosome2(I(1:10000));
rankPC1_genes = genes2(I(1:10000));

%for PC2
[B2,I2] = sort(score(:,2).^2);
I2 = flip (I2);
B2 = flip (B2);

%top_genes
rankPC2 = description2(I2(1:10000));
rankPC2_chr = chromosome2(I2(1:10000));
rankPC2_genes = genes2(I2(1:10000));

%import Eirinn's stats results
statsresultsWTcomp = 'C:\Users\ilbar\Documents\MATLAB\RNAseq\RNAseq\DESeq-i8wtVSvirwt-3rdattempt.significant.txt'
statsresultsHomcomp = 'C:\Users\ilbar\Documents\MATLAB\RNAseq\RNAseq\DESeq-i8homVSvirhom-3rdattempt.significant.txt'

dataStatsWT = readtable(statsresultsWTcomp,'Delimiter', '\t');
dataStatsHOM = readtable (statsresultsHomcomp, 'Delimiter', '\t');

%now to find the p values of all the genes in PC1 for WTs
WTsigGenesPC1 = intersect(dataStatsWT.Row_names, rankPC1_genes);
WTsigGenesPC2 = intersect(dataStatsWT.Row_names, rankPC2_genes);

%make a table to export of just the sig genes, score in PC1 and adjusted P
%value
GeneT = cell(size(WTsigGenesPC1,1),1);
nameT = cell(size(WTsigGenesPC1,1),1);
AdjPv = NaN(size(WTsigGenesPC1,1),1);
PC1 = NaN(size(WTsigGenesPC1,1),1);
log2direction = NaN(size(WTsigGenesPC1,1),1);
for i =1:size(WTsigGenesPC1,1)
   %find intersection 
   [~,~,ib] = intersect(WTsigGenesPC1{i}, dataStatsWT.Row_names);
    GeneT {i} =char(dataStatsWT.Row_names(ib));
    nameT{i} = char(dataStatsWT.name(ib));
    AdjPv(i) = dataStatsWT.padj(ib);
    log2direction(i) = dataStatsWT.log2FoldChange(ib);
    [~,~,ic] = intersect(WTsigGenesPC1{i},rankPC1_genes);
    PC1 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC1 = table(GeneT, nameT, AdjPv, PC1, log2direction);
WTstatPC1 = sortrows(statPC1, {'PC1'}, {'descend'});
writetable (statPC1, fullfile(pathname, 'PC1genestatsWT.xlsx'));
clear GeneT nameT AdjPv PC1 statPC1 log2direction

%repeat for PC2
GeneT = cell(size(WTsigGenesPC2,1),1);
nameT = cell(size(WTsigGenesPC2,1),1);
AdjPv = NaN(size(WTsigGenesPC2,1),1);
PC2 = NaN(size(WTsigGenesPC2,1),1);
log2direction = NaN(size(WTsigGenesPC2,1),1);
for i =1:size(WTsigGenesPC2,1)
   %find intersection 
   [~,~,ib] = intersect(WTsigGenesPC2{i}, dataStatsWT.Row_names);
    GeneT {i} =char(dataStatsWT.Row_names(ib));
    nameT{i} = char(dataStatsWT.name(ib));
    AdjPv(i) = dataStatsWT.padj(ib);
    log2direction(i) = dataStatsWT.log2FoldChange(ib);
    [~,~,ic] = intersect(WTsigGenesPC2{i},rankPC2_genes);
    PC2 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC2 = table(GeneT, nameT, AdjPv, PC2, log2direction);
WTstatPC2 = sortrows(statPC2, {'PC2'}, {'descend'});
writetable (statPC2, fullfile(pathname, 'PC2genestatsWT.xlsx'));
clear nameT GeneT AdjPv PC2 statPC2 log2direction

%and for homs
HOMsigGenesPC1 = intersect(dataStatsHOM.Row_names, rankPC1_genes);
HOMsigGenesPC2 = intersect(dataStatsHOM.Row_names, rankPC2_genes);

%make a table to export of just the sig genes, score in PC1 and adjusted P
%value
GeneT = cell(size(HOMsigGenesPC1,1),1);
nameT = cell(size(HOMsigGenesPC1,1),1);
AdjPv = NaN(size(HOMsigGenesPC1,1),1);
PC1 = NaN(size(HOMsigGenesPC1,1),1);
log2direction = NaN(size(HOMsigGenesPC1,1),1);
for i =1:size(HOMsigGenesPC1,1)
   %find intersection 
   [~,~,ib] = intersect(HOMsigGenesPC1{i}, dataStatsHOM.Row_names);
    GeneT {i} =char(dataStatsHOM.Row_names(ib));
    nameT{i} = char(dataStatsHOM.name(ib));
    AdjPv(i) = dataStatsHOM.padj(ib);
    log2direction(i) = dataStatsHOM.log2FoldChange(ib);
    [~,~,ic] = intersect(HOMsigGenesPC1{i},rankPC1_genes);
    PC1 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC1 = table(GeneT, nameT, AdjPv, PC1, log2direction);
HOMstatPC1 = sortrows(statPC1, {'PC1'}, {'descend'});
writetable (statPC1, fullfile(pathname, 'PC1genestatsHOM.xlsx'));
clear GeneT nameT AdjPv PC1 statPC1 log2direction

%repeat for PC2
GeneT = cell(size(HOMsigGenesPC2,1),1);
nameT = cell(size(HOMsigGenesPC2,1),1);
AdjPv = NaN(size(HOMsigGenesPC2,1),1);
PC2 = NaN(size(HOMsigGenesPC2,1),1);
log2direction = NaN(size(HOMsigGenesPC2,1),1);
for i =1:size(HOMsigGenesPC2,1)
   %find intersection 
   [~,~,ib] = intersect(HOMsigGenesPC2{i}, dataStatsHOM.Row_names);
    GeneT {i} =char(dataStatsHOM.Row_names(ib));
    nameT{i} = char(dataStatsHOM.name(ib));
    AdjPv(i) = dataStatsHOM.padj(ib);
    log2direction(i) = dataStatsHOM.log2FoldChange(ib);
    [~,~,ic] = intersect(HOMsigGenesPC2{i},rankPC2_genes);
    PC2 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC2 = table(GeneT, nameT, AdjPv, PC2, log2direction);
HOMstatPC2 = sortrows(statPC2, {'PC2'}, {'descend'});
writetable (statPC2, fullfile(pathname, 'PC2genestatsHOM.xlsx'));
clear nameT GeneT AdjPv PC2 statPC2 log2direction

%what are the similar genes between WT and Hom i8vsVir comparisons?
    %need to take into account the direction of change - filter for same
    %direction of change as well
backgroundGenes = intersect(WTstatPC1.GeneT, HOMstatPC1.GeneT);
bgtableWT = table;
bgtableHOM = table;
for i=1:size(backgroundGenes,1)
    bgtableWT = [bgtableWT; WTstatPC1(strcmp(WTstatPC1.GeneT, backgroundGenes{i}),:)];
    bgtableHOM = [bgtableHOM; HOMstatPC1(strcmp(HOMstatPC1.GeneT, backgroundGenes{i}),:)];
end
%only keep genes that are significant in the same direction
sameDirection = intersect(find(bgtableWT.log2direction<0), find(bgtableHOM.log2direction<0));
bgtableWT = bgtableWT(sameDirection,:);
bgtableHOM = bgtableHOM(sameDirection,:);
writetable(bgtableWT, fullfile(pathname, 'backgroundGenestatsWT.xlsx'));
writetable(bgtableHOM, fullfile(pathname, 'backgroundGenestatsHOM.xlsx'));

%make a plot
    %for every background gene plot its contribution to PC1 as a %
sigBackgene_weights = NaN(10000,1);
for i=1:size(bgtableWT,1)
    sigBackgene_weights(find(strcmp(rankPC1_genes, bgtableWT.GeneT{i}))) = ...
        B(find(strcmp(rankPC1_genes, bgtableWT.GeneT{i})));
end

%plot this
figure;
bar((B(1:10000)/sum(B))*100, 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', [0.9 0.9 0.9]);
hold on;
bar((sigBackgene_weights/sum(B))*100, 'r');
xlim([0 10000]);
ylim ([0 0.025]);
xlabel ('Number of Genes', 'FontSize', 14);
ylabel ('% contribution to PC1', 'FontSize', 14);
legend ({'p>0.05' 'p<0.05'}, 'FontSize', 14);
box off
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC1genes'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC1genes.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC1genes'), 'tiff')

%same for PC2 as a comparison
backgroundGenesPC2 = intersect(WTstatPC2.GeneT, HOMstatPC2.GeneT);
bgtableWTPC2 = table;
bgtableHOMPC2 = table;
for i=1:size(backgroundGenesPC2,1)
    bgtableWTPC2 = [bgtableWTPC2; WTstatPC2(strcmp(WTstatPC2.GeneT, backgroundGenesPC2{i}),:)];
    bgtableHOMPC2 = [bgtableHOMPC2; HOMstatPC2(strcmp(HOMstatPC2.GeneT, backgroundGenesPC2{i}),:)];
end
%only keep genes that are significant in the same direction
sameDirectionPC2 = intersect(find(bgtableWTPC2.log2direction<0), ...
    find(bgtableHOMPC2.log2direction<0));
bgtableWTPC2 = bgtableWTPC2(sameDirectionPC2,:);
bgtableHOMPC2 = bgtableHOMPC2(sameDirectionPC2,:);
writetable(bgtableWTPC2, fullfile(pathname, 'backgroundGenestatsWTPC2.xlsx'));
writetable(bgtableHOMPC2, fullfile(pathname, 'backgroundGenestatsHOMPC2.xlsx'));

%make a plot
    %for every background gene plot its contribution to PC1 as a %
sigBackgene_weightsPC2 = NaN(10000,1);
for i=1:size(bgtableWTPC2,1)
    sigBackgene_weightsPC2(find(strcmp(rankPC2_genes, bgtableWTPC2.GeneT{i}))) = ...
        B2(find(strcmp(rankPC2_genes, bgtableWTPC2.GeneT{i})));
end

%plot this
figure;
bar((B2(1:10000)/sum(B2))*100, 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', [0.9 0.9 0.9]);
hold on;
bar((sigBackgene_weightsPC2/sum(B2))*100, 'b');
xlim([0 10000]);
ylim ([0 0.025]);
xlabel ('Number of Genes', 'FontSize', 14);
ylabel ('% contribution to PC2', 'FontSize', 14);
legend ({'p>0.05' 'p<0.05'}, 'FontSize', 14);
box off
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC2genes'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC2genes.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'SortedPC2genes'), 'tiff')

%% actually want to compare HOMvsWT in both i8 and vir and see if there is
%any overlap

%import Eirinn's stats results
statsresultsi8comp = 'C:\Users\ilbar\Documents\MATLAB\RNAseq\RNAseq\DESeq-i8homVSi8wt-3rdattempt.significant.txt'
statsresultsVIRcomp = 'C:\Users\ilbar\Documents\MATLAB\RNAseq\RNAseq\DESeq-virhomVSvirwt-3rdattempt.significant.txt'

dataStatsi8 = readtable(statsresultsi8comp,'Delimiter', '\t');
dataStatsVIR = readtable (statsresultsVIRcomp, 'Delimiter', '\t');

HomGenes = intersect(dataStatsi8.name, dataStatsVIR.name)

i8P = table;
virP = table;
for i=1:size(HomGenes,1)
   i8P = [i8P; dataStatsi8(find(strcmp(dataStatsi8.name, HomGenes{i})),:)];
   virP = [virP; dataStatsVIR(find(strcmp(dataStatsVIR.name, HomGenes{i})),:)];
end

writetable(i8P, fullfile(pathname, 'i8Overlapstats.xls'));
writetable(virP, fullfile(pathname, 'virOverlapstats.xls'));

%make a table to export of just the sig genes, score in PC1 and adjusted P
%value
GeneT = cell(size(i8sigGenesPC1,1),1);
nameT = cell(size(i8sigGenesPC1,1),1);
AdjPv = NaN(size(i8sigGenesPC1,1),1);
PC1 = NaN(size(i8sigGenesPC1,1),1);
for i =1:size(i8sigGenesPC1,1)
   %find intersection 
   [~,~,ib] = intersect(i8sigGenesPC1{i}, dataStatsi8.Row_names);
    GeneT {i} =char(dataStatsi8.Row_names(ib));
    nameT{i} = char(dataStatsi8.name(ib));
    AdjPv(i) = dataStatsi8.padj(ib);
    [~,~,ic] = intersect(i8sigGenesPC1{i},rankPC1_genes);
    PC1 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC1 = table(GeneT, nameT, AdjPv, PC1);
i8statPC1 = sortrows(statPC1, {'PC1'}, {'descend'});
writetable (statPC1, fullfile(pathname, 'PC1genestatsi8.xlsx'));
clear GeneT nameT AdjPv PC1 statPC1

%repeat for PC2
GeneT = cell(size(i8sigGenesPC2,1),1);
nameT = cell(size(i8sigGenesPC2,1),1);
AdjPv = NaN(size(i8sigGenesPC2,1),1);
PC2 = NaN(size(i8sigGenesPC2,1),1);
for i =1:size(i8sigGenesPC2,1)
   %find intersection 
   [~,~,ib] = intersect(i8sigGenesPC2{i}, dataStatsi8.Row_names);
    GeneT {i} =char(dataStatsi8.Row_names(ib));
    nameT{i} = char(dataStatsi8.name(ib));
    AdjPv(i) = dataStatsi8.padj(ib);
    [~,~,ic] = intersect(i8sigGenesPC2{i},rankPC2_genes);
    PC2 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC2 = table(GeneT, nameT, AdjPv, PC2);
i8statPC2 = sortrows(statPC2, {'PC2'}, {'descend'});
writetable (statPC2, fullfile(pathname, 'PC2genestatsi8.xlsx'));
clear nameT GeneT AdjPv PC2 statPC2

%and for homs
VIRsigGenesPC1 = intersect(dataStatsVIR.Row_names, rankPC1_genes);
VIRsigGenesPC2 = intersect(dataStatsVIR.Row_names, rankPC2_genes);

%make a table to export of just the sig genes, score in PC1 and adjusted P
%value
GeneT = cell(size(VIRsigGenesPC1,1),1);
nameT = cell(size(VIRsigGenesPC1,1),1);
AdjPv = NaN(size(VIRsigGenesPC1,1),1);
PC1 = NaN(size(VIRsigGenesPC1,1),1);
for i =1:size(VIRsigGenesPC1,1)
   %find intersection 
   [~,~,ib] = intersect(VIRsigGenesPC1{i}, dataStatsVIR.Row_names);
    GeneT {i} =char(dataStatsVIR.Row_names(ib));
    nameT{i} = char(dataStatsVIR.name(ib));
    AdjPv(i) = dataStatsVIR.padj(ib);
    [~,~,ic] = intersect(VIRsigGenesPC1{i},rankPC1_genes);
    PC1 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC1 = table(GeneT, nameT, AdjPv, PC1);
VIRstatPC1 = sortrows(statPC1, {'PC1'}, {'descend'});
writetable (statPC1, fullfile(pathname, 'PC1genestatsVIR.xlsx'));
clear GeneT nameT AdjPv PC1

%repeat for PC2
GeneT = cell(size(VIRsigGenesPC2,1),1);
nameT = cell(size(VIRsigGenesPC2,1),1);
AdjPv = NaN(size(VIRsigGenesPC2,1),1);
PC2 = NaN(size(VIRsigGenesPC2,1),1);
for i =1:size(VIRsigGenesPC2,1)
   %find intersection 
   [~,~,ib] = intersect(VIRsigGenesPC2{i}, dataStatsVIR.Row_names);
    GeneT {i} =char(dataStatsVIR.Row_names(ib));
    nameT{i} = char(dataStatsVIR.name(ib));
    AdjPv(i) = dataStatsVIR.padj(ib);
    [~,~,ic] = intersect(VIRsigGenesPC2{i},rankPC2_genes);
    PC2 (i)= B(ic);
    clear ib ic
end

%make into table to export to excel
statPC2 = table(GeneT, nameT, AdjPv, PC2);
VIRstatPC2 = sortrows(statPC2, {'PC2'}, {'descend'});
writetable (statPC2, fullfile(pathname, 'PC2genestatsVIR.xlsx'));
clear nameT GeneT AdjPv PC2


