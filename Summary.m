function Summary (folder, saveDir, names, ControlPos, cmap)
    %This function creates the summary figures as errorbar plots from 
    % multiple experiments.
    
    %Inputs:
    %1. folder - the directory containing all the .mat experiment files
    
    %2. saveDir - directory into which all the figures and output files
    %should be saved
    
    %3. names - the names of the groups (eg WT, hom)
    
    %4. ControlPos - location of WT controls
    
    %5. cmap - color map to use for making the figures
    
   % Output:
   %1. Summary charts
   
   %2. Summary statistics
   
   % required functions - dir2 by P Henriques
   
   files =dir2(folder);
    
   nConditions = size(names,2);
    
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
    nFish = NaN(size(sleepStructure,2), nConditions);
    for e =1:size(sleepStructure,2)
        for g = 1:nConditions
            nFish (e,g) = size(sleepStructure(e).geno.data{g},2);
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
        Scaled {e,1} = NaN(max(nFish(e,:)), size(sleep_d{e},2));
        Scaled {e,2} = NaN(max(nFish(e,:)), size(sleep_n{e},2));
        Scaled {e,3} = NaN(max(nFish(e,:)), size(sleepbout_d{e},2));
        Scaled {e,4} = NaN(max(nFish(e,:)), size(sleepbout_n{e},2));
        Scaled {e,5} = NaN(max(nFish(e,:)), size(sleeplength_n{e},2));
        Scaled{e,6} = NaN(max(nFish(e,:)), size(sleeplength_d{e},2));
        Scaled{e,7} = NaN(max(nFish(e,:)), size(wactivity_d{e},2));
        Scaled {e,8} = NaN(max(nFish(e,:)), size(wactivity_n{e}, 2));
        for g=1:size(sleepStructure(e).geno.data,2) %every genotype is a column in the matrix(WT=1, het=2, Hom=3)
            Scaled {e,1} (:,g) = (sleep_d{e}(:,g)-nanmean(sleep_d{e}(:,ControlPos)))/... %day sleep
              nanmean(sleep_d{e}(:,ControlPos));
            Scaled {e,2} (:,g) = (sleep_n{e}(:,g)-nanmean(sleep_n{e}(:,ControlPos)))/...%night sleep
              nanmean(sleep_n{e}(:,ControlPos));
            Scaled{e,3} (:,g)=(sleepbout_d{e}(:,g)-nanmean(sleepbout_d{e}(:,ControlPos)))/...
              nanmean(sleepbout_d{e}(:,ControlPos));
            Scaled{e,4}(:,g)=(sleepbout_n{e}(:,g)-nanmean(sleepbout_n{e}(:,ControlPos)))/...
              nanmean(sleepbout_n{e}(:,ControlPos));
            Scaled {e,5}(:,g) = (sleeplength_d{e}(:,g)-nanmean(sleeplength_d{e}(:,ControlPos)))/... 
              nanmean(sleeplength_d{e}(:,ControlPos));
            Scaled{e,6}(:,g)=(sleeplength_n{e}(:,g)-nanmean(sleeplength_n{e}(:,ControlPos)))/...
              nanmean(sleeplength_n{e}(:,ControlPos));
            Scaled{e,7}(:,g)=(wactivity_d{e}(:,g)-nanmean(wactivity_d{e}(:,ControlPos)))/...
              nanmean(wactivity_d{e}(:,ControlPos));
            Scaled{e,8}(:,g)=(wactivity_n{e}(:,g)-nanmean(wactivity_n{e}(:,ControlPos)))/...
              nanmean(wactivity_n{e}(:,ControlPos));
        end  
    end
    
    %% now log the parameters for normalizing out the ones with exponential
    %distribution

    %day sleep and day and night sleep bouts length have exponential
