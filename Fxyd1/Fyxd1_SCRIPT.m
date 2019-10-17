%Final Script that uses all the functions to make all the Summary figures
%and state transition figures

clear
warning('off','all')
addpath (genpath('C:\Users\ilbar\Documents\MATLAB\DreammistPaper'))
%% normal LD
foldir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Fxyd1\Data';

saveDirfxyd1 = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Fxyd1\Figures';

namesfxyd1 = {'fxyd1^{+/+}', 'fxyd1^{+/-}', 'fxyd1^{-/-}'};

ControlPosfxyd1 =1;

cmap = [0,0,0; colormap(lines(2))]; % Black = WT

ymaxD = [0.6 0.6 0.6 0.6 0.6];

ymaxN = [0.8 0.6 0.6 0.6 0.6];

%Summary figures
Summary (foldir, saveDirfxyd1, namesfxyd1, ControlPosfxyd1, cmap)

%Activity summary
Summary_Act(foldir, saveDirfxyd1, namesfxyd1, ControlPosfxyd1, cmap)

%LMM export for Jason
LMM_export (foldir, saveDirfxyd1, namesfxyd1);

%State transitions
StateTransitions (foldir, saveDirfxyd1, namesfxyd1, ControlPosfxyd1, cmap, ymaxD, ymaxN);

%% make some sleep wake plots
files =dir(foldir);

%load the workspaces
%now load the .mat files - top file is .DS_store hidden file
%sleepStructure = struct([]);
for i = 1:size(files,1)
    if startsWith(files(i).name, '.') ==1
        continue
    else
        sleepStructure(i).geno = load(fullfile(foldir, files(i).name));
        sleepStructure(i).name = files(i).name
    end
end

%remove empty fields
sleepStructure = sleepStructure(~cellfun(@isempty,{sleepStructure.geno}));

for i = 1:size (sleepStructure,2)
    LB(1:7,i) = find(sleepStructure(i).geno.geno.lightboundries)/10;
end

sem = @(x) ((nanstd(x'))./ sqrt(size(x,2))); %inline function for standard error of mean

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
   ylim ([0 200])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Average Activity (sec/10 mins)', 'Fontsize', 18)
%    title(strcat('Average Activity', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (foldir),'expFigures', strcat(sleepStructure(j).name(1:6),...
       'averageactivity.fig')));
    print(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6), ...
       '_averageactivity')), '-dsvg')
  saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
   '_averageactivity1')),'tiff')
   legend (key, 'Fontsize', 14) %adds legend   
   saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
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
       shadedErrorBar_2(1:size(sleepStructure(j).geno.geno.tenminutetime,2), ...
           smoothdata(nanmean(sleepStructure(j).geno.geno.sleepchart{i}(:,:)'),'movmean',3),...
           smoothdata(sem(sleepStructure(j).geno.geno.sleepchart{i}),'movmean',3), {'Color', cmap(i,:)},1); %plot hour rolling average
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 8])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Sleep (mins/10 mins)', 'Fontsize', 18)
%      title(strcat('Sleep', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (foldir),'expFigures', strcat(sleepStructure(j).name(1:6),...
       'sleep.fig')));
   print(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6), ...
       '_sleep')), '-dsvg')
   saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
       '_sleep1')),'tiff')
   legend (key, 'Fontsize', 16) %adds legend
   saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
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
           smoothdata(nanmean(sleepStructure(j).geno.geno.avewakechart{i}(:,:)'),'movmean',3),...
           smoothdata(sem(sleepStructure(j).geno.geno.avewakechart{i}),'movmean',3), {'Color', [cmap(i,:)]}, 'transparent'); %plot hour rolling average
       key {i,1} = char(strcat(sleepStructure(j).geno.geno.name{i}, ',n=',...
           num2str(size(sleepStructure(j).geno.geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end 
   ax = gca; %define axes ticks and labels
   ax.XTick = LB(:,j);
   ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
   set(gca, 'Fontsize', 16);
   ylim ([0 20])
   xlim([LB(3,j) LB(7,j)])
   xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
   ylabel ('Waking Activity (sec min^{-1}/10mins)', 'Fontsize', 18)
   %   title(strcat('Waking Activity', sleepStructure(j).name), 'Fontsize', 20)
   savefig(gcf, fullfile(fileparts (foldir),'expFigures', strcat(sleepStructure(j).name(1:6),...
       'wakingactivity.fig')));
   print(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6), ...
       '_wakingactivity')), '-depsc')
   saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
       '_wakingactivity1')),'tiff')   
   legend (key, 'Fontsize', 16) %adds legend
   saveas(gcf, fullfile(fileparts(foldir), 'expFigures', strcat(sleepStructure(j).name(1:6),...
       '_wakingactivity2')),'tiff')
end