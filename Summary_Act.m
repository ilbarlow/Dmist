function Summary_Act(folder, saveDir, names, ControlPos, cmap)
% this function generates the summary activity figures frome the .mat files
% generated from Jason's sleep analysis (which contains structures for
% sleep and activity). Saves figures and excel spreadsheet 

%Required functions:
    %dir2 by P.Henriques
    
    
%Inputs:
    %1. folder - directory of folder containing each experiment
    
    %2. SaveDir - directory to save output figures and files into
    
    %3. names - the number of conditions tested (including control)
    
    %4. controlPos - the position in the geno structure of the WT (ie 1 or
    %3)
    
    %5. cmap - colormap for making the figures; assume order 1.WT; 2.Het;
    %3.Hom
    
    %
%Outputs:
    % 1. .eps and .figs of the summaryAct figures
    % 2. spreadsheets of the stats
    
    
    %list the files to load
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
    
    %sort day and night data
    wake_day = cell(size(LB,2), nConditions);
    wake_night = cell(size(LB,2), nConditions);
    for e = 1:size(sleepStructure,2)    
        for j = 1:nConditions %WT = 3, Het = 2, Hom = 1 (genotype)
            wake_day{e,j}(:,:,1) = sleepStructure(e).geno.avewaking{j}(LB(3,e):LB(4,e),:); %day 5 from LB matrix
            wake_day {e,j} (:,:,2) = sleepStructure(e).geno.avewaking{j}(LB(5,e):LB(6,e),:); %day 6
            wake_night {e,j} (:,:,1) = sleepStructure(e).geno.avewaking{j}(LB(2,e):LB(3,e),:); %night 5
            wake_night {e,j} (:,:,2) = sleepStructure(e).geno.avewaking{j}(LB(4,e):LB(5,e),:); %night 6
        end
    end
    clear e i j

    %find then number of fish in each experiment and condition
    nFish = NaN(size(wake_day));
    for e =1:size(sleepStructure,2)
        for g = 1:size(wake_day,2)
            nFish (e,g) = size(wake_day{e,g},2);
        end
    end
    
    
    % filter set so that any minute with <0.1 sec min^-1 activity is counted as
    % inactivity
        %filter the waking activity values
    for e=1:size(sleepStructure,2)
        for g = 1:size(sleepStructure(e).geno.data,2)
                wake_day{e,g}(wake_day{e,g} <=0.1) = NaN;
                wake_night{e,g}(wake_night{e,g} <=0.1) = NaN;
        end
    end
    clear e g
    
    %% activity bout length - find the active bouts to make logical matrix -
    %inactivity is counted as any activity below 0.1

    %index to find activity
    wake_day_count = cell(size(wake_day));
    wake_night_count = cell(size(wake_night));
    for e=1:size(sleepStructure,2) %every experiment
        for j = 1:size(sleepStructure(e).geno.data,2) %each genotype
            wake_night_count {e,j} = ~isnan(wake_night{e,j});
            wake_day_count {e,j} = ~isnan(wake_day{e,j});
        end
    end


    %find how long activity bouts are in daytime data
    wakeday_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)   
        for j = 1:size(sleepStructure(e).geno.data,2)
            wakeday_length{e,j} = zeros (size(wake_day_count{e,j})); %make matrix of zeros

            wakeday_length{e,j} (1,:,:) = wake_day_count{e,j}(1,:,:);%fills in first row of activity to sleepStructureow the loop to run

            for k=1:nFish(e,j) %every fish

                for n =1:size(wake_day_count{e,j},3)  %find the activity bouts and calculate how long they are for each day (day 6 and day 7)      

                    for m = 2:size(wake_day_count{e,j},1) %for each time point

                        if wake_day_count{e,j}(m,k,n) + wake_day_count{e,j}(m-1,k,n)  == 2 %finds active bouts of more than one minute
                            scrap = wake_day_count{e,j}(m,k,n) + wakeday_length{e,j}(m-1,k,n);
                            wakeday_length{e,j}(m,k,n) = scrap;
                        else
                            scrap = wake_day_count{e,j}(m,k,n); %discounts inactive bouts
                            wakeday_length{e,j}(m,k,n) = scrap;
                        end
                        clear scrap;
                    end
                end
            end
        end
    end

    %add in row of zeros at end time point to sleepStructureow bout length calculation
        %now find the values of the active bouts
    wd_act_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)    
        for j=1:size(nFish,2) %each genotype
            wakeday_length{e,j}(end+1,:,:) = zeros; %add in row of zeros
            wd_act_length{e,j} = nan(size(wakeday_length{e,j},1), ...
                size(wakeday_length{e,j},2), size(wakeday_length{e,j},3));

                for k = 1:size(wakeday_length{e,j},2) %each fish
                   
                    for n = 1:size(wake_day{e,j},3) %each day
                        x=1;
                        
                        for m = 1:size(wakeday_length{e,j},1)-1 %every time point
                            
                            if wakeday_length{e,j}(m,k,n) > wakeday_length{e,j}(m+1,k,n)
                               wd_act_length{e,j}(x,k,n) = wakeday_length{e,j}(m,k,n); %waking activity bout length           
                               x = x+1;
                            end
                            
                        end
                        clear x                
                     end
                end
        end
    end

    % to remove NaNs
    for e=1:size(sleepStructure,2)
        for j = 1:nConditions %for each condition
            for i = 1:size(wd_act_length{e,j},3) %for each day
                scrap (i) = sum(any(wd_act_length{e,j}(:,:,i),2)); %find the the number of rows in the matrix that contain numbers and not nans
            end
            wd_act_length{e,j}(max(scrap)+1:end,:,:) = []; %deletes NaN rows
            clear scrap
        end
    end

        %% night wake bout length
    %now do the same for night activity
    wakenight_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)
        for j = 1:size(sleepStructure(e).geno.data,2)%each genotype
            wakenight_length{e,j} = zeros (size(wake_night_count{e,j})); 
            wakenight_length{e,j} (1,:,:) = wake_night_count{e,j}(1,:,:);%fills in first row of activity to allow the loop to run

            for k=1:size(wake_night_count{e,j}, 2)

                for n =1:size(wake_day{e,j},3)      
                    
                    %find the activity bouts and calculate how long they are
                       for m = 2:size(wake_night_count{e,j},1)
                            if wake_night_count {e,j}(m,k,n) + wake_night_count {e,j}(m-1,k,n)  == 2 %finds active bouts of more than one minute
                               scrap = wake_night_count{e,j}(m,k,n) + wakenight_length{e,j}(m-1,k,n);
                               wakenight_length{e,j}(m,k,n) = scrap;
                            else
                                scrap = wake_night_count{e,j}(m,k,n); %discounts inactive bouts
                                wakenight_length{e,j}(m,k,n) = scrap;
                            end
                        clear scrap;
                        end
                 end
            end
        end
    end

    %add in row of zeros at end time point to allow bout length calculation
    %now find the values of the active bouts
    wn_act_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)
        for i=1:size(nFish,2)
            wakenight_length{e,i}(end+1,:,:) = zeros;
            wn_act_length{e,i} = nan(size(wakenight_length{e,i}));

            for k = 1:size(wakenight_length{e,i},2)
                for n = 1:size(wake_night{e,i},3)
                    x=1;
                    for m = 1:size(wakenight_length{e,i},1)-1
                        if wakenight_length{e,i}(m,k,n) > wakenight_length{e,i}(m+1,k,n)
                           wn_act_length{e,i}(x,k,n) = wakenight_length{e,i}(m,k,n);           
                           x = x+1;
                        end
                    end
                    clear x
                end
            end
        end
    end

    % to remove NaNs
    for e=1:size(sleepStructure,2)
        for j = 1:size(nFish,2) %for each condition
            for i = 1:size(wn_act_length{e,j},3) %for each day
            scrap (i) = sum(any(wn_act_length{e,j}(:,:,i),2)); %find the the number of rows in the matrix that contain numbers and not nans
            end
            wn_act_length{e,j}(max(scrap)+1:end,:,:) = []; %deletes NaN rows
            clear scrap
        end
    end
    clear m n e j i k d
    
    
    %% sleep bout length across days and nights

