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
%deviations of average across all genes

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

%calculate zscore
dataZ = zscore(reads, [], 2);


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
hold on;
stem(find(cumsum(explained)>95,1), 1, '.', 'color', [0.8 0.8 0.8], 'linewidth', 2)
print(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained'), '-depsc', '-tiff')
savefig(fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained.fig'))
saveas(gcf, fullfile(fileparts(fileparts(pathname)), 'FinalFigures', 'PCvarExplained'), 'tiff')


%find row containing dmist 
for i =1:size(genes,1)
   if strfind('ENSDARG00000095754', genes{i}) == 1
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

%which genes contribute the most to PC1 and PC2
[B,I] = sort(score(:,1));
I = flip (I);
B = flip (B);

%top_genes
top_PC1 = description(I(1:50))
topPC1_chromosome= chromosome(I(1:50));

%for PC2
[B2,I2] = sort(score(:,2))
I2 = flip (I2)
B2 = flip (B2)

%top_genes
top_PC2 = description(I2(1:50))
top_PC2chr = chromosome(I2(1:50));

%also try PCA on just the i8 dataset
data_i8 = reads(:,1:6);
data_i8z = zscore(data_i8,[], 2);

[coeff_i8,score_i8,latent,tsquared,explained,mu] = pca(data_i8z);

figure;
clf;
scatter(coeff_i8(1:3,1), coeff_i8(1:3,2))
hold on
scatter(coeff_i8(4:6,1), coeff_i8(4:6,2))

%also try PCA on just the i8 dataset
data_vir = reads(:,7:12);
data_virz = zscore(data_vir,[], 2);

[coeff_vir,score_vir,latent,tsquared,explained,mu] = pca(data_virz);

figure;
scatter(coeff_vir(1:3,1), coeff_vir(1:3,2))
hold on
scatter(coeff_vir(4:6,1), coeff_vir(4:6,2))


%% so now do stats

dmisti8hom = NaN()
dmisti8wt = NaN()

dmisti8wt = reads(:,1:3)';
dmisti8hom = reads(:,4:6)';
dmistvirwt = reads(:, 7:9)';
dmistvirhom = reads(:,10:12)';
dmisthom_all = vertcat(reads(:,4:6)', reads(:,10:12)');
dmistwt_all = vertcat(reads(:,1:3)', reads(:,7:9)');

%rank sum test to compare
pVals = NaN(3, size(dmisti8wt,2));
for i =1:size(dmisti8wt,2)
   [~, pVals(1,i)] = ttest(dmisti8hom(:,i), dmisti8wt(:,i));
   [~, pVals(2,i)] = ttest(dmistvirhom(:,i), dmistvirwt(:,i));
   [~, pVals(3,i)] = ttest(dmisthom_all(:,i), dmistwt_all(:,i));
end
    
%now correct for multiple comparisons
[pVals_corr, h] = bonf_holm(pVals);

sum(sum(h))