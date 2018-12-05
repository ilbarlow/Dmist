%qPCR analysis for RNAseq

%% open qpcr excel sheet

[filename, pathname] = uigetfile({'*.xlsx' '*.xls'}, 'Select qPCR file');

uiopen (strcat(pathname, filename),1)

%% sort data - 1st cell housekeeping, 2nd cell dmist 3rd cell ankrd13a, 4th
%ef1alpha
data {1,1} (1:3,1) = Cq(1:3); %i8/i8
data {1,1}(1:3,2) = Cq(4:6); % i8 +/+
data {1,2} (1:3,1) = Cq(7:9); % vir/vir
data {1,2}(1:3,2) = Cq(10:12); %vir +/+
%dmist
data {2,1} (1:3,1) = Cq (13:15); %i8/i8
data {2,1} (1:3,2) = Cq (16:18); %i8 WT
data{2,2}(1:3,1) = Cq (19:21); %vir/vir
data{2,2}(1:3,2) = Cq(22:24); %vir +/+

%% normalise to housekeeping gene
for i=1:2
    dmist_norm{i} = data{1,i} - data{2,i};
end

%calculate relative cDNA value
for i =1:2 %each allele
    for j=1:2 %each genotype
        cDNA_dmist {i}(:,j) = power(2,dmist_norm{i}(:,j));
    end
end

%calculate mean
for i=1:2
    mean_dmist(i,:) = nanmean(cDNA_dmist{i});
    std_dmist(i,:) = nanstd(cDNA_dmist{i}); %and standard dev
end
clear i j


%make table for plotting bar chart
for i =1:2
    for g=1:2
    mean_express (i,g) = mean_dmist(i,g)/mean_dmist(i,2); %dmist

    std_express (i,g) =std_dmist (i,g)/ mean_dmist(i,2);
    end
end

%dmist

for i=1:2
    figure;
    bar(fliplr(mean_express(i,:)), 'k', 'Barwidth', 0.5)
    hold on;
    errorbar(1:2, fliplr(mean_express(i,:)), fliplr(std_express(i,:)), '.k', 'Linewidth', 2);
    ax = gca;
    ax.XTickLabel = {'+/+' '-/-'}
    ax.YTick = [0:0.2:1.5];
    set(gca, 'Fontsize', 16)
    ylabel('Relative expression', 'Fontsize' ,18);
    xlabel('Genotype', 'FontSize', 18);
    title ('Dreammist', 'Fontsize', 22)
    box off
end