%Nans == sleep
    sleep_day = cell(size(sleepStructure,2), nConditions);
    sleep_night = cell(size(sleepStructure,2), nConditions);
    for e = 1:size(sleepStructure,2)    
        for j = 1:nConditions
            sleep_day{e,j} = isnan(wake_day{e,j}); 
            sleep_night {e,j}= isnan(wake_night{e,j});
        end
    end
    
    %% find how long the sleep bouts are in daytime data
    
    %initiate cell arrays
    sleepday_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)   

        for j = 1:nConditions
            sleepday_length{e,j} = zeros (size(sleep_day{e,j})); %make matrix of zeros
            sleepday_length{e,j} (1,:,:) = sleep_day{e,j}(1,:,:);%fills in first row of sleep to allow the loop to run

            for k=1:nFish(e,j) %every fish

                for n =1:size(sleep_day{e,j},3)  %find the activity bouts and calculate how long they are for each day (day 6 and day 7)      

                    for m = 2:size(sleep_day{e,j},1) %for each time point

                        if sleep_day{e,j}(m,k,n) + sleep_day{e,j}(m-1,k,n)  == 2 %finds sleep bouts of more than one minute
                            scrap = sleep_day{e,j}(m,k,n) + sleepday_length{e,j}(m-1,k,n);
                            sleepday_length{e,j}(m,k,n) = scrap;
                        else
                            scrap = sleep_day{e,j}(m,k,n); %discounts inactive bouts
                            sleepday_length{e,j}(m,k,n) = scrap;
                        end
                        clear scrap;
                    end
                end
            end
        end
    end

