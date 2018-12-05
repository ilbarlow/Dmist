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


%% plot sleep/wake charts for each of the experiments
for i = 1:size (sleepStructure,2)
    LB(1:7,i) = find(sleepStructure(i).geno.geno.lightboundries)/10;
end

sem = @(x) ((nanstd(x'))./ sqrt(size(x,2))); %inline function for standard error of mean

%set colormap for plotting data
cmap = [1 0 0; 0 0 1; 0 0 0];  %chose the red, blue and black part of the colormap


%plot sleep and activity, and average waking activity
for j = 1:size(sleepStructure,2) %each experiment
    figure
    for i =1:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 200], 'Edgecolor', [1 1 1]);
        hold on
    end
    hold on
    for i = 2:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 200], ...
            'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
        hold on
    end
    %now add traces
   for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2), ...
           nanmean(sleepStructure(j).geno.geno.tenminute{i}(:,:)'),...
           sem(sleepStructure(j).geno.geno.tenminute{i}), {'Color', cmap(i,:)}, 'transparent');
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 150])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Average Activity (sec/10 mins)', 'Fontsize', 18)
  % title(strcat('Average Activity', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (folder),'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       'averageactivity.fig')));
   print(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6), ...
       '_averageactivity')), '-dsvg')
  saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
   '_averageactivity1')),'tiff')
   legend (key, 'Fontsize', 14) %adds legend   
   saveas(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       '_averageactivity2')),'tiff')
end

