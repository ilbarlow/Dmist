% Colocalisation plot analysis script July 2018
% The expression profiles were generated using the custom macro
% profiler.ijm from the composite RGB stack across one cell to generete an
% excel spreadsheet with each column corresponding to the intensity for
% each channel in the order 401nm, 488nm, 568nm. The original data was
% exported as .xls which proved incompatible and so was changed to .xlsx

%The aim of this script is to import each of these spreadsheets and plot
%the profiles

fdir = uigetdir;

%get the subfolders for each condition and then for each stack loop through
%to find the ChannelProfiles.xls file
folders = dir2(fdir);
[pathNames, dirNames, fileNames] = dirwalk(fdir);

%go through finding the xls spreadsheets from 
for i=1:size(pathNames,1)
    files = dir(pathNames{i});
    for j = 1:size(files,1);
        if endsWith(files(j).name, '.xlsx') ==1
            name {i,j} = fullfile(pathNames{i}, files(j).name);
            data {i,j} = xlsread(fullfile(pathNames{i}, files(j).name));
        end
    end
end

%remove the empty cells
name = name(~cellfun('isempty', name));
data = data(~cellfun('isempty', data));

%now create a directory and save all the profile plots
    %need to normalise the florescence signal byn('isempty',R))  
%get rid of nans in first column
data{11}(isnan(data{11}(:,1)))=1;

%create save directory
savedir = fullfile(fdir, 'Figures');
mkdir(savedir)
cmap = [0 1 0; 0 0 1; 1 0 1]; 
for j=1:size(data,1)
    figure;
    for i=3:size(data{j},2)
       plot (data{j}(:,i)/nanmean(data{j}(:,i)), 'linewidth', 2, 'color', cmap(i-2,:));
       hold on
    end
    box off
    ax= gca;
    ax.XTick = round(data{j}(2:10:end,1));
    ax.XTickLabel = round(data{j}(2:10:end,2));
    ax.FontSize = 14;
    ax.FontName = 'Arial';
    xlabel ('microns', 'FontSize', 14, 'FontName', 'Arial');
    ylabel ('Normalised Intensity', 'FontSize', 14, 'FontName', 'Arial');
    nameT = split(name{j}, '\');
    nameT = join(nameT(4:6), '_');
    title (nameT);
    print(fullfile(savedir, nameT{1}), '-depsc', '-tiff');
    saveas(gcf, fullfile(savedir, nameT{1}), 'tiff');
    savefig(fullfile(savedir, strcat(nameT{1}, '.fig')));
    clear nameT
    close
end


subfolders = {}
for i =1:size(folders,1)
   if isdir(folders(i))==1
        subfolders{i} = {}
        temp = dir2(fullfile(folders, folders(i).name))
        
        
   end
end

