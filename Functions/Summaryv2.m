function Summaryv2 (folder, saveDir, ControlPos, cmap)
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
    
    metadata =struct;
    %     names = cell(size(sleepStructure,2),1);
    for n =1:size(sleepStructure,2)
       metadata(n).nConditions = size(sleepStructure(n).geno.name,2);
       metadata(n).names = sleepStructure(n).geno.name;
       metadata(n).nFish = NaN(metadata(n).nConditions,1);
       for g = 1:metadata(n).nConditions
           metadata(n).nFish(g) = size(sleepStructure(n).geno.data{g},2);
       end
    end
    

    %make summary table of sleep parameters
    %for both experiments and look at day and night sleep architecture - only
        %for days two and three (ie complete days and nights)
    Features = struct; 
%         sleepD = struct;
%     sleepN = struct;
%     sleepBoutD = struct;
%     sleepBoutN = struct;
%     sleepLengthD = struct;
%     sleepLengthN = struct;
%     wActivityD = struct;
%     wActivityN = struct;
    for i = 1:size(sleepStructure,2) %each experiment
        Features(i).sleepD = nan(max(metadata(i).nFish),size(metadata(i).nFish,1)); %nan table to fit data into    
        Features(i).sleepN = nan(max(metadata(i).nFish),size(metadata(i).nFish,1));     
        Features(i).sleepLengthD = nan(max(metadata(i).nFish),size(metadata(i).nFish,1));    
        Features(i).sleepLengthN = nan(max(metadata(i).nFish),size(metadata(i).nFish,1));   
        Features(i).sleepBoutD = nan(max(metadata(i).nFish),size(metadata(i).nFish,1));     
        Features(i).sleepBoutN = nan(max(metadata(i).nFish),size(metadata(i).nFish,1));   
        Features(i).wActivityD  =nan(max(metadata(i).nFish),size(metadata(i).nFish,1));     
        Features(i).wActivityN  = nan(max(metadata(i).nFish),size(metadata(i).nFish,1)); 
            for j=1:metadata(i).nConditions %each genotype
                Features(i).sleepD (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleep.day{j}(2:3,:))'; % fill in average day sleep
                Features(i).sleepBoutD (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepBout.day{j}(2:3,:))'; %average day sleep bout
                Features(i).sleepLengthD (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepLength.day{j}(2:3,:))'; %average day sleep bout length
                Features(i).sleepN (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleep.night{j}(2:3,:))'; % average night sleep (total)
                Features(i).sleepBoutN (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepBout.night{j}(2:3,:))'; %average night sleep bout
                Features(i).sleepLengthN (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.sleepLength.night{j}(2:3,:))'; %average night sleep bout length
                Features(i).wActivityD  (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.averageWaking.day{j}(2:3,:))';%average day wactivity
                Features(i).wActivityN (:,j) = ...
                    nanmean(sleepStructure(i).geno.summarytable.averageWaking.night{j}(2:3,:))'; %average night wactivity
            end
    end

    %first make cell array of scaled not normalised data
    ScaledFeatures = struct;
    for e=1:size(sleepStructure,2) %every experiment
        ScaledFeatures.sleepD  = NaN(max(metadata(e).nFish), size(Features(e).sleepD ,2));
        ScaledFeatures.sleepN  = NaN(max(metadata(e).nFish), size(Features(e).sleepN ,2));
        Scaled {e,3} = NaN(max(nFish(e,:)), size(sleepBoutD{e},2));
        Scaled {e,4} = NaN(max(nFish(e,:)), size(sleepBoutN{e},2));
        Scaled {e,5} = NaN(max(nFish(e,:)), size(sleepLengthN{e},2));
        Scaled{e,6} = NaN(max(nFish(e,:)), size(sleepLengthD{e},2));
        Scaled{e,7} = NaN(max(nFish(e,:)), size(wActivityD{e},2));
        Scaled {e,8} = NaN(max(nFish(e,:)), size(wActivityN{e}, 2));
        for g=1:size(sleepStructure(e).geno.data,2) %every genotype is a column in the matrix(WT=1, het=2, Hom=3)
            Scaled {e,1} (:,g) = (sleepD{e}(:,g)-nanmedian(sleepD{e}(:,ControlPos)))/... %day sleep
              nanmedian(sleepD{e}(:,ControlPos));
            Scaled {e,2} (:,g) = (sleepN{e}(:,g)-nanmedian(sleepN{e}(:,ControlPos)))/...%night sleep
              nanmedian(sleepN{e}(:,ControlPos));
            Scaled{e,3} (:,g)=(sleepBoutD{e}(:,g)-nanmedian(sleepBoutD{e}(:,ControlPos)))/...
              nanmedian(sleepBoutD{e}(:,ControlPos));
            Scaled{e,4}(:,g)=(sleepBoutN{e}(:,g)-nanmedian(sleepBoutN{e}(:,ControlPos)))/...
              nanmedian(sleepBoutN{e}(:,ControlPos));
            Scaled {e,5}(:,g) = (sleepLengthD{e}(:,g)-nanmedian(sleepLengthD{e}(:,ControlPos)))/... 
              nanmedian(sleepLengthD{e}(:,ControlPos));
            Scaled{e,6}(:,g)=(sleepLengthN{e}(:,g)-nanmedian(sleepLengthN{e}(:,ControlPos)))/...
              nanmedian(sleepLengthN{e}(:,ControlPos));
            Scaled{e,7}(:,g)=(wActivityD{e}(:,g)-nanmedian(wActivityD{e}(:,ControlPos)))/...
              nanmedian(wActivityD{e}(:,ControlPos));
            Scaled{e,8}(:,g)=(wActivityN{e}(:,g)-nanmedian(wActivityN{e}(:,ControlPos)))/...
              nanmedian(wActivityN{e}(:,ControlPos));
        end  
    end
    
    %% now log the parameters for normalizing out the ones with exponential
    %distribution

    %day sleep and day and night sleep bouts length have exponential
