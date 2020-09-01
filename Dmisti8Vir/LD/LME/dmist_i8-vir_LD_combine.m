%dmist i8/vir LME testing
% There are 4 groups for this one, so must modify:
% The order is WT-Crispr-Vir-Transhet
% Load the data and rename geno1-4
%Do not Flip mutant and Wildtype for this vir data:
for i=1:4
genoCOMBO.sleep.day{i}=[nanmean(geno1.summarytable.sleep.day{i}(2:3,:)) nanmean(geno2.summarytable.sleep.day{i}(2:3,:)) nanmean(geno3.summarytable.sleep.day{i}(2:3,:)) nanmean(geno4.summarytable.sleep.day{i}(2:3,:))]; 
genoCOMBO.sleep.night{i}=[nanmean(geno1.summarytable.sleep.night{i}(2:3,:)) nanmean(geno2.summarytable.sleep.night{i}(2:3,:)) nanmean(geno3.summarytable.sleep.night{i}(2:3,:)) nanmean(geno4.summarytable.sleep.night{i}(2:3,:))]; 

genoCOMBO.sleepBout.day{i}=[nanmean(geno1.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepBout.day{i}(2:3,:))]; 
genoCOMBO.sleepBout.night{i}=[nanmean(geno1.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepBout.night{i}(2:3,:))]; 

genoCOMBO.sleepLengthmedian.day{i}=[nanmean(geno1.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmedian.day{i}(2:3,:))]; 
genoCOMBO.sleepLengthmedian.night{i}=[nanmean(geno1.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmedian.night{i}(2:3,:))]; 

genoCOMBO.sleepLengthmean.day{i}=[nanmean(geno1.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmean.day{i}(2:3,:))]; 
genoCOMBO.sleepLengthmean.night{i}=[nanmean(geno1.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmean.night{i}(2:3,:))]; 

genoCOMBO.averageWaking.day{i}=[nanmean(geno1.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno2.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno3.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno4.summarytable.averageWaking.day{i}(2:3,:))]; 
genoCOMBO.averageWaking.night{i}=[nanmean(geno1.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno2.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno3.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno4.summarytable.averageWaking.night{i}(2:3,:))]; 

end

% and reshape the data for analysis:
Genotype2=[zeros(1, length(genoCOMBO.sleep.day{1})) ones(1, length(genoCOMBO.sleep.day{2})) 2*ones(1, length(genoCOMBO.sleep.day{3})) 3*ones(1, length(genoCOMBO.sleep.day{4})) ];
Experiment2=[1*ones(1,length(geno1.data{1}(1,:))) 2*ones(1,length(geno2.data{1}(1,:))) 3*ones(1,length(geno3.data{1}(1,:))) 4*ones(1,length(geno4.data{1}(1,:))) 1*ones(1,length(geno1.data{2}(1,:))) 2*ones(1,length(geno2.data{2}(1,:))) 3*ones(1,length(geno3.data{2}(1,:))) 4*ones(1,length(geno4.data{2}(1,:))) 1*ones(1,length(geno1.data{3}(1,:))) 2*ones(1,length(geno2.data{3}(1,:))) 3*ones(1,length(geno3.data{3}(1,:))) 4*ones(1,length(geno4.data{3}(1,:))) 1*ones(1,length(geno1.data{4}(1,:))) 2*ones(1,length(geno2.data{4}(1,:))) 3*ones(1,length(geno3.data{4}(1,:))) 4*ones(1,length(geno4.data{4}(1,:)))];
ANOVAsleepday2=[genoCOMBO.sleep.day{1} genoCOMBO.sleep.day{2} genoCOMBO.sleep.day{3} genoCOMBO.sleep.day{4}];
ANOVAsleepnight2=[genoCOMBO.sleep.night{1} genoCOMBO.sleep.night{2} genoCOMBO.sleep.night{3} genoCOMBO.sleep.night{4}];

ANOVAsleepBoutday2=[genoCOMBO.sleepBout.day{1} genoCOMBO.sleepBout.day{2} genoCOMBO.sleepBout.day{3} genoCOMBO.sleepBout.day{4}];
ANOVAsleepBoutnight2=[genoCOMBO.sleepBout.night{1} genoCOMBO.sleepBout.night{2} genoCOMBO.sleepBout.night{3} genoCOMBO.sleepBout.night{4}];

ANOVAsleepLengthmeannight2=[genoCOMBO.sleepLengthmean.night{1} genoCOMBO.sleepLengthmean.night{2} genoCOMBO.sleepLengthmean.night{3} genoCOMBO.sleepLengthmean.night{4}];
ANOVAsleepLengthmeanday2=[genoCOMBO.sleepLengthmean.day{1} genoCOMBO.sleepLengthmean.day{2} genoCOMBO.sleepLengthmean.day{3} genoCOMBO.sleepLengthmean.day{4}];

ANOVAsleepLengthmediannight2=[genoCOMBO.sleepLengthmedian.night{1} genoCOMBO.sleepLengthmedian.night{2} genoCOMBO.sleepLengthmedian.night{3} genoCOMBO.sleepLengthmedian.night{4}];
ANOVAsleepLengthmedianday2=[genoCOMBO.sleepLengthmedian.day{1} genoCOMBO.sleepLengthmedian.day{2} genoCOMBO.sleepLengthmedian.day{3} genoCOMBO.sleepLengthmedian.day{4}];

ANOVAwakenight2=[genoCOMBO.averageWaking.night{1} genoCOMBO.averageWaking.night{2} genoCOMBO.averageWaking.night{3} genoCOMBO.averageWaking.night{4}];
ANOVAwakeday2=[genoCOMBO.averageWaking.day{1} genoCOMBO.averageWaking.day{2} genoCOMBO.averageWaking.day{3} genoCOMBO.averageWaking.day{4}];

