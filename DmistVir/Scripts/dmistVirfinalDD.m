%Updated final analysis for paper with new style distribution plots

%% load data

%pick folder with experiments in
folder = uigetdir; %select folder with .mat workspaces to be concatenated

files =dir(folder);

%load the workspaces
%now load the .mat files - top file is .DS_store hidden file
%sleepStructure = struct([]);
for i = 1:size(files,1)
    if startsWith(files(i).name, '.') ==1
        continue
    else
        sleepStructure(i).geno = load(fullfile(folder, files(i).name));
        sleepStructure(i).name = files(i).name
    end
end

%remove empty fields
sleepStructure = sleepStructure(~cellfun(@isempty,{sleepStructure.geno}));

LB = NaN(7, size(sleepStructure,2));
nFish = NaN(size(sleepStructure,2), 3);
for i = 1:size (sleepStructure,2)
    LB(1:7,i) = find(sleepStructure(i).geno.geno.lightboundries)/10;
    for g=1:size(sleepStructure(i).geno.geno.data,2)
        nFish (i,g) = size(sleepStructure(i).geno.geno.data{g},2);
    end
end

sem = @(x) (nanstd(x')./ sqrt(size(x,2))); %inline function for standard error of mean

%set colormap for plotting data
cmap = [1 0 0; 0 0 1; 0 0 0];  %chose the red, blue and black part of the colormap

cmap = flip(cmap)
%% plot sleep/wake charts for each of the experiments


%plot sleep and activity, and average waking activity
%for j = 1:size(sleepStructure,2) %each experiment
%     figure
%     for i =1:2:size(LB,1)-1
%         rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 200], 'Edgecolor', [0.95 0.95 0.95], 'Facecolor', [0.95 0.95 0.95]);
%         hold on
%     end
%     hold on
%     for i = 2:2:size(LB,1)-1
%         rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 200], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
%         hold on
%     end
%     %now add traces
%    for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
%        shadedErrorBar_2(1:size(geno.tenminutetime,2), smooth(nanmean(geno.avewakechart{i}(:,:)'),3),...
%        smooth(sem(geno.avewakechart{i}(:,:)'),3),{'Color', [cmap(i,:)]}, 'transparent');
%        key {i,1} = char(strcat(geno.name{i}, ',n=',...
%            num2str(size(geno.data{i},2)))); %character array defines labels for legend - only need to do this once
%        hold on
%    end 
%    ax = gca; %define axes ticks and labels
%    ax.XTick = LB(:,j);
%    ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
%    set(gca, 'Fontsize', 16);
%    ylim ([0 30])
%    xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
%    ylabel ('Average Activity (sec/10 mins)', 'Fontsize', 18)
% %    title(strcat('Average Activity', sleepStructure(j).name), 'Fontsize', 20)
%    savefig(gcf, fullfile(fileparts (folder),'FinalFigures', strcat(sleepStructure(j).name(1:6),...
%        'averageactivity.fig')));
%    print(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6), ...
%        '_averageactivity')), '-depsc')
%    saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
%        '_averageactivity1')),'tiff')
%    legend (key, 'Fontsize', 14) %adds legend
%    saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
%        '_averageactivity2')),'tiff')

%end

%now the same for sleep
for j = 1:size(sleepStructure,2) %each experiment
    figure
    for i =1:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 10], 'Edgecolor', [0.95 0.95 0.95],  'Facecolor', [0.95 0.95 0.95]);
        hold on
    end
    hold on
    for i = 2:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 10], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
        hold on
    end
    %now add traces
   for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2), ...
           smooth(nanmean(sleepStructure(j).geno.geno.sleepchart{i}(:,:)'),3),...
           smooth(sem(sleepStructure(j).geno.geno.sleepchart{i}(:,:)),3),...
           {'Color', [cmap(i,:)]}, 'transparent');
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 10])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Sleep (mins/10 mins)', 'Fontsize', 18)
%       title(strcat('Sleep', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (folder),'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       'sleep.fig')));
   print(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6), ...
       '_sleep')), '-depsc')
   saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       '_sleep1')),'tiff')
   legend (key, 'Fontsize', 16) %adds legend
   saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       '_sleep2')),'tiff')
   clear key
end

