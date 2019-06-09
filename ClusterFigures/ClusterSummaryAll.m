%script to combine all the clustering activity values and percentages to
%make one plot
tic
addpath(genpath('C:\Users\ilbar\Documents\MATLAB\DreammistPaper'));
topfolder = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper'

[pathNames, dirNames, fileNames] = dirwalk(topfolder);

%look for ClusterPercentagesDay, ClusterPercentagesNight,
%meanClusterActivityDay, meanClusterActivityNight

%go through finding the xls spreadsheets from ClusterExplanation.m
% ClusterNameD = cell
for i=1:size(fileNames,1)
    for j=1:size(fileNames{i},1)
        
        %daytime
         if endsWith(fileNames{i}(j), 'ClusterPercentagesDay.xls')
            loadFile = fullfile(pathNames{i}, fileNames{i}(j));
            [~, sheets] = xlsfinfo(fullfile(loadFile{1}));
            for k=1:size(sheets,2)
                ClusterNameD{i,j,k} = sheets{k};
                if ~isempty(strfind(pathNames{i}, 'LD'))
                    LDdataPercentD{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                elseif ~isempty(strfind(pathNames{i}, 'DD'))
                    DDdataPercentD{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                    
                elseif ~isempty(strfind(pathNames{i}, 'LL'))
                    LLdataPercentD{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                end
            end

        end
        
        %night
        if endsWith(fileNames{i}(j), 'ClusterPercentagesNight.xls')==1
            ClusterNameN{i,j} = fullfile(pathNames{i}, fileNames{i}(j));
            [~, sheets] = xlsfinfo(fullfile(pathNames{i}, fileNames{i}{j}));
            for k=1:size(sheets,2)
                ClusterNameN{i,j} = sheets{k};
                if ~isempty(strfind(pathNames{i}, 'LD'))
                    LDdataPercentN{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                elseif ~isempty(strfind(pathNames{i}, 'DD'))
                    DDdataPercentN{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                    
                elseif ~isempty(strfind(pathNames{i}, 'LL'))
                    LLdataPercentN{i,j,k} = xlsread(fullfile(pathNames{i},...
                        fileNames{i}{j}), sheets{k});
                end
            end

        end
                    
        %activity
        if endsWith(fileNames{i}(j), 'meanClusterActivityDay.xls') == 1
            [~, sheets] = xlsfinfo(fullfile(pathNames{i}, fileNames{i}{j}));
            for k=1:size(sheets,2)
               if sheets{k} == 'Sheet*'
                   continue
               else
                   fnActD {i,k} = {fullfile(pathNames{i}, fileNames{i}{j}), sheets{k}};
                   actMeanD {i,k} = xlsread(fnActD{i,k}{1}, sheets{k});
               end
            end
        end
        %nightTime
        if endsWith(fileNames{i}(j), 'meanClusterActivityNight.xls') == 1
        [~, sheets] = xlsfinfo(fullfile(pathNames{i}, fileNames{i}{j}));
        for k=1:size(sheets,2)
           if sheets{k} == 'Sheet*'
               continue
           else
               fnActN {i,k} = {fullfile(pathNames{i}, fileNames{i}{j}), sheets{k}};
               actMeanN {i,k} = xlsread(fnActN{i,k}{1}, sheets{k});
           end
        end
        end
        
    end  
end
toc         


%clear empty cells
LDdataPercentD = LDdataPercentD(~cellfun('isempty', LDdataPercentD));
DDdataPercentD = DDdataPercentD(~cellfun('isempty', DDdataPercentD));
LLdataPercentD = LLdataPercentD(~cellfun('isempty', LLdataPercentD));

LDdataPercentN= LDdataPercentN(~cellfun('isempty', LDdataPercentN));
DDdataPercentN = DDdataPercentN(~cellfun('isempty', DDdataPercentN));
LLdataPercentN = LLdataPercentN(~cellfun('isempty', LLdataPercentN));


ClusterNameD = ClusterNameD(~cellfun('isempty', ClusterNameD));
fnActD = fnActD(~cellfun('isempty', fnActD));
actMeanD = actMeanD(~cellfun('isempty', actMeanD));

ClusterNameN = ClusterNameN(~cellfun('isempty', ClusterNameN));
fnActN = fnActN(~cellfun('isempty', fnActN));
actMeanN = actMeanN(~cellfun('isempty', actMeanN));

sheets = sheets(~cellfun('strfind', 'Sheet*'))
toc

%% plot the errorbar figures
%LD first
%now make a nice plot to show the activity for all the clusters
LDtxtD(1,:) = nanmean(cell2mat(LDdataPercentD'),2)*100';
LDtxtN (1,:)= nanmean(cell2mat(LDdataPercentN'),2)*100';
LLtxtD(1,:) = nanmean(cell2mat(LLdataPercentD'),2)*100';
LLtxtN(1,:) = nanmean(cell2mat(LLdataPercentN'),2)*100';
DDtxtD(1,:) = nanmean(cell2mat(DDdataPercentD'),2)*100';
DDtxtN(1,:) = nanmean(cell2mat(DDdataPercentN'),2)*100';

LDtxtD (2,:)=nanstd(cell2mat(LDdataPercentD'),[],2)*100';
LDtxtN(2,:) = nanstd(cell2mat(LDdataPercentN'),[],2)*100';
LLtxtD (2,:)=nanstd(cell2mat(LLdataPercentD'),[],2)*100';
LLtxtN(2,:) = nanstd(cell2mat(LLdataPercentN'),[],2)*100';
DDtxtD (2,:)=nanstd(cell2mat(DDdataPercentD'),[],2)*100';
DDtxtN(2,:) = nanstd(cell2mat(DDdataPercentN'),[],2)*100';

%find the correct activity values for corresponding states
LDstatesActD = cell(size(sheets,2),1);
LDstatesActN = cell(size(sheets,2),1);
DDstatesActD = cell(size(sheets,2),1);
DDstatesActN = cell(size(sheets,2),1);
LLstatesActD = cell(size(sheets,2),1);
LLstatesActN = cell(size(sheets,2),1);

for j=1:size(sheets,2)
    LDstatesActD{j} = [];
    LDstatesActN{j} = [];
    for i =1:size(fnActD,1)
        if fnActD{i}{2} ==sheets{j}
            if ~isempty(strfind(fnActD{i}{1}, 'LD')) 
                LDstatesActD{j} = [LDstatesActD{j}; actMeanD{i}(:)];
            elseif ~isempty(strfind(fnActD{i}{1}, 'DD'))
                DDstatesActD{j} = [DDstatesActD{j}; actMeanD{i}(:)];
                
            elseif ~isempty(strfind(fnActD{i}{1}, 'LL'))
                LLstatesActD{j} = [LLstatesActD{j}; actMeanD{i}(:)];
            end
        end
    
       if fnActN{i}{2} ==sheets{j}
            if ~isempty(strfind(fnActN{i}{1}, 'LD')) 
                LDstatesActN{j} = [LDstatesActN{j}; actMeanN{i}(:)];
            elseif ~isempty(strfind(fnActN{i}{1}, 'DD'))
                DDstatesActN{j} = [DDstatesActN{j}; actMeanN{i}(:)];
                
            elseif ~isempty(strfind(fnActN{i}{1}, 'LL'))
                LLstatesActN{j} = [LLstatesActN{j}; actMeanN{i}(:)];
            end
        end      
    end
end

%remove empty cells
LDstatesActD = LDstatesActD(~cellfun('isempty', LDstatesActD));
LDstatesActN = LDstatesActN(~cellfun('isempty', LDstatesActN));

%% make the plots - LD first 
plotD (1,:) = nanmean(cell2mat(LDstatesActD'));
plotD(2,:) = nanstd(cell2mat(LDstatesActD'));

plotN(1,:) = nanmean(cell2mat(LDstatesActN'));
plotN(2,:) = nanstd(cell2mat(LDstatesActN'));

figure;
errorbar (plotD(1,:), plotD(2,:), 'Linewidth', 2, 'color', 'b');
hold on
errorbar (plotN(1,:), plotN(2,:), 'Linewidth', 2, 'color', 'k');
for k=1:5
   text(k-0.25, plotD(1,k)+1, strcat(num2str(LDtxtD(1,k)), '+/-',...
       num2str(LDtxtD(2,k))), 'color', 'b');
   text(k-0.25, plotN(2,k)+0.5, strcat(num2str(LDtxtN(1,k)), '+/-',...
       num2str(LDtxtN(2,k))), 'color', 'k');
end
box off;
ax=gca;
ax.YMinorTick = 'on';
ax.FontSize = 16;
ax.XTick = [0:6];
ylim ([0 15]);
xlabel ('Cluster', 'Fontsize', 18);
ylabel ('Activity (sec min^{-1})' , 'Fontsize', 18);
legend ({'Day' 'Night'}, 'Fontsize', 20);
print(gcf, fullfile(topfolder, 'LDAllClusterTimeValues'), '-depsc');
savefig(gcf, fullfile(topfolder, 'LDAllClusterTimeValues.fig'));
saveas(gcf, fullfile(topfolder, 'LDAllClusterTimeValues'), 'tiff');

%% DD
plotD (1,:) = nanmean(cell2mat(DDstatesActD'));
plotD(2,:) = nanstd(cell2mat(DDstatesActD'));

plotN(1,:) = nanmean(cell2mat(DDstatesActN'));
plotN(2,:) = nanstd(cell2mat(DDstatesActN'));

figure;
errorbar (plotD(1,:), plotD(2,:), 'Linewidth', 2, 'color', 'b');
hold on
errorbar (plotN(1,:), plotN(2,:), 'Linewidth', 2, 'color', 'k');
for k=1:5
   text(k-0.25, plotD(1,k)+1, strcat(num2str(DDtxtD(1,k)), '+/-',...
       num2str(DDtxtD(2,k))), 'color', 'b');
   text(k-0.25, plotN(2,k)+0.5, strcat(num2str(DDtxtN(1,k)), '+/-',...
       num2str(DDtxtN(2,k))), 'color', 'k');
end
box off;
ax=gca;
ax.YMinorTick = 'on';
ax.FontSize = 16;
ax.XTick = [0:6];
ylim ([0 15]);
xlabel ('Cluster', 'Fontsize', 18);
ylabel ('Activity (sec min^{-1})' , 'Fontsize', 18);
legend ({'Day' 'Night'}, 'Fontsize', 20);
print(gcf, fullfile(topfolder, 'DDAllClusterTimeValues'), '-depsc');
savefig(gcf, fullfile(topfolder, 'DDAllClusterTimeValues.fig'));
saveas(gcf, fullfile(topfolder, 'DDAllClusterTimeValues'), 'tiff');

%% LL
plotD (1,:) = nanmean(cell2mat(LLstatesActD'));
plotD(2,:) = nanstd(cell2mat(LLstatesActD'));

plotN(1,:) = nanmean(cell2mat(LLstatesActN'));
plotN(2,:) = nanstd(cell2mat(LLstatesActN'));

figure;
errorbar (plotD(1,:), plotD(2,:), 'Linewidth', 2, 'color', 'b');
hold on
errorbar (plotN(1,:), plotN(2,:), 'Linewidth', 2, 'color', 'k');
for k=1:5
   text(k-0.25, plotD(1,k)+1, strcat(num2str(LLtxtD(1,k)), '+/-',...
       num2str(LLtxtD(2,k))), 'color', 'b');
   text(k-0.25, plotN(2,k)+0.5, strcat(num2str(LLtxtN(1,k)), '+/-',...
       num2str(LLtxtN(2,k))), 'color', 'k');
end
box off;
ax=gca;
ax.YMinorTick = 'on';
ax.FontSize = 16;
ax.XTick = [0:6];
ylim ([0 15]);
xlabel ('Cluster', 'Fontsize', 18);
ylabel ('Activity (sec min^{-1})' , 'Fontsize', 18);
legend ({'Day' 'Night'}, 'Fontsize', 20);
print(gcf, fullfile(topfolder, 'LLAllClusterTimeValues'), '-depsc');
savefig(gcf, fullfile(topfolder, 'LLAllClusterTimeValues.fig'));
saveas(gcf, fullfile(topfolder, 'LLAllClusterTimeValues'), 'tiff');