% Script to analyse the time spent and activity values in each cluster.
% Need to import the cluster percentages and cluster activity values from 
% spreadsheets generated from the ClusterExplanation.m function
clear
addpath(genpath('C:\Users\ilbar\Documents\MATLAB\DreammistPaper'));
topfolder = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper';

% i8Names= {'WT' 'Het' 'i8'};
% virNames = {'WT' 'Het' 'vir'}

%look for ClusterPercentagesDay, ClusterPercentagesNight,
%meanClusterActivityDay, meanClusterActivityNight

%go through finding the xls spreadsheets from ClusterExplanation.m
% ClusterNameD = cell

%make a strucutre of the filenames
DayClusters = dir(fullfile(topfolder,'**\ClusterPercentagesDay.xls'));
NightClusters =dir(fullfile(topfolder, '**\ClusterPercentagesNight.xls'));
DayAct = dir(fullfile(topfolder, '**\meanClusterActivityDay*'));
NightAct = dir(fullfile(topfolder, '**\meanClusterActivityNight*'));
light_conditions = {'LD', 'DD', 'LL'};

%Day
dataPercentD = struct ('LD', struct, 'DD', struct, 'LL', struct);
for i=1:size(DayClusters,1)
    if ~isempty(strfind(DayClusters(i).folder, 'LD'))
        [~, sheets] = xlsfinfo(fullfile(DayClusters(i).folder, DayClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
%             no = str2double(cell2mat(regexp(sheets{s},'\d', 'match')));            
             dataPercentD.LD.(sheets{s}) ...
                = xlsread(fullfile(DayClusters(i).folder, DayClusters(i).name),...
                sheets{s});
        end
    elseif ~isempty(strfind(DayClusters(i).folder, 'DD'))
        [~, sheets] = xlsfinfo(fullfile(DayClusters(i).folder, DayClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
            dataPercentD.DD.(sheets{s}) ...
                = xlsread(fullfile(DayClusters(i).folder, DayClusters(i).name),...
                sheets{s});
        end
    elseif ~isempty(strfind(DayClusters(i).folder, 'LL'))
        [~, sheets] = xlsfinfo(fullfile(DayClusters(i).folder, DayClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
            dataPercentD.LL.(sheets{s}) ...
                = xlsread(fullfile(DayClusters(i).folder, DayClusters(i).name),...
                sheets{s});
        end  
     end
end

%Night
dataPercentN = struct('LD', struct, 'DD', struct, 'LL',struct);
for i=1:size(NightClusters,1)
    if ~isempty(strfind(NightClusters(i).folder, 'LD'))
        [~, sheets] = xlsfinfo(fullfile(NightClusters(i).folder, NightClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
%             no = str2double(cell2mat(regexp(sheets{s},'\d', 'match')));            
             dataPercentN.LD.(sheets{s}) ...
                = xlsread(fullfile(NightClusters(i).folder, NightClusters(i).name),...
                sheets{s});
        end
    elseif ~isempty(strfind(NightClusters(i).folder, 'DD'))
        [~, sheets] = xlsfinfo(fullfile(NightClusters(i).folder, NightClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
            dataPercentN.DD.(sheets{s}) ...
                = xlsread(fullfile(NightClusters(i).folder, NightClusters(i).name),...
                sheets{s});
        end
    elseif ~isempty(strfind(NightClusters(i).folder, 'LL'))
        [~, sheets] = xlsfinfo(fullfile(NightClusters(i).folder, NightClusters(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet1')));
        for s=1:size(sheets,2)
            dataPercentN.LL.(sheets{s}) ...
                = xlsread(fullfile(NightClusters(i).folder, NightClusters(i).name),...
                sheets{s});
        end
    
     end
end

%In the Clusterpercentages every column is an experiment
% WTnames = {'i8WT' 'virWT' 'i8virWT'};
cmap = struct('i8WT', [221/255 181/255 213/255], 'virWT', [249/255, 104/255, 124/255], ...
    'i8virWT', [126/255 214/255 212/255]);

figure;
for l=1:size(light_conditions,2)
    subplot(1,3,l)
    genoNames = fieldnames(dataPercentN.(light_conditions{l}));
    genoNames = genoNames(~cellfun(@isempty,regexp(genoNames,'WT')));
    for w =1:size(genoNames,1)
        errorbar(nanmean(dataPercentN.(light_conditions{l}).(genoNames{w}),2)*100,...
            nanstd(dataPercentN.(light_conditions{l}).(genoNames{w}),0,2)*100,...
            'Color', cmap.(genoNames{w}), 'LineWidth', 2);
        hold on;
        Leg{w} = genoNames{w};
        box off;
    end
    legend(Leg)
    title (strcat('Night time percentages in ', light_conditions{l}));
    ylabel ('Percentage time in state')
    xlabel ('State')
    clear Leg
end

%Night time plots
figure;
for l=1:size(light_conditions,2)
    subplot(1,3,l)
    genoNames = fieldnames(dataPercentD.(light_conditions{l}));
    genoNames = genoNames(~cellfun(@isempty,regexp(genoNames,'WT')));
    for w =1:size(genoNames,1)
        errorbar(nanmean(dataPercentD.(light_conditions{l}).(genoNames{w}),2)*100,...
            nanstd(dataPercentD.(light_conditions{l}).(genoNames{w}),0,2)*100,...
            'Color', cmap.(genoNames{w}), 'LineWidth', 2);
        hold on;
        Leg{w} = genoNames{w};
        box off;
    end
    legend(Leg)
    title (strcat('Day time percentages in ', light_conditions{l}));
    ylabel ('Percentage time in state')
    xlabel ('State')
    clear Leg
end

%% now load the meanActivity values
% Activity values are in a spreadsheet with each tab as a state and columns
% for each genotype. Each row corresponds to a replicate

%Load the Activity values into a structure
DActValues = struct('LD', struct, 'DD', struct, 'LL', struct);

for i=1:size(DayAct,1)
    if  ~isempty(strfind(NightClusters(i).folder, 'LD'))
        [~, sheets] = xlsfinfo(fullfile(DayAct(i).folder, DayAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        DActValues.LD.(type{1}) = NaN(size(t,1), length(sheets));
        clear t
        for s =1:size(sheets,2)
            t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{s});
            DActValues.LD.(type{1})(:,s) = t.(type{1});
        end

    elseif ~isempty(strfind(NightClusters(i).folder, 'DD'))
        [~, sheets] = xlsfinfo(fullfile(DayAct(i).folder, DayAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        DActValues.DD.(type{1}) = NaN(size(t,1), length(sheets));
        for s =1:size(sheets,2)
            t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{s});
            DActValues.DD.(type{1})(:,s) = t.(type{1});
        end
        
    elseif ~isempty(strfind(NightClusters(i).folder, 'LL'))
        [~, sheets] = xlsfinfo(fullfile(DayAct(i).folder, DayAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        DActValues.LL.(type{1}) = NaN(size(t,1), length(sheets));
        for s =1:size(sheets,2)
            t = readtable(fullfile(DayAct(i).folder, DayAct(i).name), 'Sheet', sheets{s});
            DActValues.LL.(type{1})(:,s) = t.(type{1});
        end
    end
end

for l=1:size(light_conditions,2)
    figure;
    genos =fieldnames(DActValues.(light_conditions{l}));
    for i=1:size(genos,1)
       errorbar(nanmean(DActValues.(light_conditions{l}).(genos{i})),...
           nanstd(DActValues.(light_conditions{l}).(genos{i})),...
           'Color',cmap.(genos{i}), 'LineWidth',2)
       hold on;
       Leg{i} = genos{i};
    end
    title(strcat(light_conditions{l}, ' at night'))
    legend(Leg)
    box off
    clear Leg
end

%and for night time
%Load the Activity values into a structure
NActValues = struct('LD', struct, 'DD', struct, 'LL', struct);
for i=1:size(NightAct,1)
    if  ~isempty(strfind(NightClusters(i).folder, 'LD'))
        [~, sheets] = xlsfinfo(fullfile(NightAct(i).folder, NightAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        NActValues.LD.(type{1}) = NaN(size(t,1), length(sheets));
        clear t
        for s =1:size(sheets,2)
            t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{s});
            NActValues.LD.(type{1})(:,s) = t.(type{1});
        end

    elseif ~isempty(strfind(NightClusters(i).folder, 'DD'))
        [~, sheets] = xlsfinfo(fullfile(NightAct(i).folder, NightAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        NActValues.DD.(type{1}) = NaN(size(t,1), length(sheets));
        for s =1:size(sheets,2)
            t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{s});
            NActValues.DD.(type{1})(:,s) = t.(type{1});
        end
        
    elseif ~isempty(strfind(NightClusters(i).folder, 'LL'))
        [~, sheets] = xlsfinfo(fullfile(NightAct(i).folder, NightAct(i).name));
        sheets =sheets(cellfun(@isempty,regexp(sheets,'Sheet*')));
        t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{1});
        names = t.Properties.VariableNames;
        type = names(~cellfun(@isempty, regexp(names, 'WT')));
        NActValues.LL.(type{1}) = NaN(size(t,1), length(sheets));
        for s =1:size(sheets,2)
            t = readtable(fullfile(NightAct(i).folder, NightAct(i).name), 'Sheet', sheets{s});
            NActValues.LL.(type{1})(:,s) = t.(type{1});
        end
    end
end

light_conditions = fieldnames(NActValues);
for l=1:size(light_conditions,1)
    figure;
    genos =fieldnames(NActValues.(light_conditions{l}));
    for i=1:size(genos,1)
       errorbar(nanmean(NActValues.(light_conditions{l}).(genos{i})),...
           nanstd(NActValues.(light_conditions{l}).(genos{i})),...
           'Color',cmap.(genos{i}), 'LineWidth',2)
       hold on;
       Leg{i} = genos{i};
    end
    title(strcat(light_conditions{l}, ' at night'))
    legend(Leg);
    box off;
    clear Leg
end

%%
%now need to do the summary plots

%percentsummary text
DpercentWTs = struct('LD', [], 'DD', [], 'LL', []);
NpercentWTs = struct('LD', [], 'DD', [], 'LL', []);
for l = 1:size(light_conditions,1)
    genos = fieldnames(dataPercentD.(light_conditions{l}));
    genos = genos(~cellfun(@isempty,regexp(genos,'WT')));
    for g =1:size(genos,1)
        DpercentWTs.(light_conditions{l}) =[DpercentWTs.(light_conditions{l}); ...
            dataPercentD.(light_conditions{l}).(genos{g})'];
        NpercentWTs.(light_conditions{l}) = [NpercentWTs.(light_conditions{l}); ...
            dataPercentN.(light_conditions{l}).(genos{g})'];
    end
end

%make a nice figure
for i=1:size(light_conditions,1)
    figure;
    errorbar(nanmean(cell2mat(struct2cell(DActValues.(light_conditions{i})))),...
        nanstd(cell2mat(struct2cell(DActValues.(light_conditions{i})))), ...
        'LineWidth', 2, 'Color', 'b');
    hold on;
    errorbar(nanmean(cell2mat(struct2cell(NActValues.(light_conditions{i})))),...
        nanstd(cell2mat(struct2cell(NActValues.(light_conditions{i})))),...
        'LineWidth', 2, 'Color', 'k');
    title(light_conditions{i});
    for k=1:5
       text(k-0.25, -1, strcat(num2str(nanmean(DpercentWTs.(light_conditions{l})(:,k))*100,3),...
           '+/-',...
           num2str(nanstd(DpercentWTs.(light_conditions{l})(:,k))*100,3)), 'color', 'b');
       text(k-0.25,-1.5, strcat(num2str(nanmean(NpercentWTs.(light_conditions{l})(:,k))*100,3),'+/-',...
          num2str(nanstd(NpercentWTs.(light_conditions{l})(:,k))*100,3)), ...
          'color', 'k');
    end
    box off
    ax=gca;
    ax.YMinorTick = 'on';
    ax.FontSize = 16;
    ax.XTick = ([0:6]);
    ylim ([0 15]);
    xlabel ('Cluster', 'Fontsize', 18);
    ylabel ('Activity (sec min^{-1})' , 'Fontsize', 18);
    legend ({strcat('Day, N=', num2str(size(DpercentWTs.(light_conditions{i}),1))),...
        'Night'}, 'Fontsize', 20);
    print(gcf, fullfile(topfolder, strcat(light_conditions{i},'_AllClusterTimeValues')), '-depsc');
    savefig(gcf, fullfile(topfolder, strcat(light_conditions{i},'_AllClusterTimeValues.fig')));
    saveas(gcf, fullfile(topfolder, strcat(light_conditions{i},'_AllClusterTimeValues')), 'tiff');
end