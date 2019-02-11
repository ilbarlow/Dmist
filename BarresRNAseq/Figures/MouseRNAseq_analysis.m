%cluster analysis of barres lab rna seq
    %use to find mouse Dmist in RNA seq data from isolated cell types and
    %compare expression of canonical cell type markers to expression
    %profile of dmist
    
    %1. import xls spreadsheet without data labels
    %2. filter low expressed transcripts
        %any FPKM that was found to be low was arbitrarily set to a value of 0.1 in
        %the matrix so sum across rows in matrix to find rows in which expression
        %was too low or no fold change between cell type (ie == 0.7)

addpath (genpath('C:\Users\ilbar\Documents\MATLAB\DreammistPaper'));
fname = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\BarresRNAseq\Data\barreslab_rnaseq.xlsx';
[data, geneNames, ~] = xlsread(fname);
cellTypes = geneNames(1,2:end);
geneNames = geneNames(2:end,1);

%filter data
dataFiltered = reshape(data(repmat(sum(data,2)>0.7, 1,7)),[],7);
geneNamesFiltered = geneNames(sum(data,2)>0.7);

%zscore data
dataFilteredZ = zscore(dataFiltered);

%% cluster data by standardising across rows (so that mean across rows is 0) and labeling with the gene list
%and cell type
cmap1 = colormap(redbluecmap);
cgo = clustergram(dataFiltered,'Rowlabels',geneNamesFiltered,'ColumnLabels',cellTypes,'Standardize',2);
colorbar
set(cgo,'Colormap',cmap1)
cgo.ColumnLabelsRotate = 45;
ClustergramDmist = strfind(cgo.RowLabels, '1500011B03Rik');
for i = 1:size(ClustergramDmist,1) 
    if ClustergramDmist{i} == 1
        DmistLoc = i; 
    end 
end 
DmistLoc; %indicates row number where dmist is

%% Pearson correlation
%Find where dreammist lies in the original panel 
found = strfind(geneNamesFiltered, '1500011B03Rik'); 
for i = 1:size(found,1) 
    if found{i} == 1 
        Dmist = i; 
    end 
end 
Dmist; %indicates row number where dmist is

