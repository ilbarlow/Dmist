% compare i8, vir, and i8WT background fingerprints
    % import data sets and load sleep/wake summaries for the WTs
    % Z-score
    % plot a comparison of the average Z score for each background

%assign directories and WT positions
inputs  = cell(3,1);
WTpos = NaN(3,1);
inputs {1}= 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LD\RawData'; %i8 data
WTpos(1) = 3;
inputs{2} = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmistvir\IdaExpsLD\RawData'; %vir data
WTpos(2) = 1;
inputs{3} ='C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8vir\LD\RawData'; %i8vir data
WTpos (3) = 1; 

saveDir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\BackgroundTests'; %save directory

%find the files in each directory
files = cell(3,1);
for i=1:size(inputs,1)
   files{i} = dir(inputs{i}); 
end

%load the workspaces
%now load the .mat files - top file is .DS_store hidden file
%sleepStructure = struct([]);
for i = 1:size(files,1)
    for j =1:size(files{i},1)
        if startsWith(files{i}(j).name, '.') ==1
            continue
        else
            sleepStructure(i,j).geno = load(fullfile(inputs{i}, files{i}(j).name));
            sleepStructure(i,j).name = files{i}(j).name;
        end
    end
end

%remove empty fields
sleepStructure2 = cell(3,1);
for i =1:size(sleepStructure,1)
    temp = sleepStructure(i,:);
    sleepStructure2{i} = temp(~cellfun(@isempty,{sleepStructure(i,:).geno}))';
    clear temp
end
clear sleepStructure

%find then number of fish in each experiment and condition
nFish = cell(3,1);
nConditions = [3,3,4]; %number of genotypes for each background
for b =1:size(sleepStructure2,1)
    nFish{b} = NaN(size(sleepStructure2,2), nConditions(b));
    for e=1:size(sleepStructure2{b},1)
        for g = 1:nConditions(b)
            nFish {b}(e,g) = size(sleepStructure2{b}(e).geno.geno.data{g},2);
        end
    end
end

%% now load in the summary data for each experiment

%make summary table of sleep parameters
%for both experiments and look at day and night sleep architecture - only
    %for days two and three (ie complete days and nights)
sleepD = cell(size(sleepStructure2,1),1);
sleepN = cell(size(sleepStructure2,1),1);
sleepBoutD = cell(size(sleepStructure2,1),1);
sleepBoutN = cell(size(sleepStructure2,1),1);
sleepLengthD = cell(size(sleepStructure2,1),1);
sleepLengthN = cell(size(sleepStructure2,1),1);
wActivityD = cell(size(sleepStructure2,1),1);
wActivityN = cell(size(sleepStructure2,1),1);
for i = 1:size(sleepStructure2,1) %each experiment
    for j=1:size(sleepStructure2{i},1)
        sleepD {i,j} = nan(max(nFish{i}(j,:)),4); %nan table to fit data into    
        sleepBoutD {i,j} = nan(max(nFish{i}(j,:)),4);    
        sleepLengthD {i,j} = nan(max(nFish{i}(j,:)),4);    
        sleepN {i,j} = nan(max(nFish{i}(j,:)),4);   
        sleepBoutN {i,j} = nan(max(nFish{i}(j,:)),4);    
        sleepLengthN {i,j} = nan(max(nFish{i}(j,:)),4);    
        wActivityD {i,j} = nan(max(nFish{i}(j,:)),4);    
        wActivityN {i,j} = nan(max(nFish{i}(j,:)),4);
        for k=1:size(sleepStructure2{i}(j).geno.geno.data,2) %each genotype
            sleepD {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleep.day{k}(2:3,:))'; % fill in average day sleep
            sleepBoutD {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleepBout.day{k}(2:3,:))'; %average day sleep bout
            sleepLengthD{i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleepLength.day{k}(2:3,:))'; %average day sleep bout length
            sleepN {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleep.night{k}(2:3,:))'; % average night sleep (total)
            sleepBoutN {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleepBout.night{k}(2:3,:))'; %average night sleep bout
            sleepLengthN{i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.sleepLength.night{k}(2:3,:))'; %average night sleep bout length
            wActivityD {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.averageWaking.day{k}(2:3,:))';%average day wactivity
            wActivityN {i,j} (:,k) = ...
                nanmean(sleepStructure2{i}(j).geno.geno.summarytable.averageWaking.night{k}(2:3,:))'; %average night wactivity
        end
    end
end

%now prepare data for Z-scoring

%make inline function for zscore
zsc = @(x) ((x - nanmean(x))/nanstd(x));