%now the same for wactivity
for j = 1:size(sleepStructure,2) %each experiment
    figure
    for i =1:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 15], 'Edgecolor', [0.95 0.95 0.95], 'Facecolor', [0.95 0.95 0.95]);
        hold on
    end
    hold on
    for i = 2:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 15], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
        hold on
    end
    %now add traces
   for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2), smooth(nanmean(sleepStructure(j).geno.geno.avewakechart{i}(:,:)'),3),...
       smooth(sem(sleepStructure(j).geno.geno.avewakechart{i}(:,:)),3),{'Color', [cmap(i,:)]}, 'transparent');
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 5])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Waking Activity (sec min^{-1}/10mins)', 'Fontsize', 18)
%       title(strcat('Waking Activity', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (folder),'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       'wakingactivity.fig')));
   print(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6), ...
       '_wakingactivity')), '-depsc')
   saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       '_wakingactivity1')),'tiff')
  legend (key, 'Fontsize', 16) %adds legend
    saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       '_wakingactivity2')),'tiff')
end

%% now look at sleep parameters during day and night

sleep_d = cell(size(sleepStructure,2),1);
sleepbout_d = cell(size(sleepStructure,2),1);
sleeplength_d = cell(size(sleepStructure,2),1);
sleep_n = cell(size(sleepStructure,2),1);
sleepbout_n = cell(size(sleepStructure,2),1);
sleeplength_n = cell(size(sleepStructure,2),1);
wactivity_d = cell(size(sleepStructure,2),1);
wactivity_n = cell(size(sleepStructure,2),1);