%now the same for sleep
for j = 1:size(sleepStructure,2) %each experiment
    figure
    for i =1:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 10], 'Edgecolor', [1 1 1]);
        hold on
    end
    hold on
    for i = 2:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 10], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
        hold on
    end
    %now add traces
   for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2), smooth(nanmean(sleepStructure(j).geno.geno.sleepchart{i}(:,:)'),3),...
           smooth(sem(sleepStructure(j).geno.geno.sleepchart{i}),3), {'Color', cmap(i,:)},1); %plot hour rolling average
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
%      title(strcat('Sleep', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (folder),'FinalFigures', strcat(sleepStructure(j).name(1:6),...
       'sleep.fig')));
   print(gcf, fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(j).name(1:6), ...
       '_sleep')), '-dsvg')
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
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 15], 'Edgecolor', [1 1 1]);
        hold on
    end
    hold on
    for i = 2:2:size(LB,1)-1
        rectangle ('Position', [LB(i,j) 0 (LB(i+1,j) - LB(i,j)) 15], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
        hold on
    end
    %now add traces
   for i= 1:size(sleepStructure(j).geno.geno.data,2) %each genotype
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2),...
           smooth(nanmean(sleepStructure(j).geno.geno.avewakechart{i}(:,:)'),3),...
           smooth(sem(sleepStructure(j).geno.geno.sleepchart{i}),3), {'Color', [cmap(i,:)]}, 'transparent'); %plot hour rolling average
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 15])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Waking Activity (sec min^{-1}/10mins)', 'Fontsize', 18)
   %   title(strcat('Waking Activity', sleepStructure(j).name), 'Fontsize', 20)
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
            sleep_d {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleep.daytotal{j}; %day total
            sleepbout_d {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleepBout.daymean{j}; %day average
            sleeplength_d{i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleepLength.daymean{j}; %day average
            sleep_n {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleep.nighttotal{j}; %night total
            sleepbout_n {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleepBout.nightmean{j}; %night average
            sleeplength_n{i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.sleepLength.nightmean{j}; %night average
            wactivity_d {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.averageWaking.daymean{j}; %day average
            wactivity_n {i} (1:size(sleepStructure(i).geno.geno.data{j},2),j) = ...
                sleepStructure(i).geno.geno.summarytable.averageWaking.nightmean{j}; %night average
        end
end

%make the plots
for i = 1:size(sleepStructure,2) %each experiment
    figure('position', [25, 50, 1000, 500]);
    
    subplot (1,3,1)
    h= plotSpread(fliplr(sleep_d{i}), 'distributionColors', flip(cmap), 'showMM', 2);   
    ax=gca;   
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;   
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 3;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 1000]);
    ylabel('Total sleep (mins)', 'Fontsize', 16)
    clear h
    
    subplot (1,3,2)
    h = plotSpread(fliplr(sleepbout_d{i}), 'distributionColor', flip(cmap), 'showMM', 2);
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 3;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 60])
    ylabel('Sleep Bouts', 'Fontsize', 16)
    
    subplot (1,3,3)
    k= plotSpread(fliplr(sleeplength_d{i}), 'distributionColor', flip(cmap), 'showMM',2);
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    k{2}(1).LineWidth = 3;
    k{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 10])
    ylabel('Sleep length (mins)', 'Fontsize', 16)
    
    savefig(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep.fig')))
    print(fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep')), '-depsc')
    saveas(gcf,fullfile(fileparts(folder), 'FinalFigures', strcat(sleepStructure(i).name(1:6),...
        'day_sleep')), 'tiff')
    
   figure('position', [25, 50, 1000, 500]);
   subplot (1,3,1)
   rectangle('Position', [0 0 4 1000], 'Facecolor', [0.9 0.9 0.9],...
       'Edgecolor', [1 1 1]);
    hold on;
    l = plotSpread(fliplr(sleep_n{i}), 'distributionColor', flip(cmap), 'showMM',2);
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45;    
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    l{2}(1).LineWidth = 3;
    l{2}(1).Color = [1 1 1];
    ylim([0 1000]);
    ylabel('Total sleep (mins)', 'Fontsize', 16)
    
    subplot (1,3,2);
    rectangle('Position', [0 0 4 60], 'Facecolor', [0.9 0.9 0.9],...
           'Edgecolor', [1 1 1]);
    hold on
    m=plotSpread(fliplr(sleepbout_n{i}), 'distributionColor', flip(cmap), 'showMM',2);
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    m{2}(1).LineWidth = 3;
    m{2}(1).Color = [1 1 1];
    ylim([0 60])
    ylabel('Sleep bouts', 'Fontsize', 16)
    
    subplot(1,3,3);
    rectangle('Position', [0 0 4 25], 'Facecolor', [0.9 0.9 0.9],...
       'Edgecolor', [1 1 1]);
    hold on
    n=plotSpread(fliplr(sleeplength_n{i}), 'distributionColor', flip(cmap),'showMM',2);
    ylim([0 25])
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    m{2}(1).LineWidth = 3;;
    n{2}(1).Color = [1 1 1];
    ylim ([0 20])
    ylabel('Sleep length (mins)', 'Fontsize', 16)

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
    h=plotSpread(fliplr(wactivity_d{i}), 'distributionColor', flip(cmap), 'showMM',2);
    ax = gca;
    ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12) 
    h{2}(1).LineWidth = 3;
    h{2}(1).Color = [0.5 0.5 0.5];
    ylim([0 14])
    ylabel('Average Day waking activity (sec min^{-1})', 'Fontsize', 16)
   
    
    subplot(1,2,2);
    rectangle ('Position', [0 0 4 14], 'Facecolor', [0.9 0.9 0.9], 'EdgeColor', [1 1 1]);
    hold on;
    j=plotSpread(fliplr(wactivity_n{i}), 'distributionColor', flip(cmap), 'showMM',2);
    ax = gca;
     ax.XTickLabel ={'WT', 'HET', 'HOM'};
    ax.XTickLabelRotation = 45; 
    ax.FontSize = 14;
    set(findall(gca, 'type', 'line'), 'markersize', 12);
    j{2}(1).LineWidth = 3
    j{2}(1).Color = [1 1 1];
    ylim([0 4])
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
    saveDir = fullfile(fileparts(folder), strcat(sleepStructure(e).name(1:6), 'sleep_stats_JasonExps.xls'));
    for p = 1:size(features,2)
        xlswrite(saveDir, mult{p,e}, features{p}) 
    end
end