%distribution
        %then scale them afterwards

    for e=1:size(sleepStructure,2) %every experiment
        %when 0s get logged they become infs, so first need to replace zeros
        %with v v low value - 0.000001
       sleep_d{e}(find(sleep_d{e}==0)) = 0.001;
       sleep_n{e}(find(sleep_n{e}==0)) = 0.001;
       sleepbout_d{e}(find(sleepbout_d{e}==0)) = 0.001;
       sleepbout_n{e}(find(sleepbout_n{e}==0)) = 0.001;
       wactivity_d{e}(find(wactivity_d{e}==0)) = 0.001;
       wactivity_n{e}(find(wactivity_n{e}==0)) = 0.001;

       %now normalise
       norm_sleep_d{e}=log(sleep_d{e}); %day sleep
       norm_sleep_n{e}=log(sleep_n{e});
       norm_sleeplength_d{e}=log(sleeplength_d{e});
       norm_sleeplength_n{e}=log(sleeplength_n{e});
       norm_sleepbout_d{e}=log(sleepbout_d{e});
       norm_sleepbout_n{e}=log(sleepbout_n{e});
       norm_wactivity_d{e} = log(wactivity_d{e});
       norm_wactivity_n{e}=log(wactivity_n{e});
    end

        %now do the scaling - make new cell array Scaled2
    for e=1:size(sleepStructure,2) 
        Scaled2 {e,1} = NaN(max(nFish(e,:)), size(sleep_d{e},2));
        Scaled2 {e,2} = NaN(max(nFish(e,:)), size(sleep_n{e},2));
        Scaled2 {e,3} = NaN(max(nFish(e,:)), size(sleepbout_d{e},2));
        Scaled2 {e,4} = NaN(max(nFish(e,:)), size(sleepbout_n{e},2));
        Scaled2 {e,5} = NaN(max(nFish(e,:)), size(sleeplength_n{e},2));
        Scaled2{e,6} = NaN(max(nFish(e,:)), size(sleeplength_d{e},2));
        Scaled2{e,7} = NaN(max(nFish(e,:)), size(wactivity_d{e},2));
        Scaled2 {e,8} = NaN(max(nFish(e,:)), size(wactivity_n{e}, 2));
        for g=1:size(sleepStructure(e).geno.data,2) %every genotype is a column in the matrix(WT=1, het=2, Hom=3)
            Scaled2 {e,1} (:,g) = (norm_sleep_d{e}(:,g)-nanmean(norm_sleep_d{e}(:,ControlPos)))/... %day norm_sleep
              nanmean(norm_sleep_d{e}(:,ControlPos));
            Scaled2 {e,2} (:,g) = (norm_sleep_n{e}(:,g)-nanmean(norm_sleep_n{e}(:,ControlPos)))/...%night norm_sleep
              nanmean(norm_sleep_n{e}(:,ControlPos));
            Scaled2{e,3} (:,g)=(norm_sleepbout_d{e}(:,g)-nanmean(norm_sleepbout_d{e}(:,ControlPos)))/...
              nanmean(norm_sleepbout_d{e}(:,ControlPos));
            Scaled2{e,4}(:,g)=(norm_sleepbout_n{e}(:,g)-nanmean(norm_sleepbout_n{e}(:,ControlPos)))/...
              nanmean(norm_sleepbout_n{e}(:,ControlPos));
            Scaled2 {e,5}(:,g) = (norm_sleeplength_d{e}(:,g)-nanmean(norm_sleeplength_d{e}(:,ControlPos)))/... 
              nanmean(norm_sleeplength_d{e}(:,ControlPos));
            Scaled2{e,6}(:,g)=(norm_sleeplength_n{e}(:,g)-nanmean(norm_sleeplength_n{e}(:,ControlPos)))/...
              nanmean(norm_sleeplength_n{e}(:,ControlPos));
            Scaled2{e,7}(:,g)=(norm_wactivity_d{e}(:,g)-nanmean(norm_wactivity_d{e}(:,ControlPos)))/...
              nanmean(norm_wactivity_d{e}(:,ControlPos));
            Scaled2{e,8}(:,g)=(norm_wactivity_n{e}(:,g)-nanmean(norm_wactivity_n{e}(:,ControlPos)))/...
              nanmean(norm_wactivity_n{e}(:,ControlPos));
        end 
    end  
            %make final cell array that contains scaled data for day sleep, and sleep
    %bout length, and non-scaled for the rest
    for e=1:size(sleepStructure,2);
       final_Scaled {e,1} = Scaled2 {e,1}; %day sleep
       final_Scaled{e,2} = Scaled{e,2}; %night sleep
       final_Scaled{e,3} = Scaled{e,3}; %day sleep bout
       final_Scaled{e,4} = Scaled{e,4}; %night sleep bout
       final_Scaled{e,5} = Scaled2{e,5}; %day sleep bout length
       final_Scaled{e,6} = Scaled2{e,6}; %night sleep bout length
       final_Scaled{e,7} = Scaled{e,7}; %day waking activity
       final_Scaled{e,8} = Scaled{e,8}; %night waking activity
    end
    
        %% now can combine data to see what comes out
    %vertcat these cell arrays to combine all experiments and then find
    %mean and sem
    final_Scaled_all = cell(1,size(Scaled2,2));
    final_Scaled_allmean = cell(1,size(Scaled2,2));
    final_Scaled_allsem = cell(1,size(Scaled2,2));
    for p = 1:size(final_Scaled,2) %every parameter
        final_Scaled_all{p} = vertcat(cell2mat(final_Scaled(:,p))); %concatenate matrices
        final_Scaled_allmean{p} = nanmean(final_Scaled_all{p})'; %find average
        final_Scaled_allsem{p} = (nanstd(final_Scaled_all{p})./...
            (sqrt(sum(~isnan(final_Scaled_all{p})))))';
    end
    
    %concatenate
    final_Scaled_allmean = cell2mat(final_Scaled_allmean);
    final_Scaled_allsem =cell2mat(final_Scaled_allsem);

    %do stats on final_Scaled_all
    for p=1:size(final_Scaled_all,1) %every parameter
        [P(p), tbl, stats]= kruskalwallis (final_Scaled_all{p}, [], 'off');
        mult {p} = multcompare(stats);
        close;
    end
    
    %now plot as errorbar
        %make legend first
    %make cell array for legend
    Leg = cell(size(nFish,2),1);
    for g = 1:size(nFish,2)
       Leg{g} = strcat(names{g}, ', n=', num2str(sum(nFish(:,g)))); 
    end
    
    figure;
    for i=1.5:2:8.5
        rectangle ('Position', [i -60 1 120], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
        hold on;
        rectangle ('Position', [i+1 -60 1 120], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
    end
    for g=1:size(names,2) %every genotype
        errorbar(final_Scaled_allmean(g,:)*100, final_Scaled_allsem(g,:)*100, 'o', 'Color', ...
            cmap(g,:), 'Markerfacecolor', cmap(g,:), 'Linewidth', 2);
        hold on
    end
    box off;
    xlim ([0.5 8.5]);
    ylim([-40 40]);
    ax=gca;
    ax.XTick = [1.5:2:7.5];
    ax.XTickLabel = {'Sleep' 'Sleep Bouts' 'Sleep bout length' 'Waking Activity'};
    ax.XTickLabelRotation = 45;
    ax.FontSize = 16;
    ax.YTick = [-40:10:40];
    ylabel ('% Change relative to WT', 'FontSize', 16);
    legend (Leg, 'FontSize', 18);
    %plot stats on top
    for i=1:size(mult,2)
      text(i-0.25, -20, strcat('P=', num2str(mult{i}(2,6))), 'Fontsize', 14) 
    end
    print(fullfile(saveDir, 'Summary'), '-depsc', '-tiff')
    savefig(fullfile(saveDir, 'Summary.fig'));
    close;
    
    clear e f g h i
    
    %save the stats to an excel spreadsheet
    features ={'Sleep_D' 'Sleep_N' 'SleepBoutD' 'SleepBoutN' 'Sleepboutlength_d'...
        'SleepboutLength_N' 'WactivityD' 'WactivityN' }
    for p = 1:size(mult,2)
        xlswrite(fullfile(saveDir, 'summary_combi.xls'), mult{p}, features{p}) 
    end
    
end