%now can actually organise
features = cell(8,1);
bg = cell(3,1);
featuresNames = {'Day sleep' 'Night sleep' 'Day sleep bouts' '#Night sleep bouts'...
    'Day sleep bout length' 'Night sleep bout length' 'Day wactivity' 'night wactivity'};
for i=1:size(sleepD,1)
   temp = cell2mat(sleepD(i,:)');
   features{1} =  [features{1}; temp(:,WTpos(i))];
   bg{i}(1:size(temp,1),1) = i; 
   clear temp
   temp = cell2mat(sleepN(i,:)');
   features{2} =[features{2}; temp(:,WTpos(i))];
   clear temp
   temp = cell2mat(sleepBoutD(i,:)');
   features{3} =[features{3}; temp(:,WTpos(i))];
   clear temp
   temp = cell2mat(sleepBoutN(i,:)');
   features{4} = [features{4}; temp(:,WTpos(i))];
   clear temp
   temp = cell2mat(sleepLengthD(i,:)');
   features{5} = [features{5}; temp(:,WTpos(i))];
   clear temp
   temp = cell2mat(sleepLengthN(i,:)');
   features{6} = [features{6}; temp(:, WTpos(i))];
   clear temp
   temp = cell2mat(wActivityD(i,:)');   
   features{7} = [features{7}; temp(:,WTpos(i))];
   clear temp
   temp = cell2mat(wActivityN(i,:)');      
   features{8}= [features{8}; temp(:,WTpos(i))];
   clear temp
end

%make array for indexings
bgArray = cell2mat(bg);

%Zscore and sort
featuresZ = cell(8,1);
i8z = cell(8,1);
virz = cell(8,1);
i8vir = cell(8,1);
for i=1:size(features,1)
   featuresZ{i} = zsc(features{i}); 
   
   %sort by background
   i8z{i} = featuresZ{i}(bgArray ==1);
   virz{i} = featuresZ{i}(bgArray ==2);
   i8virz{i} = featuresZ{i}(bgArray ==3);
end

%do stats - need to put each feature into matrices for each feature
P = NaN(8,1);
mult = cell(8,1);
for i =1:size(featuresZ,1)
    [P(i), ~, stats]= kruskalwallis (featuresZ{i}, bgArray, 'off');
    mult {i} = multcompare(stats);
    close;
end

for p = 1:size(mult,1)
    xlswrite(fullfile(saveDir, 'WTfeaturesStats.xls'),...
        mult{p}, featuresNames{p}) 
end

%take mean and std for plotting
zSummary (1,:) = nanmean(cell2mat(i8z'));
zSummary (2,:) = nanmean(cell2mat(virz'));
zSummary (3,:) = nanmean(cell2mat(i8virz'));

zSummarySem (1,:) = nanstd(cell2mat(i8z'))/sqrt(sum(~isnan(i8z{1})));
zSummarySem (2,:) = nanstd(cell2mat(virz'))/sqrt(sum(~isnan(virz{1})));
zSummarySem (3,:) = nanstd(cell2mat(i8virz'))/sqrt(sum(~isnan(i8virz{1})));

cmap = [221/255 181/255 213/255; 249/255, 104/255, 124/255; ...
    126/255 214/255 212/255];
names = {'i8WT' 'virWT' 'i8virWT'};

figure;
for i=1.5:2:8.5
    rectangle ('Position', [i -2 2 4], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
    hold on;
    rectangle ('Position', [i+1 -2 2 4], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
end
for g=1:size(zSummary,1) %every genotype
    errorbar(zSummary(g,:), zSummarySem(g,:), 'o', 'Color', ...
        cmap(g,:), 'Markerfacecolor', cmap(g,:), 'Linewidth', 2);
    hold on
    Leg{g} = strcat(names{g}, ', n=', num2str(sum(nFish{g}(:,WTpos(g)))));
end
box off;
xlim ([0.5 8.5]);
ylim([-1.5 1.5]);
ax=gca;
ax.XTick = [1.5:2:7.5];
ax.XTickLabel = {'Sleep' 'Sleep Bouts' 'Sleep bout length' 'Waking Activity'};
ax.XTickLabelRotation = 45;
ax.FontSize = 16;
ax.YTick = [-1.4:0.2:1.4];
ylabel ('Z-score', 'FontSize', 16);
legend (Leg, 'FontSize', 12, 'location', 'southwest');
%plot stats on top
for i=1:size(P,1)
  text(i-0.25, 1.3, strcat('P=', num2str(P(i))), 'Fontsize', 14) 
end
print(fullfile(saveDir, 'ZscoreSummary'), '-depsc', '-tiff')
saveas(gcf,fullfile(saveDir, 'ZscoreSummary.tif')); 
savefig(fullfile(saveDir, 'ZscoreSummary.fig'));