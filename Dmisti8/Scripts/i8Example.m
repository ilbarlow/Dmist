%Figure 3 - example sleep wake traces for dmist i8 - use experiment 160701_24

fname = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LD\RawData\160701_24.mat'
[filepath,name,ext] = fileparts(fname)
load(fname)

%first just plot waking activity trace
%find lightboundries for shading
LB = find(geno.lightboundries)/10;
nFish = NaN(1,size(geno.data,2));
for i=1:size(geno.data,2)
   nFish(i) = size(geno.data{i},2); 
end

%set colormap
cmap = [1 0 1; 0 1 0 ; 0 0 0]; %black = wt, green = het, hom = mag
sem = @(x) (nanstd(x')./ sqrt(size(x,2))); %inline function for standard error of mean

%now plot shaded boxes for traces
figure;
for i =1:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 15], 'Edgecolor', [1 1 1]);
    hold on
end
hold on
for i = 2:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 15], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
    hold on
end

%now add traces
for i= 1:size(geno.data,2)
   shadedErrorBar_2(1:size(geno.tenminutetime,2), smooth(nanmean(geno.avewakechart{i}(:,:)'),3),...
       smooth(sem(geno.avewakechart{i}(:,:)),3),{'Color', [cmap(i,:)]}, 'transparent');
   key {i,1} = char(strcat(geno.name{i}, ',n=',...
       num2str(size(geno.data{i},2)))); %character array defines labels for legend - only need to do this once
   hold on
end    
ax = gca; %define axes ticks and labels
ylim ([0 15]);
xlim ([LB(3) LB(end)])
ax.XTick = LB(:);
ax.XTickLabel = {'' '23' '0' '14' '0' '14' '0'};
set(gca, 'Fontsize', 16);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
ylabel ('Waking Activity (sec/min/10min)', 'Fontsize', 18)
%title('Waking Activity', 'Fontsize', 20)
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minWactivity.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minWactivity')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivity1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivity2')),'tiff')
legend ('off')

gcf;
xlim ([LB(4), LB(5)]);
ylim ([0 2]);
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minWactivityZoomNight1.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minWactivityZoomNight1')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivityZoomNight1_1')),'tiff')
legend (key, 'Fontsize', 18)
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivityZoomNight1_2')),'tiff')

%sleep traces
figure;
for i =1:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 10], 'Edgecolor', [1 1 1]);
    hold on
end
hold on
for i = 2:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 10], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
    hold on
end

%now add traces
   for i= 1:size(geno.data,2)
       shadedErrorBar_2(1:size(geno.tenminutetime,2), smooth(nanmean(geno.sleepchart{i}(:,:)'),3), smooth(sem(geno.sleepchart{i}(:,:)),3),...
           {'Color', [cmap(i,:)]}, 'transparent');
       key {i,1} = char(strcat(geno.name{i}, ',n=',...
           num2str(size(geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end    
ax = gca; %define axes ticks and labels
ylim ([0 10]);
xlim ([LB(3) LB(end)])
ax.XTick = LB(:);
ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
set(gca, 'Fontsize', 16);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
ylabel ('Sleep (min/10 mins)', 'Fontsize', 18)
% title('Sleepchart', 'Fontsize', 20)
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minSleep.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minSleep')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleep1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleep2')),'tiff')

legend('off')
gcf;
xlim ([LB(4), LB(5)]);
ylim ([0 6]);
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minSleepZoomNight1.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minSleepZoomNight1')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleepZoomNight1_1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleepZoomNight1_2')),'tiff')

%% sleep stats and plot spreads

%set saveName
[~,expName, ~] = fileparts(fname);

%for both experiments and look at day and night sleep architecture
sleep_d  = nan(size(geno.data{2},2),3); %nan table to fit data into
sleepbout_d  = nan(size(geno.data{2},2),3);
sleeplength_d  = nan(size(geno.data{2},2),3);
sleep_n  = nan(size(geno.data{2},2),3);
sleepbout_n  = nan(size(geno.data{2},2),3);
sleeplength_n = nan(size(geno.data{2},2),3);
wactivity_d  = nan(size(geno.data{2},2),3);
wactivity_n = nan(size(geno.data{2},2),3);
for j=1:size(geno.data,2) %each genotype
    sleep_d (1:size(geno.data{j},2),j) = ...
        geno.summarytable.sleep.daytotal{j}; %day total
    sleepbout_d  (1:size(geno.data{j},2),j) = ...
        geno.summarytable.sleepBout.daymean{j}; %day average
    sleeplength_d (1:size(geno.data{j},2),j) = ...
        geno.summarytable.sleepLength.daymean{j}; %day average
    sleep_n  (1:size(geno.data{j},2),j) = ...
       geno.summarytable.sleep.nighttotal{j}; %night total
    sleepbout_n  (1:size(geno.data{j},2),j) = ...
        geno.summarytable.sleepBout.nightmean{j}; %night average
    sleeplength_n(1:size(geno.data{j},2),j) = ...
        geno.summarytable.sleepLength.nightmean{j}; %night average
    wactivity_d (1:size(geno.data{j},2),j) = ...
       geno.summarytable.averageWaking.daymean{j}; %day average
    wactivity_n (1:size(geno.data{j},2),j) = ...
        geno.summarytable.averageWaking.nightmean{j}; %night average
end

%make the plots
figure('position', [25, 50, 1000, 500]);
subplot (1,3,1)
h= plotSpread(fliplr(sleep_d), 'distributionColors',flip(cmap), 'showMM', 2);   
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
h = plotSpread(fliplr(sleepbout_d), 'distributionColor', flip(cmap), 'showMM', 2);
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
k= plotSpread(fliplr(sleeplength_d), 'distributionColor', flip(cmap), 'showMM',2);
ax = gca;
ax.XTickLabel ={'WT', 'HET', 'HOM'};
ax.XTickLabelRotation = 45; 
ax.FontSize = 14;
set(findall(gca, 'type', 'line'), 'markersize', 12) 
k{2}(1).LineWidth = 3;
k{2}(1).Color = [0.5 0.5 0.5];
ylim([0 10])
ylabel('Sleep length (mins)', 'Fontsize', 16)

savefig(fullfile(fileparts(filepath), 'FinalFigures', strcat(expName,...
    'day_sleep.fig')))
print(fullfile(fileparts(filepath), 'FinalFigures', strcat(expName,...
    'day_sleep')), '-depsc')
saveas(gcf,fullfile(fileparts(filepath), 'FinalFigures', strcat(expName,...
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
    [P(1,e), ~, stats]= kruskalwallis (sleep_d, [], 'off');
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




%% repeated measures ANOVA

%make cell array of the genotypes
genolist= {};
for i=1:3
    genotype = cell(nFish(i),1);
    for j=1:nFish(i)
       genotype(1:j) = geno.name{i}; 
    end
    genolist = vertcat(genolist, genotype)
    clear genotype
end

%vcat the avewakechart measures
measures = [];
for i=1:size(geno.avewakechart,2)
    measures = [measures; geno.avewakechart{i}(LB(4):LB(5),:)' geno.avewakechart{i}(LB(6):LB(7),:)'];
end
measureNames = cell(size(measures,2),1);
for i=1:size(measures,2)
   measureNames{i} = strcat('t_', num2str(i)); 
end

genocell = {'genotype'};

varNames = vertcat(genocell, measureNames);

%make a table
t = array2table(measures);
t.genotype = genolist;

Meas = table([1:size(measureNames,1)]', 'VariableNames', {'Measurements'})

rm = fitrm(t, 'measures1-measures122~genotype', 'WithinDesign', Meas);

ranovatbl = ranova(rm)