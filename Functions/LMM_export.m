function LMM_export(folder, saveDir, names)
    %this function exports the sleep analysis data to a .csv for Jason to
    %analyse using a linear mixed model
    
    files =dir2(folder);
    
    nConditions = size(names,2);
    
    %load the workspaces
    %now load the .mat files - top file is .DS_store hidden file
    for i = 1:size(files,1)
        sleepStructure(i) = load(fullfile(folder, files(i).name));
        [b, ~] = split(files(i).name, [".", "_"]);
        sleepStructure(i).geno.box = b{2}(end);
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
    
    % need vectors of Column1 = Experiment number/box, Column2= box,
    % Column3 = Genotype, Columns4+ = sleep/activity parameters (raw values)
    %set grouping variables for experiment and genotype
    
    %genotype
    ns = max(nFish,[],2);%*size(nFish,2); %Total number of fish including NaNs
    group =cell(size(ns,1),1); %condition
    for i=1:size(ns,1)
        group{i} = [];
        for g=1:size(nFish,2)%every condition
            ng = ones(ns(i),1)*g;
            group{i} = [group{i};ng]; 
            clear ng
        end
    end
    group = cell2mat(group);
    %use the group variable to actually insert the names
    geno = cell(size(group,1),1);
    for i=1:size(geno)
        geno(i) = names(group(i));
    end

    %set experiment grouping variable
    nsExp = cumsum(ns*size(nFish,2)); %count up the number of rows for each experiment
    nsExp = [0; nsExp]; %add in one to make concatenating easier
    
    %set final experiment grouping variable
    for e=1:size(nsExp,1)-1
       exp(nsExp(e)+1: nsExp(e+1),1)=e;
       box(nsExp(e)+1:nsExp(e+1),1) = str2num(sleepStructure(e).geno.box);
    end
%     exp = repmat (exp, 1, size(nFish,2))'; %repeat by number of conditions
%     box = repmat(box,1, size(nFish,2))';
    
    %load the data
    sleepD = [];
    sleepN = [];
    sleepBoutD =[];
    sleepBoutN=[];
    sleepLengthD=[];
    sleepLengthN = [];
    wactivityD = [];
    wactivityN = [];
    for i=1:size(sleepStructure,2)
        for g =1:size(nFish,2);
            sleepD = [sleepD; nanmean(sleepStructure(i).geno.summarytable.sleep.day{g}(2:3,:),1)'];
            sleepN = [sleepN; nanmean(sleepStructure(i).geno.summarytable.sleep.night{g}(2:3,:),1)']; % average night sleep (total)
            sleepBoutD = [sleepBoutD; nanmean(sleepStructure(i).geno.summarytable.sleepBout.day{g}(2:3,:),1)']; %average day sleep bout
            sleepBoutN = [sleepBoutN; nanmean(sleepStructure(i).geno.summarytable.sleepBout.night{g}(2:3,:),1)']; %average night sleep bout
            sleepLengthD = [sleepLengthD; nanmean(sleepStructure(i).geno.summarytable.sleepLength.day{g}(2:3,:),1)']; %average day sleep bout length
            sleepLengthN = [sleepLengthN; nanmean(sleepStructure(i).geno.summarytable.sleepLength.night{g}(2:3,:),1)']; %average night sleep bout length
            wactivityD = [wactivityD; nanmean(sleepStructure(i).geno.summarytable.averageWaking.day{g}(2:3,:),1)'];%average day wactivity
            wactivityN = [wactivityN; nanmean(sleepStructure(i).geno.summarytable.averageWaking.night{g}(2:3,:),1)']; %average night wactivity

        end
    end

    %create table
    LMMtable = table(exp, box, geno, sleepD, sleepN, sleepBoutD, sleepBoutN,...
        sleepBoutN, sleepLengthD, sleepLengthN, wactivityD, wactivityN);
    
    writetable(LMMtable, fullfile(saveDir, 'LMMtable.csv'));
end
