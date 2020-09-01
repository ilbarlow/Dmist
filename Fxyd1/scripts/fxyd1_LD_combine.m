%LME for fxyd1
% 6 Experiments; 
%Load geno from each and rename geno1-geno6

for i=1:3
genoCOMBO.sleep.day{i}=[nanmean(geno1.summarytable.sleep.day{i}(2:3,:)) nanmean(geno2.summarytable.sleep.day{i}(2:3,:)) nanmean(geno3.summarytable.sleep.day{i}(2:3,:)) nanmean(geno4.summarytable.sleep.day{i}(2:3,:)) nanmean(geno5.summarytable.sleep.day{i}(2:3,:)) nanmean(geno6.summarytable.sleep.day{i}(2:3,:))]; 
genoCOMBO.sleep.night{i}=[nanmean(geno1.summarytable.sleep.night{i}(2:3,:)) nanmean(geno2.summarytable.sleep.night{i}(2:3,:)) nanmean(geno3.summarytable.sleep.night{i}(2:3,:)) nanmean(geno4.summarytable.sleep.night{i}(2:3,:)) nanmean(geno5.summarytable.sleep.night{i}(2:3,:)) nanmean(geno6.summarytable.sleep.night{i}(2:3,:))]; 

genoCOMBO.sleepBout.day{i}=[nanmean(geno1.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno5.summarytable.sleepBout.day{i}(2:3,:)) nanmean(geno6.summarytable.sleepBout.day{i}(2:3,:))]; 
genoCOMBO.sleepBout.night{i}=[nanmean(geno1.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno5.summarytable.sleepBout.night{i}(2:3,:)) nanmean(geno6.summarytable.sleepBout.night{i}(2:3,:))]; 

genoCOMBO.sleepLengthmedian.day{i}=[nanmean(geno1.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno5.summarytable.sleepLengthmedian.day{i}(2:3,:)) nanmean(geno6.summarytable.sleepLengthmedian.day{i}(2:3,:))]; 
genoCOMBO.sleepLengthmedian.night{i}=[nanmean(geno1.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno5.summarytable.sleepLengthmedian.night{i}(2:3,:)) nanmean(geno6.summarytable.sleepLengthmedian.night{i}(2:3,:))]; 

genoCOMBO.sleepLengthmean.day{i}=[nanmean(geno1.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno5.summarytable.sleepLengthmean.day{i}(2:3,:)) nanmean(geno6.summarytable.sleepLengthmean.day{i}(2:3,:))]; 
genoCOMBO.sleepLengthmean.night{i}=[nanmean(geno1.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno2.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno3.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno4.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno5.summarytable.sleepLengthmean.night{i}(2:3,:)) nanmean(geno6.summarytable.sleepLengthmean.night{i}(2:3,:))]; 

genoCOMBO.averageWaking.day{i}=[nanmean(geno1.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno2.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno3.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno4.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno5.summarytable.averageWaking.day{i}(2:3,:)) nanmean(geno6.summarytable.averageWaking.day{i}(2:3,:))]; 
genoCOMBO.averageWaking.night{i}=[nanmean(geno1.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno2.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno3.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno4.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno5.summarytable.averageWaking.night{i}(2:3,:)) nanmean(geno6.summarytable.averageWaking.night{i}(2:3,:))]; 

end

% and reshape the data for analysis:
Genotype2=[zeros(1, length(genoCOMBO.sleep.day{1})) ones(1, length(genoCOMBO.sleep.day{2})) 2*ones(1, length(genoCOMBO.sleep.day{3}))];
Experiment2=[1*ones(1,length(geno1.data{1}(1,:))) 2*ones(1,length(geno2.data{1}(1,:))) 3*ones(1,length(geno3.data{1}(1,:))) 4*ones(1,length(geno4.data{1}(1,:))) 5*ones(1,length(geno5.data{1}(1,:))) 6*ones(1,length(geno6.data{1}(1,:))) 1*ones(1,length(geno1.data{2}(1,:))) 2*ones(1,length(geno2.data{2}(1,:))) 3*ones(1,length(geno3.data{2}(1,:))) 4*ones(1,length(geno4.data{2}(1,:))) 5*ones(1,length(geno5.data{2}(1,:))) 6*ones(1,length(geno6.data{2}(1,:))) 1*ones(1,length(geno1.data{3}(1,:))) 2*ones(1,length(geno2.data{3}(1,:))) 3*ones(1,length(geno3.data{3}(1,:))) 4*ones(1,length(geno4.data{3}(1,:))) 5*ones(1,length(geno5.data{3}(1,:))) 6*ones(1,length(geno6.data{3}(1,:)))];
ANOVAsleepday2=[genoCOMBO.sleep.day{1} genoCOMBO.sleep.day{2} genoCOMBO.sleep.day{3}];
ANOVAsleepnight2=[genoCOMBO.sleep.night{1} genoCOMBO.sleep.night{2} genoCOMBO.sleep.night{3}];