%add in row of zeros at end time point to allow bout length calculation
%now find the values of the active bouts
    daySleepLength = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)    
        for j=1:size(sleepStructure(e).geno.data,2) %each genotype
            sleepday_length{e,j}(end+1,:,:) = zeros; %add in row of zeros
            daySleepLength{e,j} = nan(size(sleepday_length{e,j}));

                for k = 1:size(sleepday_length{e,j},2) %each fish
                    for n = 1:2 %each day
                        x=1;
                        for m = 1:size(sleepday_length{e,j},1)-1 %every time point
                            if sleepday_length{e,j}(m,k,n) > sleepday_length{e,j}(m+1,k,n)
                               daySleepLength{e,j}(x,k,n) = sleepday_length{e,j}(m,k,n); %sleep bout length           
                               x = x+1;
                            end
                        end
                        clear x
                    end
                end
        end
    end
    
    % to remove NaNs
    for e=1:size(sleepStructure,2)
        for j = 1:3 %for each condition
            for i = 1:size(daySleepLength{e,j},3) %for each day
                scrap (i) = sum(any(daySleepLength{e,j}(:,:,i),2)); %find the the number of rows in the matrix that contain numbers and not nans
            end
            daySleepLength{e,j}(max(scrap)+1:end,:,:) = []; %deletes NaN rows
            clear scrap
        end
    end

%% night bout length
%now do the same for night activity
   sleepnight_length = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)
        for j = 1:3 %each genotype
            sleepnight_length{e,j} = zeros (size(sleep_night{e,j}));
            sleepnight_length{e,j} (1,:,:) = sleep_night{e,j}(1,:,:);%fills in first row of activity to allow the loop to run

            for k=1:size(sleep_night{e,j}, 2)

                for n =1:size(sleep_night{e,j},3)       
                    %find the activity bouts and calculate how long they are
                       for m = 2:size(sleep_night{e,j},1)
                            if sleep_night {e,j}(m,k,n) + sleep_night {e,j}(m-1,k,n)  == 2 %finds active bouts of more than one minute
                               scrap = sleep_night{e,j}(m,k,n) + sleepnight_length{e,j}(m-1,k,n); %make temporary number counting up cumulative
                               sleepnight_length{e,j}(m,k,n) = scrap;
                            else
                                scrap = sleep_night{e,j}(m,k,n); %discounts active bouts
                                sleepnight_length{e,j}(m,k,n) = scrap;
                            end
                        clear scrap;
                       end
                end
             end
        end
    end

