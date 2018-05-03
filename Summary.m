function Summary (folder, saveDir, names, ControlPos cmap)
    %This function creates the summary figures as errorbar plots from 
    % multiple experiments.
    
    %Inputs:
    %1. folder - the directory containing all the .mat experiment files
    
    %2. saveDir - directory into which all the figures and output files
    %should be saved
    
    %3. names - the names of the groups (eg WT, hom)
    
    %4. ControlPos
    
    %5. cmap - color map to use for making the figures
    
   % Output:
   %1. Summary charts
   
   %2. Summary statistics
   
   % required functions - dir2 by P Henriques
   
   files =dir2(folder);
    
   nConditions = size(names,1);
    
    %load the workspaces
    %now load the .mat files - top file is .DS_store hidden file
    for i = 1:size(files,1)
        sleepStructure(i) = load(fullfile(folder, files(i).name));   
    end
    
    %find the lightboundries in each experiment
    LB= NaN(7,size(sleepStructure,2));
    for i =1:size(sleepStructure,2)
        LB(1:length(find(sleepStructure(i).geno.lightboundries)),i) = find(sleepStructure(i).geno.lightboundries);
    end
    
    %find then number of fish in each experiment and condition
    nFish = NaN(size(wake_day));
    for e =1:size(sleepStructure,2)
        for g = 1:size(wake_day,2)
            nFish (e,g) = size(wake_day{e,g},2);
        end
    end

    
    %make summary table of sleep parameters
    %for both experiments and look at day and night sleep architecture - only
        %for days two and three (ie complete days and nights)
        for i = 1:size(sleepStructure,2) %each experiment
            sleep_d {i} = nan(size(sleepStructure(i).geno.data{2},2),3); %nan table to fit data into
            sleepbout_d {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            sleeplength_d {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            sleep_n {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            sleepbout_n {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            sleeplength_n {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            wactivity_d {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            wactivity_n {i} = nan(size(sleepStructure(i).geno.data{2},2),3);
            for j=1:size(sleepStructure(i).geno.data,2) %each genotype
                sleep_d {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleep.day{j}(2:3,:))'; % fill in average day sleep
                sleepbout_d {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepBout.day{j}(2:3,:))'; %average day sleep bout
                sleeplength_d{i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepLength.day{j}(2:3,:))'; %average day sleep bout length
                sleep_n {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleep.night{j}(2:3,:))'; % average night sleep (total)
                sleepbout_n {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepBout.night{j}(2:3,:))'; %average night sleep bout
                sleeplength_n{i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepLength.night{j}(2:3,:))'; %average night sleep bout length
                wactivity_d {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.averageWaking.day{j}(2:3,:))';%average day wactivity
                wactivity_n {i} (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.averageWaking.night{j}(2:3,:))'; %average night wactivity
            end
        end

%first make cell array of scaled not normalised data
Scaled = cell(5,8);
for e=1:size(sleepStructure,2) %every experiment
    Scaled {e,1} = NaN(max(n_fish(e,:)), size(sleep_d{e},2));
    Scaled {e,2} = NaN(max(n_fish(e,:)), size(sleep_n{e},2));
    Scaled {e,3} = NaN(max(n_fish(e,:)), size(sleepbout_d{e},2));
    Scaled {e,4} = NaN(max(n_fish(e,:)), size(sleepbout_n{e},2));
    Scaled {e,5} = NaN(max(n_fish(e,:)), size(sleeplength_n{e},2));
    Scaled{e,6} = NaN(max(n_fish(e,:)), size(sleeplength_d{e},2));
    Scaled{e,7} = NaN(max(n_fish(e,:)), size(wactivity_d{e},2));
    Scaled {e,8} = NaN(max(n_fish(e,:)), size(wactivity_n{e}, 2));
    for g=1:size(sleepStructure(e).geno.data,2) %every genotype is a column in the matrix(WT=1, het=2, Hom=3)
        Scaled {e,1} (:,g) = (sleep_d{e}(:,g)-nanmean(sleep_d{e}(:,3)))/... %day sleep
          nanmean(sleep_d{e}(:,3));
        Scaled {e,2} (:,g) = (sleep_n{e}(:,g)-nanmean(sleep_n{e}(:,3)))/...%night sleep
          nanmean(sleep_n{e}(:,3));
        Scaled{e,3} (:,g)=(sleepbout_d{e}(:,g)-nanmean(sleepbout_d{e}(:,3)))/...
          nanmean(sleepbout_d{e}(:,3));
        Scaled{e,4}(:,g)=(sleepbout_n{e}(:,g)-nanmean(sleepbout_n{e}(:,3)))/...
          nanmean(sleepbout_n{e}(:,3));
        Scaled {e,5}(:,g) = (sleeplength_d{e}(:,g)-nanmean(sleeplength_d{e}(:,3)))/... 
          nanmean(sleeplength_d{e}(:,3));
        Scaled{e,6}(:,g)=(sleeplength_n{e}(:,g)-nanmean(sleeplength_n{e}(:,3)))/...
          nanmean(sleeplength_n{e}(:,3));
        Scaled{e,7}(:,g)=(wactivity_d{e}(:,g)-nanmean(wactivity_d{e}(:,3)))/...
          nanmean(wactivity_d{e}(:,3));
        Scaled{e,8}(:,g)=(wactivity_n{e}(:,g)-nanmean(wactivity_n{e}(:,3)))/...
          nanmean(wactivity_n{e}(:,3));
    end  
end

end