%distribution
        %then scale them afterwards
    norm_sleep_d = cell(size(sleepStructure,2),1);
    norm_sleep_n = cell(size(sleepStructure,2),1);
    norm_sleeplength_d = cell(size(sleepStructure,2),1);
    norm_sleeplength_n = cell(size(sleepStructure,2),1);
    norm_sleepbout_d = cell(size(sleepStructure,2),1);
    norm_sleepbout_n =cell(size(sleepStructure,2),1);
    norm_wactivity_d= cell(size(sleepStructure,2),1);
    norm_wactivity_n = cell(size(sleepStructure,2),1);
    for e=1:size(sleepStructure,2) %every experiment
        %when 0s get logged they become infs, so first need to replace zeros
        %with v v low value - 0.000001
       sleepD{e}(sleepD{e}==0) = 0.001;
       sleepN{e}(sleepN{e}==0) = 0.001;
       sleepBoutD{e}(sleepBoutD{e}==0) = 0.001;
       sleepBoutN{e}(sleepBoutN{e}==0) = 0.001;
       wActivityD{e}(wActivityD{e}==0) = 0.001;
       wActivityN{e}(wActivityN{e}==0) = 0.001;

       %now normalise
       norm_sleep_d{e}=log(sleepD{e}); %day sleep
       norm_sleep_n{e}=log(sleepN{e});
       norm_sleeplength_d{e}=log(sleepLengthD{e});
       norm_sleeplength_n{e}=log(sleepLengthN{e});
       norm_sleepbout_d{e}=log(sleepBoutD{e});
       norm_sleepbout_n{e}=log(sleepBoutN{e});
       norm_wactivity_d{e} = log(wActivityD{e});
       norm_wactivity_n{e}=log(wActivityN{e});
    end

    %now do the scaling - make new cell array Scaled2
    Scaled2 = cell(size(sleepStructure,2), 8);
    for e=1:size(sleepStructure,2) 
        Scaled2 {e,1} = NaN(max(nFish(e,:)), size(sleepD{e},2));
        Scaled2 {e,2} = NaN(max(nFish(e,:)), size(sleepN{e},2));
        Scaled2 {e,3} = NaN(max(nFish(e,:)), size(sleepBoutD{e},2));
        Scaled2 {e,4} = NaN(max(nFish(e,:)), size(sleepBoutN{e},2));
        Scaled2 {e,5} = NaN(max(nFish(e,:)), size(sleepLengthN{e},2));
        Scaled2{e,6} = NaN(max(nFish(e,:)), size(sleepLengthD{e},2));
        Scaled2{e,7} = NaN(max(nFish(e,:)), size(wActivityD{e},2));
        Scaled2 {e,8} = NaN(max(nFish(e,:)), size(wActivityN{e}, 2));
        for g=1:size(sleepStructure(e).geno.data,2) %every genotype is a column in the matrix(WT=1, het=2, Hom=3)
            Scaled2 {e,1} (:,g) = (norm_sleep_d{e}(:,g)-nanmedian(norm_sleep_d{e}(:,ControlPos)))/... %day norm_sleep
              nanmedian(norm_sleep_d{e}(:,ControlPos));
            Scaled2 {e,2} (:,g) = (norm_sleep_n{e}(:,g)-nanmedian(norm_sleep_n{e}(:,ControlPos)))/...%night norm_sleep
              nanmedian(norm_sleep_n{e}(:,ControlPos));
            Scaled2{e,3} (:,g)=(norm_sleepbout_d{e}(:,g)-nanmedian(norm_sleepbout_d{e}(:,ControlPos)))/...
              nanmedian(norm_sleepbout_d{e}(:,ControlPos));
            Scaled2{e,4}(:,g)=(norm_sleepbout_n{e}(:,g)-nanmedian(norm_sleepbout_n{e}(:,ControlPos)))/...
              nanmedian(norm_sleepbout_n{e}(:,ControlPos));
            Scaled2 {e,5}(:,g) = (norm_sleeplength_d{e}(:,g)-nanmedian(norm_sleeplength_d{e}(:,ControlPos)))/... 
              nanmedian(norm_sleeplength_d{e}(:,ControlPos));
            Scaled2{e,6}(:,g)=(norm_sleeplength_n{e}(:,g)-nanmedian(norm_sleeplength_n{e}(:,ControlPos)))/...
              nanmedian(norm_sleeplength_n{e}(:,ControlPos));
            Scaled2{e,7}(:,g)=(norm_wactivity_d{e}(:,g)-nanmedian(norm_wactivity_d{e}(:,ControlPos)))/...
              nanmedian(norm_wactivity_d{e}(:,ControlPos));
            Scaled2{e,8}(:,g)=(norm_wactivity_n{e}(:,g)-nanmedian(norm_wactivity_n{e}(:,ControlPos)))/...
              nanmedian(norm_wactivity_n{e}(:,ControlPos));
        end 
    end  
            %make final cell array that contains scaled data for day sleep, and sleep
    %bout length, and non-scaled for the rest
    finalScaled = cell(size(sleepStructure,2), 8);
    for e=1:size(sleepStructure,2);
       finalScaled {e,1} = Scaled2 {e,1}; %day sleep
       finalScaled{e,2} = Scaled{e,2}; %night sleep
       finalScaled{e,3} = Scaled2{e,3}; %day sleep bout
       finalScaled{e,4} = Scaled{e,4}; %night sleep bout
       finalScaled{e,5} = Scaled2{e,5}; %day sleep bout length
       finalScaled{e,6} = Scaled2{e,6}; %night sleep bout length
       finalScaled{e,7} = Scaled{e,7}; %day waking activity
       finalScaled{e,8} = Scaled{e,8}; %night waking activity
    end
    
        %% now can combine data to see what comes out
    %vertcat these cell arrays to combine all experiments and then find
    %mean and sem
    finalScaled_all = cell(1,size(Scaled2,2));
    finalScaled_allmean = cell(1,size(Scaled2,2));
    finalScaled_allsem = cell(1,size(Scaled2,2));
    for p = 1:size(finalScaled,2) %every parameter
        finalScaled_all{p} = vertcat(cell2mat(finalScaled(:,p))); %concatenate matrices
        finalScaled_allmean{p} = nanmedian(finalScaled_all{p})'; %find average
        finalScaled_allsem{p} = (nanstd(finalScaled_all{p})./...
            (sqrt(sum(~isnan(finalScaled_all{p})))))';
    end
    
    %concatenate
    finalScaled_allmean = cell2mat(finalScaled_allmean);
    finalScaled_allsem =cell2mat(finalScaled_allsem);

    %do stats on finalScaled_all
    P = NaN(size(finalScaled_all,2),1);
    mult = cell(size(finalScaled_all,2),1);
    for p=1:size(finalScaled_all,2) %every parameter
        [P(p), ~, stats]= kruskalwallis (finalScaled_all{p}, [], 'off');
        mult {p} = multcompare(stats,  'ctype', 'dunn-sidak');
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
        errorbar(finalScaled_allmean(g,:)*100, finalScaled_allsem(g,:)*100, 'o', 'Color', ...
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
    for i=1:size(mult,1)
      text(i-0.25, -20, strcat('P=', num2str(mult{i}(2,6))), 'Fontsize', 14) 
    end
    print(fullfile(saveDir, 'Summary'), '-depsc', '-tiff')
    savefig(fullfile(saveDir, 'Summary.fig'));
    close;
    
    clear e f g h i
    
    %save the stats to an excel spreadsheet
    features ={'Sleep_D' 'Sleep_N' 'SleepBoutD' 'SleepBoutN' 'Sleepboutlength_d'...
        'SleepboutLength_N' 'WactivityD' 'WactivityN' }
    for p = 1:size(mult,1)
        xlswrite(fullfile(saveDir, 'summary_combi.xls'), mult{p}, features{p}) 
    end
    
end