%add in row of zeros at end time point to allow bout length calculation
%now find the values of the active bouts
    nightSleepLength = cell(size(sleepStructure,2), nConditions);
     for e=1:size(sleepStructure,2)
        for i=1:nConditions
            sleepnight_length{e,i}(end+1,:,:) = zeros;
            nightSleepLength{e,i} = nan(size(sleepnight_length{e,i}));

            for k = 1:size(sleepnight_length{e,i},2)
                for n = 1:size(sleepnight_length{e,j},3)
                    x=1;
                    for m = 1:size(sleepnight_length{e,i},1)-1
                        if sleepnight_length{e,i}(m,k,n) > sleepnight_length{e,i}(m+1,k,n)
                           nightSleepLength{e,i}(x,k,n) = sleepnight_length{e,i}(m,k,n);           
                           x = x+1;
                        end
                    end
                    clear x
                end
            end
        end
    end

    % to remove NaNs
    for e=1:size(sleepStructure,2)
        for j = 1:nConditions %for each genotype
            for i = 1:size(nightSleepLength{e,j},3) %for each day
                scrap (i) = sum(any(nightSleepLength{e,j}(:,:,i),2)); %find the the number of rows in the matrix that contain numbers and not nans
            end
            nightSleepLength{e,j}(max(scrap)+1:end,:,:) = []; %deletes NaN rows
            clear scrap
        end
    end
    clear e g d j k m n

    %caculate total number of bouts and total total
    dayActiveNumber = cell(size(sleepStructure,2), nConditions);
    nightActiveNumber = cell(size(sleepStructure,2), nConditions);
    daySleepNumber = cell(size(sleepStructure,2), nConditions);
    nightSleepNumber = cell(size(sleepStructure,2), nConditions);
    dayActTotal =cell(size(sleepStructure,2), nConditions);
    nightActTotal = cell(size(sleepStructure,2), nConditions);
    daySleepTotal = cell(size(sleepStructure,2), nConditions);
    nightSleepTotal = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2)
        for g=1:size(sleepStructure(e).geno.data,2)
            dayActiveNumber{e,g}= sum(~isnan(wd_act_length{e,g})); %total number of active bouts
            nightActiveNumber{e,g} = sum(~isnan(wn_act_length{e,g}));
            daySleepNumber{e,g} = sum(~isnan(daySleepLength{e,g}));%total number of sleep bouts
            nightSleepNumber{e,g}=sum(~isnan(nightSleepLength{e,g}));
            dayActTotal{e,g} = nansum(wd_act_length{e,g}); %total length of active bouts
            nightActTotal{e,g}=nansum(wn_act_length{e,g});
            daySleepTotal {e,g} = nansum(daySleepLength{e,g}); %total sleep length
            nightSleepTotal {e,g} = nansum(nightSleepLength{e,g});
        end
    end
    
    %activity bout length has an exponential distribution