%for both experiments and look at day and night sleep architecture
for i = 1:size(sleepStructure,2) %each experiment
    sleep_d {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3); %nan table to fit data into
    sleepbout_d {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    sleeplength_d {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    sleep_n {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    sleepbout_n {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    sleeplength_n {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    wactivity_d {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
    wactivity_n {i} = nan(size(sleepStructure(i).geno.geno.data{2},2),3);
        for j=1:size(sleepStructure(i).geno.geno.data,2) %each genotype
            %average sleep
            sleep_d{i}(:,j)  = ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleep.day{j}(1:3,:))'; %day total
            sleepbout_d {i} (:,j)= ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleepBout.day{j}(1:3,:))'; %day average
            sleeplength_d{i}(:,j) = ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleepLength.day{j}(1:3,:))'; %day average
            sleep_n {i} (:,j) = ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleep.night{j}(1:3,:))'; %average night total
            sleepbout_n {i} (:,j) = ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleepBout.night{j}(1:3,:))'; %night average
            sleeplength_n{i} (:,j)= ...
                nanmean(sleepStructure(i).geno.geno.summarytable.sleepLength.night{j}(1:3,:))'; %night average
            wactivity_d {i} (:,j)= ...
                nanmean(sleepStructure(i).geno.geno.summarytable.averageWaking.day{j}(1:3,:))'; %day average
            wactivity_n {i} (:,j)= ...
               nanmean(sleepStructure(i).geno.geno.summarytable.averageWaking.night{j}(1:3,:))'; %night average
        end
end

%make the plots
for i = 1:size(sleepStructure,2) %each experiment
    figure('position', [25, 50, 1000, 500]);
    subplot (1,3,1)
    rectangle('Position', [0 0 4 2000], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', 'none');
    h= plotSpread(sleep_d{i}, 'distributionColor', cmap);   
    errorbar(nanmedian(sleep_d{i}), sem(sleep_d{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 
    ax=gca;   
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 2;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 600]);
    ax.YTick = 0:200:1000;
    ylabel('Total sleep (mins)', 'Fontsize', 16)
    clear h
    
    subplot (1,3,2)
    rectangle('Position', [0 0 4 100], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', 'none');
    h = plotSpread(sleepbout_d{i}, 'distributionColor', cmap);
    errorbar(nanmedian(sleepbout_d{i}), sem(sleepbout_d{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 

    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 2;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 100])
    ylabel('Sleep Bouts', 'Fontsize', 12)
    
    subplot (1,3,3)
     rectangle('Position', [0 0 4 150], 'Facecolor', [0.95 0.95 0.95],...
       'Edgecolor', 'none');
    k= plotSpread(sleeplength_d{i}, 'distributionColor', cmap);
    errorbar(nanmedian(sleeplength_d{i}), sem(sleeplength_d{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 

    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    k{2}(1).LineWidth = 2;
    k{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 15])
    ylabel('Sleep length (mins)', 'Fontsize', 12)
    
    savefig(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep.fig')))
    print(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep')), '-depsc')
    saveas(gcf,fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep')), 'tiff')
    
   figure('position', [25, 50, 1000, 500]);
   subplot (1,3,1)
   rectangle('Position', [0 0 4 2000], 'Facecolor', [0.9 0.9 0.9],...
       'Edgecolor', 'none');
    hold on;
    l = plotSpread(sleep_n{i}, 'distributionColor', cmap);
   errorbar(nanmedian(sleep_n{i}), sem(sleep_n{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14; 
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    l{2}(1).LineWidth = 2;
    l{2}(1).Color = [1 1 1];
    ylim([0 600]);
    ax.YTick = 0:200:1000;
    ylabel('Total sleep (mins)', 'Fontsize', 12)
    
    subplot (1,3,2);
    rectangle('Position', [0 0 4 100], 'Facecolor', [0.9 0.9 0.9],...
           'Edgecolor', 'none');
    hold on
    m=plotSpread(sleepbout_n{i}, 'distributionColor', cmap);
  errorbar(nanmedian(sleepbout_n{i}), sem(sleepbout_n{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 

    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14; 
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    m{2}(1).LineWidth = 2;
    m{2}(1).Color = [1 1 1];
    ylim([0 100])
    ylabel('Sleep bouts', 'Fontsize', 12)
    
    subplot(1,3,3);
    rectangle('Position', [0 0 4 150], 'Facecolor', [0.9 0.9 0.9],...
       'Edgecolor', 'none');
    hold on
    n=plotSpread(sleeplength_n{i}, 'distributionColor', cmap);
   errorbar(nanmedian(sleeplength_n{i}), sem(sleeplength_n{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 

    ax = gca;
     ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14; 
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    n{2}(1).LineWidth = 2;
    n{2}(1).Color = [1 1 1];
    ylim ([0 20])
    ylabel('Sleep length (mins)', 'Fontsize', 12)

    savefig(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'night_sleep.fig')))
    print(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'night_sleep')), '-depsc')
    saveas(gcf,fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'night_sleep')), 'tiff')
    
end

%wactivity plotting
for i = 1:size(sleepStructure,2) %each experiment
   figure('position', [25, 50, 750, 500]);
   subplot(1,2,1)
    rectangle ('Position', [0 0 4 14], 'Facecolor', [0.95 0.95 0.95],...
        'EdgeColor', 'none');
   h=plotSpread(wactivity_d{i}, 'distributionColor', cmap);
  errorbar(nanmedian(wactivity_d{i}), sem(wactivity_d{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 
 
   ax = gca;
     ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14; 
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 2;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 10])
    ax.YTick = 0:2:10;
    ylabel('Average Day waking activity (sec min^{-1})', 'Fontsize', 12)
   
    
    subplot(1,2,2);
    rectangle ('Position', [0 0 4 14], 'Facecolor', [0.9 0.9 0.9], ...
        'EdgeColor', 'none');
    hold on;
    j=plotSpread(wactivity_n{i}, 'distributionColor', cmap);
  errorbar(nanmedian(wactivity_n{i}), sem(wactivity_n{i}'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 
    ax = gca;
     ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14; 
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    j{2}(1).LineWidth = 2;
    j{2}(1).Color = [1 1 1];
    ylim([0 4])
    ax.YTick = 0:0.5:4
    ylabel('Average Night waking activity (sec min^{-1})', 'Fontsize', 16)

    savefig(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
    'wactivity.fig')))
    print(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
    'wactivity')), '-depsc')
    saveas(gcf,fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
    'wactivity')), 'tiff')
end



%do stats on finalScaled_all
P = NaN(8,2);
mult = cell(8,1);
features ={'sleep_d' 'sleep_n' 'sleepbout_d' 'sleepbout_n' 'sleeplength_d'...
    'sleeplength_n' 'wactivity_d' 'wactivity_n' }
for e = 1:size(sleepStructure,2)
    [P(1,e), ~, stats]= kruskalwallis (sleep_d{e}, [], 'off');
    mult {1,e} = multcompare(stats);
    clear stats
    close;
    [P(2,e), ~, stats] =kruskalwallis(sleep_n{e}, [], 'off');
    mult{2,e} = multcompare(stats);
    clear stats
    close;
    [P(3,e), ~, stats] =kruskalwallis(sleepbout_d{e}, [], 'off');
    mult{3,e} = multcompare(stats);
    clear stats
    close;
    [P(4,e), ~, stats] =kruskalwallis(sleepbout_n{e}, [], 'off');
    mult{4,e} = multcompare(stats);
    clear stats
    close;
    [P(5,e), ~, stats] =kruskalwallis(sleeplength_d{e}, [], 'off');
    mult{5,e} = multcompare(stats);
    clear stats
    close;
    [P(6,e), ~, stats] =kruskalwallis(sleeplength_n{e}, [], 'off');
    mult{6,e} = multcompare(stats);
    clear stats
    close;
    [P(7,e), ~, stats] =kruskalwallis(wactivity_d{e}, [], 'off');
    mult{7,e} = multcompare(stats);
    clear stats
    close;
    [P(8,e), ~, stats] =kruskalwallis(wactivity_n{e}, [], 'off');
    mult{8,e} = multcompare(stats);
    clear stats
    close;
end

%save the stats to an excel spreadsheet
for e=1:size(sleepStructure,2)
    saveDir = fullfile(fileparts(folder), strcat(sleepStructure(e).name(1:6), 'sleep_stats_DD.xls'));
    for p = 1:size(features,2)
        xlswrite(saveDir, mult{p,e}, features{p}) 
    end
end

%% and do period analysis

%find the peaks every 18 hours (1080 minutes) and the time between these
%peaks
period = {};
for e =1:size(sleepStructure,2)
    period{e} = NaN(max(nFish(e,:)),size(nFish,2));
    for g=1:size(sleepStructure(e).geno.geno.data,2)
        for f=1:size(sleepStructure(e).geno.geno.data{g},2)
            [pks,locs] = findpeaks(sleepStructure(e).geno.geno.data{g}(:,f), 'MinPeakDistance', 1080);
            period{e}(f,g) = mean(diff(locs)/60);
            clear pks locs
        end
    end  
end

%now vertically concatenate and do stats
periodAll = [];
for e=1:size(period,2)
   periodAll = [periodAll; period{e}]; 
end

%n-way anova to test genotype and experiment interaction
%stats on the concatenated data
clear p

%set grouping variables for experiment and genotype
%groups
ns = length(periodAll(:));
group =[];
for i=1:size(nFish,1)
    gen = 1;
    for f = 1:size(nFish,2)
        group2 (1:max(nFish(i,:))) = gen;
        group = [group group2];
        clear group2
        gen = gen+1;
    end
    clear gen
end
clear i 

for e=1:size(period,2)
    ns_exp (e) =max(nFish(e,:)); %number for each experiment
end
ns_exp2 = cumsum(ns_exp(:)); %cumulative sum

clear  exp
exp (1:ns_exp2(1)) = 1;
for e=2:size(period,2)
   exp(ns_exp2(e-1)+1: ns_exp2(e))=e; 
end
exp = repmat (exp, 1,3);

% do n-way ANOVA to test if difference between experiments
[p, t, stats] = anovan(periodAll(:), {exp, group}, 'model', 'interaction')

%now to make the figure
figure;
plotSpread(periodAll, 'distributionColor', flip(cmap));
errorbar(nanmedian(periodAll), sem(periodAll'), '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 2) 
ax = gca;
ax.XTickLabel = {'WT' 'Het' 'Hom'};
ax.FontSize=12;
set(findall(gca, 'type', 'line'), 'markersize', 16) 
j{2}(1).LineWidth = 3;
j{2}(1).Color = [0.8 0.8 0.8];
ylim([0 40])
ylabel('Period (hours)', 'Fontsize', 16)
text (2, 40, num2str(p))
legend({strcat('WT, n=',num2str(sum(nFish(:,1)))), strcat('Het, n=', num2str(sum(nFish(:,2)))),...
    strcat('Hom, n=', num2str(sum(nFish(:,3))))}, 'FontSize', 14)  
savefig(fullfile(fileparts(folder), 'FinalFigures', 'periodAll.fig'))
print(fullfile(fileparts(folder), 'FinalFigures', 'periodAll'), '-depsc')
saveas(gcf,fullfile(fileparts(folder), 'FinalFigures','periodAll'), 'tiff')