%pearson correlation of all genes
[RHO, PVAL]=corr(dataFiltered'); % RHO is a matrix that contains correlation coefficients for each gene; RHO is p value of no correlation

%Organises distances from dreammist - IX_pC is the pearson correlation coefficient, O is the row number (ie. gene)
%Correlation Analysis 
[IX,O] = sort(RHO(Dmist,:));
sortedNames = geneNamesFiltered(O);

%Now find cell-type markers genes and their corresponding correlation value

%oligodendrocyte makers
    %make cell arrray with marker genes in
oligod = {'Pdgfra', 'Cspg4', 'Enpp6', 'Nfasc', 'Plp', 'Mog', 'Mbp', 'Mobp'};

%find in rank correlation lis
for c = 1:size(oligod,2) %every gene
    zzz  = strfind (sortedNames, oligod{1,c}); %find name in sorted names(Z scores)
        for i = 1:size (zzz,1)
            if zzz{i} ==1 %row where name is found
               oligod {2,c} (1) = i; %put in row number
               oligod {2,c}(2) = IX(i); %and rank correlation score
            end
        end
    clear zzz
end

%astrocytes
astrocytes = {'Gfap', 'Aldh1l1', 'Slc1a3', 'Aqp4'};

%find in rank correlation lis
for c = 1:size(astrocytes,2)
    zzz  = strfind (sortedNames, astrocytes{1,c}); %find name in sorted names(Z scores)
        for i = 1:size (zzz,1)
            if zzz{i} ==1 %row where name is found
               astrocytes {2,c} (1) = i; %put in row number
               astrocytes {2,c}(2) = IX(i); %and rank correlation score
            end
        end
    clear zzz
end

%Microglia markers
microglia = {'Ccl3', 'Cd11b', 'Tnf'};

  %find in rank correlation lis
for c = 1:size(microglia,2)
    zzz  = strfind (sortedNames, microglia{1,c}); %find name in sorted names(Z scores)
        for i = 1:size (zzz,1)
            if zzz{i} ==1 %row where name is found
               microglia {2,c} (1) = i; %put in row number
               microglia {2,c}(2) = IX(i); %and rank correlation score
            end
        end
    clear zzz
end

 
%endothelial cells
endothelial = {'Cldn5', 'Flt1', 'Esam'};

  %find in rank correlation lis
for c = 1:size(endothelial,2)
    zzz  = strfind (sortedNames, endothelial{1,c}); %find name in sorted names(Z scores)
        for i = 1:size (zzz,1)
            if zzz{i} ==1 %row where name is found
                endothelial {2,c} (1) = i; %put in row number
                endothelial {2,c}(2) = IX(i); %and rank correlation score
            end
        end
    clear zzz
end

%neuronal markers
neuron = {'Tubb', 'Stmn2', 'Snap25', 'Eno2', 'Syn1'};

  %find in rank correlation lis
for c = 1:size(neuron,2)
    zzz  = strfind (sortedNames, neuron{1,c}); %find name in sorted names(Z scores)
        for i = 1:size (zzz,1)
            if zzz{i} ==1 %row where name is found
                neuron {2,c} (1) = i; %put in row number
                neuron {2,c}(2) = IX(i); %and rank correlation score
            end
        end
    clear zzz
end

%% plot bar chart of average values

%make cell array with just the marker rank correlation score and locations
markers_ranks {1} = cell2mat(oligod(2,:)');
markers_ranks {2} = cell2mat(astrocytes(2,:)');
markers_ranks{3} = cell2mat(neuron(2,:)');
markers_ranks{4} = cell2mat(endothelial(2,:)');
markers_ranks{5} = cell2mat(microglia(2,:)');

%now sort into values for bar chart
marker_chart = NaN(2, size(markers_ranks,1));
for i =1:size(markers_ranks,2)
   marker_chart (1,i) = nanmean(markers_ranks{i}(:,2));
   marker_chart (2,i) = nanstd(markers_ranks{i}(:,2));
end

%now make bar chart figure
figure; 
bar(marker_chart(1,:),0.5, 'facecolor', 'k'); %plot average correlation score for 
hold on;
errorbar (marker_chart(1,:), marker_chart(2,:), 'k.', 'linewidth', 2);
ax = gca;
ax.XTickLabel = {'Oligodendrocyte' 'Astrocyte' 'Neuron' 'Endothelial Cell' 'Microglia'};
ax.XTickLabelRotation =45;
ax.FontSize = 14;
ylabel ('Pearson correlation score', 'Fontsize', 16);
xlabel ('Cell Type', 'Fontsize', 16);
box off
print(fullfile(fileparts(fileparts(fname)), 'Figures', 'Correlation_barchart'),...
    '-depsc', '-tiff');
savefig(fullfile(fileparts(fileparts(fname)), 'Figures', 'Correlation_barchart.fig'));
saveas(gcf, fullfile(fileparts(fileparts(fname)), 'Figures', 'Correlation_barchart.tiff'), 'tiff')

%make table for stats
markers_table = NaN(8,5); %make table to fit the data into
for i=1:size(markers_table,2)
   markers_table(1:size(markers_ranks{i},1), i) = markers_ranks{i}(:,2); 
end

%STATS
[p, anovatab, stats]= kruskalwallis (markers_table);
[c,m] = multcompare(stats, 'ctype', 'dunn-sidak');

%write to excel
xlswrite(fullfile(fileparts(fileparts(fname)), 'PearsonStats'), markers_table, 'CorrValues');
xlswrite(fullfile(fileparts(fileparts(fname)), 'PearsonStats'), ...
    {'Oligodendrocyte' 'Astrocyte' 'Neuron' 'Endothelial Cell' 'Microglia'} , 'Celltypes');
xlswrite(fullfile(fileparts(fileparts(fname)), 'PearsonStats'), c, 'Stats');