%take log of active bout length
    normDactLength = cell(size(sleepStructure,2),nConditions);
    normNactLength = cell(size(sleepStructure,2),nConditions);
    normDactNumber = cell(size(sleepStructure,2), nConditions);
    normNactNumber = cell(size(sleepStructure,2), nConditions);
    for e=1:size(sleepStructure,2) %every experiment
       for g=1:size(sleepStructure(e).geno.data,2) %every genotype
          normDactLength{e,g} = log10(wd_act_length{e,g}(:,:,:)); %log10 so scaled 0 to 3
          normNactLength{e,g} = log10(wn_act_length{e,g}(:,:,:)); %log10
          normDactNumber{e,g} = log10(dayActiveNumber{e,g}(:,:,:));
          normNactNumber{e,g} = log10(nightActiveNumber{e,g}(:,:,:));
       end
    end
    
    %make activity into single matrices for each day/night
    wakeDay3 = cell(size(sleepStructure,2), nConditions, 3);
    wakeNight3 = cell(size(sleepStructure,2), nConditions,3);
    for e=1:size(sleepStructure,2)
       for g=1:nConditions %each genotype
           for d=1:size(wake_day{e,g},3) %every day
                wakeDay3{e,g,d} = wake_day{e,g}(:,:,d);
                wakeNight3{e,g,d}=wake_night{e,g}(:,:,d);
           end
       end      
    end

    %now to scale the activity parameters - for two days and two nights
    clear Scaled_act
    Scaled_act = cell(size(sleepStructure,2),nConditions);
    for e=1:size(sleepStructure,2) %every experiment
        Scaled_act{e,1} = NaN(max(nFish(e,:)), size(nFish,2));
        Scaled_act{e,3} = NaN(max(nFish(e,:)), size(nFish,2));
        Scaled_act{e,4} = NaN(max(nFish(e,:)), size(nFish,2));
        Scaled_act{e,5} = NaN(max(nFish(e,:)), size(nFish,2));
        Scaled_act{e,6} = NaN(max(nFish(e,:)), size(nFish,2));

        for g=1:nConditions %every genotype

            Scaled_act {e,1}(1:size(normDactLength{e,g},2),g) = ...
                (nanmean(vertcat(normDactLength{e,g}(:,:,1), normDactLength{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(normDactLength{e,ControlPos}(:,:,1), normDactLength{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(normDactLength{e,ControlPos}(:,:,1), normDactLength{e,ControlPos}(:,:,2)))'); %scaled day activity length

            Scaled_act{e,2}(1:size(normNactLength{e,g},2),g) = ...
                (nanmean(vertcat(normNactLength{e,g}(:,:,1), normNactLength{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(normNactLength{e,ControlPos}(:,:,1), normNactLength{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(normNactLength{e,ControlPos}(:,:,1), normNactLength{e,ControlPos}(:,:,2)))');  %scaled night activity length

            Scaled_act{e,3}(1:size(normDactNumber{e,g},2),g) = ...
                (nanmean(vertcat(normDactNumber{e,g}(:,:,1), normDactNumber{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(normDactNumber{e,ControlPos}(:,:,1), normDactNumber{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(normDactNumber{e,ControlPos}(:,:,1), normDactNumber{e,ControlPos}(:,:,2)))'); %scaled day number of active bouts

            Scaled_act{e,4} (1:size(normNactNumber{e,g},2),g) =...
                 (nanmean(vertcat(normNactNumber{e,g}(:,:,1), normNactNumber{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(normNactNumber{e,ControlPos}(:,:,1), normNactNumber{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(normNactNumber{e,ControlPos}(:,:,1), normNactNumber{e,ControlPos}(:,:,2)))'); %scaled night number of active bouts
            
            Scaled_act{e,5}(1:size(wake_day{e,g},2),g) = ...
                 (nanmean(vertcat(wake_day{e,g}(:,:,1), wake_day{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(wake_day{e,ControlPos}(:,:,1), wake_day{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(wake_day{e,ControlPos}(:,:,1), wake_day{e,ControlPos}(:,:,2)))'); %scaled day wactivity
            
            Scaled_act{e,6}(1:size(wake_night{e,g},2),g) =  ...
                (nanmean(vertcat(wake_night{e,g}(:,:,1), wake_night{e,g}(:,:,2)))'...
                - nanmean(nanmean(vertcat(wake_night{e,ControlPos}(:,:,1), wake_night{e,ControlPos}(:,:,2)))'))/...
                nanmean(nanmean(vertcat(wake_night{e,ControlPos}(:,:,1), wake_night{e,ControlPos}(:,:,2)))');%scaled night wactivity 
        end
    end

    %now find mean and sem for figure of separate experiments
    Scaled_act_mean = cell(size(sleepStructure,2),1);
    Scaled_act_sem = cell(size(sleepStructure,2),1);
    for e=1:size(sleepStructure,2) %every experiment
       for p=1:size(Scaled_act,2) %each parameter
          Scaled_act_mean{e}(:,p) = nanmean(Scaled_act{e,p})'; %every row is a
            %different genotype, every column is a parameter
          Scaled_act_sem{e} (:,p) = (nanstd(Scaled_act{e,p})')./ ...
              (sqrt(sum(~isnan(Scaled_act{e,p})))'); %sem
       end
    end
    
    %%plots
    
    for e=1:size(sleepStructure,2)
        figure;
        for i=1.5:2:6.5
            rectangle ('Position', [i -60 1 120], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
            hold on;
            rectangle ('Position', [i+1 -60 1 120], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
        end
        for g=1:size(nFish,2) %each genotype
            errorbar(Scaled_act_mean{e}(g,:)*100,...
                Scaled_act_sem{e}(g,:)*100, 'o', 'Color', ...
                cmap(g,:), 'Markerfacecolor', cmap(g,:), 'Linewidth', 2);
            hold on;
        end
        box off
        ax=gca;
        ax.XTick = [1.5:2:5.5];
        ax.XTickLabel = {'Activity bout length' 'Number of active bouts' 'Waking Activity'};
        ax.XTickLabelRotation = 45;
        ax.FontSize = 16;
        xlim ([0.5 6.5]);
        ylim([-50 50]);
        ylabel ('% Change relative to WT', 'FontSize', 16);
        legend (names, 'FontSize', 18);
        title (strcat('Experiment', num2str(e)), 'FontSize', 18)
    end
    %%
    %now concanenate experiments for each parameter separately
    Scaled_act_all = cell(6);
    Scaled_act_allmean = NaN(size(nFish,2),6);
    Scaled_act_allsem = NaN(size(nFish,2),6);
    for p=1:size(Scaled_act,2) %every parameter, every row a genotype
   
        Scaled_act_all {p} = cell2mat(Scaled_act(:,p)); %concatenate
   
        Scaled_act_allmean(:,p) = nanmean(Scaled_act_all{p})'; %calculate mean
   
        Scaled_act_allsem(:,p) = (nanstd(Scaled_act_all{p})./ ...
        (sqrt(sum(~isnan(Scaled_act_all{p})))))'; %calculate sem
    end
    
    for p=1:size(Scaled_act_all,2) %every parameter
        [P(p), tbl, stats] = kruskalwallis (Scaled_act_all{p}, [], 'off');
        mult{p} = multcompare(stats);
        close
    end

 %mult{p} contains the specific pair-wise P values for each test - I am
 %going to put the WT vs HOM P value on the figure and then export the
 %other 

    %make cell array for legend
    Leg = cell(size(nFish,2),1);
    for g = 1:size(nFish,2)
       Leg{g} = strcat(names{g}, ', n=', num2str(sum(nFish(:,g)))); 
    end
    
    
    figure;
    %cmap = flip(cmap);
    for i=1.5:2:6.5
        rectangle ('Position', [i -60 1 120], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
        hold on;
        rectangle ('Position', [i+1 -60 1 120], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
    end
    for g=1:size(nFish,2) %each genotype
        errorbar(Scaled_act_allmean(g,:)*100,  Scaled_act_allsem(g,:)*100, 'o', 'Color', ...
        cmap(g,:), 'Markerfacecolor', cmap(g,:), 'Linewidth', 2);
        hold on;
    end
    box off
    ax=gca;
    ax.XTick = [1.5:2:5.5]
    ax.XTickLabel = {'Activity bout length' 'Active bouts' 'Waking Activity'};
    ax.XTickLabelRotation = 45;
    ax.FontSize = 16
    xlim ([0.5 6.5])
    ylim([-40 40])
    ax.YTick=[-40:10:40]
    ylabel ('% Change relative to WT', 'FontSize', 16);
    legend (Leg,'FontSize', 18);
    %plot stats on top
    for i=1:size(mult,2)
       text(i-0.25, -20, strcat('P=', num2str(mult{i}(2,6))), 'Fontsize', 14) 
    end
    print(fullfile(saveDir, 'SummaryAct'), '-depsc', '-tiff')
    savefig(fullfile(saveDir, 'SummaryAct.fig'));
    close;
    
    
    features ={'Activity_bout_lengthD' 'Activity_bout_lengthN'...
    'Number_active_boutsD' 'Number_active_boutsN'  'Waking_ActivityD' 'Waking_ActivityN'}
    for p = 1:size(mult,2)
        xlswrite(fullfile(saveDir, 'activity_combi.xls'), mult{p}, features{p}) 
    end

end