ANOVAsleepBoutday2=[genoCOMBO.sleepBout.day{1} genoCOMBO.sleepBout.day{2} genoCOMBO.sleepBout.day{3}];
ANOVAsleepBoutnight2=[genoCOMBO.sleepBout.night{1} genoCOMBO.sleepBout.night{2} genoCOMBO.sleepBout.night{3}];

ANOVAsleepLengthmeannight2=[genoCOMBO.sleepLengthmean.night{1} genoCOMBO.sleepLengthmean.night{2} genoCOMBO.sleepLengthmean.night{3}];
ANOVAsleepLengthmeanday2=[genoCOMBO.sleepLengthmean.day{1} genoCOMBO.sleepLengthmean.day{2} genoCOMBO.sleepLengthmean.day{3}];

ANOVAsleepLengthmediannight2=[genoCOMBO.sleepLengthmedian.night{1} genoCOMBO.sleepLengthmedian.night{2} genoCOMBO.sleepLengthmedian.night{3}];
ANOVAsleepLengthmedianday2=[genoCOMBO.sleepLengthmedian.day{1} genoCOMBO.sleepLengthmedian.day{2} genoCOMBO.sleepLengthmedian.day{3}];

ANOVAwakenight2=[genoCOMBO.averageWaking.night{1} genoCOMBO.averageWaking.night{2} genoCOMBO.averageWaking.night{3}];
ANOVAwakeday2=[genoCOMBO.averageWaking.day{1} genoCOMBO.averageWaking.day{2} genoCOMBO.averageWaking.day{3}];

tableB=array2table(string([Experiment2' Genotype2']),'VariableNames',{'Experiment','Genotype'})
tableC=array2table([ANOVAsleepday2' ANOVAsleepnight2' ANOVAsleepBoutday2' ANOVAsleepBoutnight2' ANOVAsleepLengthmedianday2' ANOVAsleepLengthmediannight2' ANOVAwakeday2' ANOVAwakenight2'],'VariableNames',{'SleepD','SleepN','SleepBoutD','SleepBoutN','SleepLengthD','SleepLengthN','WakeD','WakeN'})
tableD=[tableB tableC];

lmeSleepD = fitlme(tableD,'SleepD ~ 1 + Genotype + (1|Experiment)')
lmeSleepN = fitlme(tableD,'SleepN ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutD = fitlme(tableD,'SleepBoutD ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutN = fitlme(tableD,'SleepBoutN ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthD = fitlme(tableD,'SleepLengthD ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthN = fitlme(tableD,'SleepLengthN ~ 1 + Genotype + (1|Experiment)')
lmeWakeD = fitlme(tableD,'WakeD ~ 1 + Genotype + (1|Experiment)')
lmeWakeN = fitlme(tableD,'WakeN ~ 1 + Genotype + (1|Experiment)')

%Now I construct the same table as Ida's summary table, using the effects
%and SEMs:

[fixed{1},B,SE{1}]=fixedEffects(lmeSleepD);
[fixed{2},B,SE{2}]=fixedEffects(lmeSleepN);
[fixed{3},B,SE{3}]=fixedEffects(lmeSleepBoutD);
[fixed{4},B,SE{4}]=fixedEffects(lmeSleepBoutN);
[fixed{5},B,SE{5}]=fixedEffects(lmeSleepLengthD);
[fixed{6},B,SE{6}]=fixedEffects(lmeSleepLengthN);
[fixed{7},B,SE{7}]=fixedEffects(lmeWakeD);
[fixed{8},B,SE{8}]=fixedEffects(lmeWakeN);

for i=1:8
finalScaled_allmean(:,i)=fixed{i}./fixed{i}(1)*100;
finalScaled_allsem(:,i)=SE{i}.SE./fixed{i}(1)*100;
end
finalScaled_allmean(1,:)=0;
names=[1,1,1;1,1,1;1,1,1];
cmap = [0 0 0; 0 0 1; 1 0 0];
legendname=['+/+','+/-','-/-'];
%now plot as errorbar
        %make legend first
    %make cell array for legend
   % Adjusted:
   for i=1:3
   nFish(i)=length(find(Genotype2==i-1))
   end
   
   for i=1:3
   Leg{i}=strcat('dmist  ', legendname(i),'  n=',num2str(nFish(i)))
   end
    
    
    figure;
    for i=1.5:2:8.5
        rectangle ('Position', [i -60 1 120], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
        hold on;
        rectangle ('Position', [i+1 -60 1 120], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
    end
    for g=1:size(names,2) %every genotype
        errorbar(finalScaled_allmean(g,:), finalScaled_allsem(g,:), 'o', 'Color', ...
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
    ax.YTick = [-50:10:50];
    ylabel ('% Change relative to WT', 'FontSize', 16);
