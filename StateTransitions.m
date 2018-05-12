function StateTransitions (folder, saveDir,names, ControlPos, cmap)
%This function performs K-means clustering on the day and night day and
% night activity values, separately. The activity of each fish is scaled by
% its max and min before clustering. Distortion is used to determine the
% number of clusters to assign the data into.

%required functions
    %dir2 by P Henriques and M Ghosh
    %ShadedErrorBar_2
    %dist_plot

%Inputs:
    %folder - directory containing the .mat files generated by
    %sleepAnalysis by J.Rihel
    
    %saveDir - directory into which the figures and spreadsheet should be
    %saved
    
    %names - names of each of the conditions (ie the genotypes/ drug doses)
    
    %cmap - colormap to use for figures

%Outputs:
    %

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
        for j = 1:nConditions %genotypes group
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
    
     %flip groups if WT is not group 3
    if ControlPos ~= 1
        names = fliplr(names)
        wake_day = fliplr(wake_day)
        wake_night= fliplr (wake_night)
        nFish = fliplr(nFish)
        cmap = flip(cmap);
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
    for e=1:size(sleepStructure,2)
        for g=1:size(sleepStructure(e).geno.data,2)
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
        %best_kmeans function (external)
    % preallocate matrices and arrays
    distortion = nan(10,1);
    distortionPercent = cell(size(sleepStructure,2), size(wake_day_clusters,3)); %distortion
    r = cell(size(sleepStructure,2), size(wake_day_clusters,3)); %cumvar cutoff
    KD = NaN (size(sleepStructure,2), size(wake_day_clusters,3)); %K means cut off
    
    K = NaN(2); %matrix to decide number of clusters
    
    %day first
    for e=1:size(sleepStructure,2) %for every experiment

        for d= 1:size(wake_day_clusters,3) %every day and night separately and combined
            
            X = vertcat(wake_day_clusters{e,1,d}(:), wake_day_clusters{e,2,d}(:),...
                wake_day_clusters{e,3,d}(:)); %input wake data
            
            for i=1:10 %try 10 clusters for each experiment - this can be changed

                [~,~, SUMD] = kmeans(X,i, 'emptyaction', 'drop'); %calculate K-means

                distortion (i)= nansum (SUMD); %calculate sum of squares

             end

            variance=distortion(1:end-1)-distortion(2:end); %subtract the sum of squares for each cluster number

            distortionPercent{e,d}=cumsum(variance)/(distortion(1)-distortion(end)); %calculate as a percentage of total residuals

            r{e,d} = find(distortionPercent{e,d}>0.9); %find point at which over 90% of data is explain by fewest number of clusters 

            KD(e,d)=r{e,d}(1)+1; 
        clear X variance SUMD 
       end
    end
     clear r
     
    K(1)=max(KD(:)); %day time K

    %plot a figure to show number of clusters was detemines
    figure;
    h1=shadedErrorBar_2(1:size(distortionPercent{1,3},1), ...
        nanmean(cell2mat(distortionPercent(:,3)'),2), ...
        nanstd(cell2mat(distortionPercent(:,3)')'), {'color', 'b'});
    hold on;
    h2=stem (K(1), 1, 'b*', 'linewidth', 2);
    legend ([h1.patch], strcat('N=', num2str(size(KD,1))))
    ylabel ('Variance Explained');
    xlabel ('Number of clusters');
    box off;
    ylim ([0 1.1])
    title ('Day clusters')
    ax=gca;
    ax.YTick = (0:0.1:1);
    ax.YMinorTick = 'on';
    ax.XTick =(0:1:10);
    savefig(fullfile(saveDir, 'KdecisionDay.fig'))
    print(fullfile(saveDir, 'KdecisionDay'), '-depsc', '-tiff')
    
    clear distortionPercent

    %same for night
    distortion = nan(10,1);
    distortionPercent = cell(size(sleepStructure,2), size(wake_night_clusters,3)); %distortion
    r = cell(size(sleepStructure,2), size(wake_night_clusters,3)); %cumvar cutoff
    KN = NaN (size(sleepStructure,2), size(wake_night_clusters,3)); %K means cut off
    
    %determine number of clusters
     for e=1:size(sleepStructure,2) %for every experiment

        for d= 1:size(wake_night_clusters,3) %every day and night separately and combined

            X = vertcat(wake_night_clusters{e,1,d}(:), wake_night_clusters{e,2,d}(:),...
                wake_night_clusters{e,3,d}(:)); %input wake data
            
            for i=1:10 %try 10 clusters for each experiment - this can be changed

                [~,~, SUMD] = kmeans(X,i, 'emptyaction', 'drop', 'Replicates', 10); %calculate K-means

                distortion (i)= nansum (SUMD); %calculate cost function for each K

             end

            variance=distortion(1:end-1)-distortion(2:end); %subtract the sum of squares for each cluster number

            distortionPercent{e,d}=cumsum(variance)/(distortion(1)-distortion(end)); %calculate as a percentage of total residuals

            r{e,d} = find(distortionPercent{e,d}>0.9); %find point at which over 90% of data is explain by fewest number of clusters 

            KN(e,d)=r{e,d}(1)+1; 
        clear X variance SUMD 
       end
    end
     clear r
     
    K(2)=max(KN(:)); %day time K
    
    %plot a figure to show number of clusters was detemines
    figure;
    h1=shadedErrorBar_2(1:size(distortionPercent{1,3},1), ...
        nanmean(cell2mat(distortionPercent(:,3)'),2), ...
        nanstd(cell2mat(distortionPercent(:,3)')'), {'color', 'k'});
    hold on;
    h2=stem (K(1), 1, 'k*', 'linewidth', 2);
    legend ([h1.patch], strcat('N=', num2str(size(KD,1))))
    ylabel ('Variance Explained');
    xlabel ('Number of clusters');
    box off;
    ylim ([0 1.1])
    title ('Night clusters')
    ax=gca;
    ax.YTick = (0:0.1:1);
    ax.YMinorTick = 'on';
    ax.XTick =(0:1:10);
    savefig(fullfile(saveDir, 'KdecisionNight.fig'))
    print(fullfile(saveDir, 'KdecisionNight'), '-depsc', '-tiff')
    
    
    %% Now actually do the Kmeans clustering using the number of clusters decided
    
    %preallocate arrays
    clusterTemp = cell(size(sleepStructure,2), size(wake_day_clusters,3));
    clusterSort = cell(size(sleepStructure,2), size(wake_day_clusters,3));
    IDX_D = cell(size(sleepStructure,2), size(wake_day_clusters,3));
    C_D= cell(size(sleepStructure,2), size(wake_day_clusters,3));
    SUMD_D = cell(size(sleepStructure,2), size(wake_day_clusters,3));
    ClusterRefsD = cell(size(sleepStructure,2), size(wake_day_clusters,3));
    
    for e=1:size(sleepStructure,2)
    
        for d=1:size(wake_day_clusters,3) %single and grouped data
        
            %vertically concatenate and then sort data
            clusterTemp{e,d} = [];
            clusterSort{e,d} = [];
        
            for g = 1:size(wake_day_clusters,2) %every group
            
                clusterTemp2 = wake_day_clusters{e,g,d}(:);
                clusterTemp{e,d} = [clusterTemp{e,d}; clusterTemp2]; %add on
            
                %make a reference vector
                clusterSort2(1:size(clusterTemp2,1),1) = g;
                clusterSort{e,d} = [clusterSort{e,d}; clusterSort2];
         
                clear clusterTemp2 clusterSort2
            end
         
            %now do k-means clustering
            [IDX_D{e,d}, C_D{e,d},SUMD_D{e,d}] = kmeans (clusterTemp{e,d},K(1)); %sort into four clusters

    
            % sort out the output data by logical indexing
            for g=1:size(names,2) %every group
        
                fish = clusterSort{e,d} ==g; %make an index for the fish
        
                ClusterRefsD{e,g,d} = IDX_D{e,d}(fish); % index out the fish
        
                ClusterRefsD{e,g,d} = reshape(ClusterRefsD{e,g,d},[],...
                size(wake_day_clusters{e,g,d},2)); %reshape by the number of time points
        
                clear fish
            end
        end
    end
    clear clusterTemp clusterSort e g d

    %% and for Night
    %preallocate arrays
    clusterTemp = cell(size(sleepStructure,2), size(wake_night_clusters,3));
    clusterSort = cell(size(sleepStructure,2), size(wake_night_clusters,3));
    IDX_N = cell(size(sleepStructure,2), size(wake_night_clusters,3));
    C_N= cell(size(sleepStructure,2), size(wake_night_clusters,3));
    SUMD_N = cell(size(sleepStructure,2), size(wake_night_clusters,3));
    ClusterRefsN = cell(size(sleepStructure,2), size(wake_night_clusters,3));
    
    for e=1:size(sleepStructure,2)
    
        for d=1:size(wake_night_clusters,3) %single and grouped data
        
            %vertically concatenate and then sort data
            clusterTemp{e,d} = [];
            clusterSort{e,d} = [];
        
            for g = 1:size(wake_night_clusters,2) %every group
            
                clusterTemp2 = wake_night_clusters{e,g,d}(:);
                clusterTemp{e,d} = [clusterTemp{e,d}; clusterTemp2]; %add on
            
                %make a reference vector
                clusterSort2(1:size(clusterTemp2,1),1) = g;
                clusterSort{e,d} = [clusterSort{e,d}; clusterSort2];
         
                clear clusterTemp2 clusterSort2
            end
         
            %now do k-means clustering
            [IDX_N{e,d}, C_N{e,d},SUMD_N{e,d}] = kmeans (clusterTemp{e,d},K(2)); %sort into four clusters

    
            % sort out the output data by logical indexing
            for g=1:size(names,2) %every group
        
                fish = clusterSort{e,d} ==g; %make an index for the fish
        
                ClusterRefsN{e,g,d} = IDX_N{e,d}(fish); % index out the fish
        
                ClusterRefsN{e,g,d} = reshape(ClusterRefsN{e,g,d},[],...
                    size(wake_night_clusters{e,g,d},2)); %reshape by the number of time points
        
                clear fish
            end
        end
    end
    clear clusterTemp clusterSort e g d
    
    %now plot the clustering centroids for day and night to see how similar
        %it is between experiments
        %will sort data and use the sort indices in the next section
    IX_D = cell(size(sleepStructure,2), size(ClusterRefsD, 3));
    O_D = cell(size(sleepStructure,2), size(ClusterRefsD,3));
    
    figure;
    for d=1:size(wake_day_clusters,3)
        for e=1:size(sleepStructure,2)
            subplot (1,3,d)
            %sort data
            [IX_D{e,d}, O_D{e,d}] = sort(C_D{e,d});
            plot (C_D{e,d}(O_D{e,d}));
            hold on
        end
        xlabel('Cluster');
    end
    
    IX_N = cell(size(sleepStructure,2), size(ClusterRefsN,2));
    O_N = cell(size(sleepStructure,2), size(ClusterRefsN,2));
    
    figure
    for d= 1:size(wake_night_clusters,3)
        for e=1:size(sleepStructure,2)
            subplot(1,3,d)
            [IX_N{e,d}, O_N{e,d}] = sort(C_N{e,d});
            plot(C_N{e,d}(O_N{e,d}))
            hold on
        end
        xlabel('Cluster')
    end

    clear e d g
    %% before proceeding is best to make sure all the clusters are assigned in the correct order

%need to reassign the clusters so that 1=low activity and 5 = high
    %activity
        %O contains the cluster number and IX contains the values
            %the order is from low to high activity
 
     %first make new cell array to store these new assignments
     ClusterRefsD2= ClusterRefsD;
     ClusterRefsN2=ClusterRefsN;

    for e=1:size(sleepStructure,2) %every experiment
        for g=1:size(sleepStructure(e).geno.data,2) %every group
            for d=1:size(wake_day_clusters,3) %every day and combined
                for s=1:K(1) %every cluster
                    scrap = ClusterRefsD{e,g,d}==O_D{e,d}(s);
                    ClusterRefsD2{e,g,d}(scrap) = s;

                    scrap2= ClusterRefsN{e,g,d}==O_N{e,d}(s);
                    ClusterRefsN2{e,g,d}(scrap2) = s;

                    clear scrap scrap2     

                end 
            end
        end
    end
    clear e d g s
    
    %replace NaNs with zeros in ClusterRefsN and D so that sleep is in 
    %state space
    for e=1:size(sleepStructure,2)
       for g=1:size(sleepStructure(e).geno.data,2)
           for d=1:size(wake_night_clusters,3)
               %night first - index in sleep
               scrap = isnan(ClusterRefsN2{e,g,d});
               ClusterRefsN2{e,g,d}(scrap) =0;
               clear scrap

                %and do the same for day clusters
                scrap = isnan(ClusterRefsD2{e,g,d});
                ClusterRefsD2{e,g,d}(scrap) =0;
                clear scrap
                
                %add one to all the values in the matrix so that can 
            %include sleep bouts as index 1

                ClusterRefsN2{e,g,d} = ClusterRefsN2{e,g,d}+1;
                ClusterRefsD2{e,g,d} = ClusterRefsD2{e,g,d}+1;

           end
       end
    end
    clear e g d

    %state probability for days
    clear x m n y p 
    fishStatesD = cell (size(sleepStructure,2), size(names,2), size(ClusterRefsD2, 3));
    for e=1:size(sleepStructure,2) %every experiment

        for g=1:size(sleepStructure(e).geno.data,2) %every genotype

            for d=1:size(ClusterRefsD2,3) %every day (and combined)

                for f=1:size(ClusterRefsD2{e,g,d},2) %every fish

                    x= ClusterRefsD2{e,g,d}(:,f); %make a vector of the fish both night only 

                    m = K(1)+1; %5 possible states 

                    n = numel(x); %number of time points

                    y = zeros(m); %make array of zeros the to allocate each state

                    p = zeros(m,m); %matrix for state transitions
                    for t=1:n-1 %every time
                        y(x(t)) = y(x(t)) + 1;
                        p(x(t),x(t+1)) = p(x(t),x(t+1)) + 1;
                    end
                    p = bsxfun(@rdivide,p,y(:,1)); p(isnan(p)) = 0; %divide matrix   

                fishStatesD{e,g,d}(:,:,f) = p;
                clear p x m n y
                end
            end
        end
    end
    clear e d g f t

    %now for state probabilities across entire nights
    clear x  m n y p 
    fishStatesN = cell (size(sleepStructure,2), size(names,2), size(ClusterRefsN2, 3));
    for e=1:size(sleepStructure,2) %every experiment

        for g=1:size(sleepStructure(e).geno.data,2) %every genotype

            for d=1:size(ClusterRefsN2,3) %every day (and combined)

                for f=1:size(ClusterRefsN2{e,g,d},2) %every fish

                    x= ClusterRefsN2{e,g,d}(:,f); %make a vector of the fish night only 

                    m = K(2)+1; %5 possible states

                    n = numel(x); %number of time points

                    y = zeros(m); %make array of zeros to allocate each state

                    p = zeros(m,m); %matrix for state transitions
                    for t=1:n-1 %every time
                        y(x(t)) = y(x(t)) + 1;
                        p(x(t),x(t+1)) = p(x(t),x(t+1)) + 1;
                    end
                    p = bsxfun(@rdivide,p,y(:,1)); p(isnan(p)) = 0; %divide matrix   

                fishStatesN{e,g,d}(:,:,f) = p;
                clear p x m n y
                end
            end
        end
    end

    %so now have matrices for every fish for state transition probability
        %are mutants more likely to transition into a particular state compared to
        %the other states?

    %make a matrix with transition into all states - total   
    stateProbD = cell(size(sleepStructure,2), K(1)+1, size(ClusterRefsD2,3));
    for e=1:size(sleepStructure,2) %every experiment
        
        for s=1:K(1)+1 %number of states

            for d=1:size(ClusterRefsD2,3) %every day/night
                %Preallocate matrix - use hets as biggest group
                stateProbD{e,s,d} = NaN(max(nFish(e,:)),size(nFish,2));
            end

        end

        %now fill in the matrix
        for g=1:size(sleepStructure(e).geno.data,2) %every group

            for f=1:size(fishStatesD{e,g},3) %every fish

                for d=1:size(ClusterRefsD2,3) %every day

                   for s=1:K(1)+1 %every state
                        stateProbD{e,s,d}(f,g) = ...
                            nansum(fishStatesD{e,g,d}(:,s,f))/(K(1)+1);
                   end
                   
                end
                
            end    
        end
    end

    %make a matrix with transition into all states -nights   
    stateProbN = cell(size(sleepStructure,2), K(2)+1, size(ClusterRefsN2,3));
    for e=1:size(sleepStructure,2) %every experiment
        for s=1:K(2)+1 %number of states

            for d=1:size(ClusterRefsN2,3) %every day/night

                stateProbN{e,s,d} = NaN(max(nFish(e,:)),size(nFish,2));
            end
        end

        %now fill in the matrix
        for g=1:size(sleepStructure(e).geno.data,2) %every genotype

            for f=1:size(fishStatesN{e,g},3) %every fish

                for d=1:size(ClusterRefsN2,3) %every day

                    for s = 1:K(2)+1 %all states
                        stateProbN{e,s,d}(f,g) =...
                            nansum(fishStatesN{e,g,d}(:,s,f))/(K(2)+1);
                    end
                    
                end

            end
            
        end
        
    end

    clear e f d s t g d

    %and now concatenate all the state transitions - for boths days and nights;
    stateAllD = cell(K(1)+1, size(ClusterRefsD2,3));
    stateAllN = cell(K(2)+1, size(ClusterRefsN2, 3));
    for s=1:max(K)+1 %every state, including sleep
        for d=1:size(ClusterRefsD2,3) %every day
            stateAllN{s,d} = cell2mat(vertcat(stateProbN(:,s,d)));
            stateAllD{s,d} = cell2mat(vertcat(stateProbD(:,s,d)));
        end
    end
    
    %% stats on the concatenated data
    clear p

    %set grouping variables for experiment and genotype
    
    %genotype
    ns = sum(max(nFish'))*size(nFish,2); %Total number of fish including NaNs
    group =[]; %condition
    for i=1:size(nFish,2) %every condition
        group2 (1:ns/size(nFish,2),1) = i;
        group = [group; group2];
        clear group2
    end
    clear i 

    %set experiment grouping variable
    nsExp = cumsum(max(nFish')); %count up the number of rows for each experiment
    nsExp = [1 nsExp]; %add in one to make concatenating easier
    
    %set final experiment grouping variable
    for e=1:size(nsExp,2)-1
       exp(nsExp(e): nsExp(e+1))=e; 
    end
    exp = repmat (exp, 1, size(nFish,2)); %repeat by number of conditions

    % do n-way ANOVA to test if difference between experiments
    clear pd pn
    pd = cell(size(stateAllD,1),1);
    pn = cell(size(stateAllN,1),1);
    for s=1:max(K(:))+1 %every state, including sleep
        for d=1:size(ClusterRefsD2,3)

            [pd{s}(:,d),~, stats] = anovan(stateAllD{s,d}(:),...
                {exp, group}, 'model', 'interaction', 'display', 'off');
            [pn{s}(:,d),~, stats] = anovan(stateAllN{s,d}(:),...
                {exp, group}, 'model', 'interaction', 'display', 'off');
        end
    end

    %interaction between exp and group is >0.05 for all states except startle
    %during day - as shown by last line which is group * interaction p-value
    %indicating that experiment has little effect on difference in groups.
    %There is however a significant difference between groups for some states

    % save these to excel spreadsheets
    features ={'State1' 'State2' 'State3' 'State4' 'State5'}
    for s = 1:size(pn,2)
        xlswrite(fullfile(saveDir, 'anonvan_night_tranisitions.xls'), pn{s}, features{s});
        xlswrite(fullfile(saveDir, 'anovan_day_transitions.xls'), pd{s}, features{s});
    end

    clear genotype exp
    
    %okay so now know no interaction between experiment and group, do stats on
    %difference between groups
        %test if data is parametric using kstest

    %day
    pd2 = NaN(size(stateAllD,2), size(stateAllD,1));
    pd3 = cell(size(stateAllD,2),size(stateAllD,1));
    for s=1:size(stateAllD,1)
        for d=1:size(stateAllD,2) %every day    
            if kstest(stateAllD{s,d}(:)) == 1
                [pd2(d,s), ~, stats] = kruskalwallis(stateAllD{s,d}, [], 'off');
                pd_test(d,s) = 'k';
                pd3{d,s} = multcompare(stats);
            else
                pd2(d,s) = anovan(stateAllD{s,d},'display', 'off');
                pd_test (d,s) ='a';
                pd3{d,s} = multcompare(stats);
            end
        end
    end

    %night
    pn2 = NaN(size(stateAllN,2), size(stateAllN,1));
    pn3 = cell(size(stateAllN,2),size(stateAllN,1));
    for s=1:size(stateAllN,1)
        for d=1:size(stateAllN,2) %every day    
            if kstest(stateAllN{s,d}(:)) == 1
                [pn2(d,s), ~, stats] = kruskalwallis(stateAllN{s,d}, [], 'off');
                pn_test(d,s) = 'k';
                pn3{d,s} = multcompare(stats);
            else
                pn2(d,s) = anovan(stateAllN{s,d},'display', 'off');
                pn_test (d,s) ='a';
                pn3{d,s} = multcompare(stats);

            end
        end
    end

    %and save these to excel files as well
    clear features
    states = {'state1_alldays' 'state2_alldays' 'state3_alldays' 'state4_alldays' 'state5_alldays'}
    for s =1:size(pn3,2)
       xlswrite(fullfile(saveDir, 'state_transition_KW_day.xls'), pd3{3,s}, states{s});
       xlswrite(fullfile(saveDir, 'state_transition_KW_night.xls'), pn3{3,s}, states{s});

    end

    %% now make the figures
    dist_plot(stateAllD, size(pd2,2), cmap, names, pd2, fullfile(saveDir, 'dayTransitions'))
    dist_plot(stateAllN, size(pn2,2), cmap, names, pn2, fullfile(saveDir, 'nightTransitions'))
    
    %% final part is to look at the timeseries across days and nights
    %to allow statistical comparisons
    
    %take the transition probabilities for each fish - across entire night
    %and days
    %put into matrices to allow statistical comparison
    
    %preallocate arrays
    %transition matrices
    transitionN = cell(size(sleepStructure,2), size(fishStatesN,2), size(fishStatesN,3), K(2)+1);
    transitionD = cell(size(sleepStructure,2), size(fishStatesD,2), size(fishStatesD,3), K(1)+1);
    
    %squeezed transition matrices
    transitionN2 = cell(size(sleepStructure,2), size(fishStatesN,2), size(fishStatesN,3));
    transitionD2 = cell(size(sleepStructure,2), size(fishStatesD,2), size(fishStatesN,3));
    
    %arrays for plotting over time
    transitionPlotD = cell(size(sleepStructure,2), size(fishStatesD,3), (K(1)+1)*(K(1)+1));
    transitionPlotN = cell(size(sleepStructure,2), size(fishStatesN,3), (K(2)+1)*(K(2)+1));
    
    %now loop through to find allocate into these transition matrices
    for e=1:size(sleepStructure,2) %every experiment

        for g=1:size(fishStatesN,2) %every genotype

           for d=1:size(fishStatesN,3) %every night

                  for s=1:size(fishStatesN{e,g},1) %state at t=1

                        for s2=1:size(fishStatesN{e,g},2) % state at t=t+1

                                transitionN{e,g,d,s} (:,s2) = squeeze(fishStatesN{e,g,d}(s,s2, :));
                                transitionD{e,g,d,s}(:,s2) = squeeze(fishStatesD{e,g,d}(s,s2,:));

                        end
                  end

                  transitionN2{e,g,d} = [];
                  transitionD2{e,g,d} = [];
                  for s=1:max(K(:))+1 %every state
                     scrap = transitionN{e,g,d,s};
                     transitionN2 {e,g,d} = [transitionN2{e,g,d} scrap];
                     clear scrap

                     scrap2 = transitionD{e,g,d,s};
                     transitionD2{e,g,d} = [transitionD2{e,g,d} scrap2];
                     clear scrap2
                  end
           end
        end

        %and rearrange data for plotting
        for d=1:size(transitionN,3)
                for s=1:size(transitionN2{e,1,d},2) %every transition

                    transitionPlotN{e,d,s} = NaN (size(transitionN2{e,2,d},1),3);
                    transitionPlotD{e,d,s} = NaN (size(transitionD2{e,2,d},1),3);

                    for g=1:size(transitionN2,2) %every genotype

                        for f=1:size(transitionN2{e,g,1,1},1) %every fish
                            transitionPlotN{e,d,s} (f,g)= transitionN2{e,g,d}(f,s);

                            transitionPlotD{e,d,s} (f,g) = transitionD2{e,g,d}(f,s);

                        end      
                    end
                end
        end  
    end

    %concatentate experiments
    scrap = cell2mat(transitionPlotN);
    temp = cell2mat(transitionPlotD);
    concatTransitionPlotN = cell(size(transitionN,3),1);
    concatTransitionPlotD = cell(size(transitionD,3),1);
    for d = 1:size(concatTransitionPlotN,1)
       concatTransitionPlotN{d} = scrap(:,(4*d)-(d+2):(4*d)-d,:);
       concatTransitionPlotD{d} = temp(:,(4*d) - (d+2):(4*d)-d,:);
    end
    clear scrap temp

    %do stats
    pn4 = NaN(K(2)+1,size(concatTransitionPlotN,1));
    pd4 = NaN(K(1)+1,size(concatTransitionPlotD,1));
    pn5 = cell(K(2)+1,size(concatTransitionPlotN,1));
    pd5 = cell(K(1)+1,size(concatTransitionPlotD,1));
    for d=1:size(concatTransitionPlotD,1) %every day
       for s=1:size(concatTransitionPlotN{d},3) %every state
            [pn4(s,d),~, stats] = kruskalwallis(concatTransitionPlotN{d}(:,:,s),...
                [], 'off');
            pn5 {s,d} = multcompare(stats);
            clear stats
            [pd4(s,d), ~,stats] = kruskalwallis(concatTransitionPlotD{d}(:,:,s),...
                [],'off');
            pd5 {s,d} = multcompare(stats);
            clear stats
       end
    end

    %make matrix with all the transition probabilties in
    allTransN = cell(size(concatTransitionPlotN,1),1);
    allTransD = cell(size(concatTransitionPlotD,1),1);
    for d = 1:size(allTransD,1)
        allTransN{d}=squeeze(nanmedian(concatTransitionPlotN{d}(:,:,:)))';
        allTransD{d}=squeeze(nanmedian(concatTransitionPlotD{d}(:,:,:)))';
    end
    
    %now export these as spreadsheets
    Days = {'Day1' 'Day2' 'Day3'}
    for d = 1:size(allTransD,2)
        xlswrite(fullfile(saveDir, 'DayTransitionsMedian.xls'), allTransD{d}, Days{d});
        xlswrite(fullfile(saveDir, 'NightTransitionsMedian.xls'), allTransN{d}, Days{d});
    end
    
    %final sheet to export is the Pvalues of the transitions
    xlswrite(fullfile(saveDir, 'PvaluesTransitionsDay.xls'), pd4)
    xlswrite(fullfile(saveDir, 'PvaluesTransitionsNight.xls'), pn4)
    
end
