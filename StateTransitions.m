function StateTransitions (folder, saveDir,names, cmap)
    %list the files to load
    files =dir2(folder);
    
    nConditions = size(names,2);
    
    %load the workspaces
    %now load the .mat files - top file is .DS_store hidden file
    %sleepStructure = struct([]);
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
    
    %make a copy
    wake_day2 = wake_day;
    wake_night2 = wake_night;

    %% first scale the data

         %for every experiment and genotype and fish scale the activity by
         %its own maximum
           %preallocate cell arrays
         maximumsf = cell(2, size(files,1));
         wake_day_scaled = cell(size(wake_day));
         wake_night_scaled = cell(size(wake_night));
        
         for e=1:size(wake_day2,1) %every experiment

            for g=1:size(wake_day2,2) %every genotype
                maximumsf{e,g} = NaN(max(nFish(e,:)),size(nFish,2), size(wake_day{e,g},3));
                for d=1:size(wake_day2{e,g},3) %every day and night
                    for f=1:size(wake_day2{e,g},2) %for every fish
                        maximumsf{1,e}(f,g,d) = max(wake_day2{e,g}(:,f,d)); %day

                        maximumsf{2,e}(f,g,d)=max(wake_night2{e,g}(:,f,d)); %night
                    end
                end

                for d=1:size(wake_day2{e,g},3)

                    for f=1:size(wake_day2{e,g},2)

                        %now scale the wake_night and day values for every day and night

                        wake_day_scaled{e,g}(:,f,d)=wake_day2{e,g}(:,f,d)/...
                    maximumsf{1,e}(f,g,d);

                        wake_night_scaled{e,g}(:,f,d) = wake_night2{e,g}(:,f,d)./...
                    maximumsf{2,e}(f,g,d);

                    end
                end
            end
        end

    %% determine how many clusters to partition wake states into

    %partition days and nights into separate cell arrays
    wake_night_clusters = cell(wake_night_scaled);
    wake_day_clusters = cell(wake_day_scaled);
    for e=1:size(all,2)
        for g=1:size(all(e).geno.data,2)
            for d=1:size(wake_day{e,g},3)
                wake_night_clusters {e,g,d} = wake_night_scaled{e,g}(:,:,d);%only night 1
                wake_day_clusters{e,g,d} = wake_day_scaled{e,g}(:,:,d);

            end
            wake_night_clusters {e,g,3} = vertcat(wake_night_clusters{e,g,1},...
                wake_night_clusters{e,g,2});
            wake_day_clusters{e,g,3} = vertcat(wake_day_clusters{e,g,1}, ...
                wake_day_clusters{e,g,2});
        end
    end


    %determine the number of clusters required - this is lifted from
    %best_kmeans function
    for e=1:size(sleepStructure,2) %for every experiment

        for d= 1:size(wake_day_clusters,3) %every day and night separately and combined

            for i=1:10 %try 10 clusters for each experiment

                X = vertcat(wake_night_clusters{e,1,d}(:), wake_night_clusters{e,2,d}(:),...
                wake_night_clusters{e,3,d}(:)); %input wake data

                [~,~, SUMD] = kmeans(X,i, 'emptyaction', 'drop'); %calculate K-means

                distortion (i)= nansum (SUMD); %calculate sum of squares

            end

            variance=distortion(1:end-1)-distortion(2:end); %subtract the sum of squares for each cluster number

            distortion_percent{e,d}=cumsum(variance)/(distortion(1)-distortion(end)); %calculate as a percentage of total residuals

            r{e,d} = find(distortion_percent{e,d}>0.9); %find point at which over 90% of data is explain by fewest number of clusters 

            KN(e,d)=r{e}(1)+1; 

        %plot the curves
        %figure;
        %plot(distortion_percent{e,d,i},'b*--');
        %ylabel ('Variance Explained');
        %xlabel ('Number of clusters')
        %hold on;
        %stem (KN(e,d), 1, 'k');
        clear X distortion variance SUMD %distortion_percent 
       end
    end
     clear r
     clear K

    %for all experiments looks like 4 clusters is best, , set K=4
    K(1)=max(KN(:)); %night time K

    %plot a figure to show number of clusters was detemines
    figure;
    h1=shadedErrorBar_2(1:size(distortion_percent{1,3},2), ...
        nanmean(cell2mat(distortion_percent(:,3))), ...
        nanstd(cell2mat(distortion_percent(:,3))), {'color', 'k'});
    hold on;
    h2=stem (K(1), 1, 'k*', 'linewidth', 2);
    legend ([h1.patch], 'N=5')
    ylabel ('Variance Explained');
    xlabel ('Number of clusters');
    box off;
    ylim ([0 1.1])
    title ('Night clusters')
    ax=gca;
    ax.YTick = [0:0.1:1];
    ax.YMinorTick = 'on';
    ax.XTick =[0:1:10];

    clear distortion_percent



end
