% This is first to combine all of Ida's data without normalizing

% First Load the 3 experiments' geno files, renaming them geno1, geno2, and geno3. 


%Do not Flip mutant and Wildtype for this vir data:
for i=1:3
genoCOMBO.sleep.day{i}=[(nanmean(geno1.summarytable.sleep.day{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleep.day{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleep.day{1}(2:3,:))) (nanmean(geno2.summarytable.sleep.day{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleep.day{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleep.day{1}(2:3,:))) (nanmean(geno3.summarytable.sleep.day{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleep.day{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleep.day{1}(2:3,:))) ]; 
genoCOMBO.sleep.night{i}=[(nanmean(geno1.summarytable.sleep.night{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleep.night{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleep.night{1}(2:3,:))) (nanmean(geno2.summarytable.sleep.night{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleep.night{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleep.night{1}(2:3,:))) (nanmean(geno3.summarytable.sleep.night{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleep.night{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleep.night{1}(2:3,:))) ]; 
    
genoCOMBO.sleepBout.day{i}=[(nanmean(geno1.summarytable.sleepBout.day{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepBout.day{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepBout.day{1}(2:3,:))) (nanmean(geno2.summarytable.sleepBout.day{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepBout.day{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepBout.day{1}(2:3,:))) (nanmean(geno3.summarytable.sleepBout.day{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepBout.day{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepBout.day{1}(2:3,:))) ]; 
genoCOMBO.sleepBout.night{i}=[(nanmean(geno1.summarytable.sleepBout.night{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepBout.night{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepBout.night{1}(2:3,:))) (nanmean(geno2.summarytable.sleepBout.night{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepBout.night{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepBout.night{1}(2:3,:))) (nanmean(geno3.summarytable.sleepBout.night{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepBout.night{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepBout.night{1}(2:3,:))) ]; 
     
genoCOMBO.sleepLengthmean.day{i}=[(nanmean(geno1.summarytable.sleepLengthmean.day{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepLengthmean.day{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepLengthmean.day{1}(2:3,:))) (nanmean(geno2.summarytable.sleepLengthmean.day{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepLengthmean.day{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepLengthmean.day{1}(2:3,:))) (nanmean(geno3.summarytable.sleepLengthmean.day{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepLengthmean.day{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepLengthmean.day{1}(2:3,:))) ]; 
genoCOMBO.sleepLengthmean.night{i}=[(nanmean(geno1.summarytable.sleepLengthmean.night{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepLengthmean.night{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepLengthmean.night{1}(2:3,:))) (nanmean(geno2.summarytable.sleepLengthmean.night{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepLengthmean.night{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepLengthmean.night{1}(2:3,:))) (nanmean(geno3.summarytable.sleepLengthmean.night{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepLengthmean.night{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepLengthmean.night{1}(2:3,:))) ]; 

genoCOMBO.sleepLengthmedian.day{i}=[(nanmean(geno1.summarytable.sleepLengthmedian.day{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepLengthmedian.day{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepLengthmedian.day{1}(2:3,:))) (nanmean(geno2.summarytable.sleepLengthmedian.day{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepLengthmedian.day{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepLengthmedian.day{1}(2:3,:))) (nanmean(geno3.summarytable.sleepLengthmedian.day{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepLengthmedian.day{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepLengthmedian.day{1}(2:3,:))) ]; 
genoCOMBO.sleepLengthmedian.night{i}=[(nanmean(geno1.summarytable.sleepLengthmedian.night{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.sleepLengthmedian.night{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.sleepLengthmedian.night{1}(2:3,:))) (nanmean(geno2.summarytable.sleepLengthmedian.night{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.sleepLengthmedian.night{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.sleepLengthmedian.night{1}(2:3,:))) (nanmean(geno3.summarytable.sleepLengthmedian.night{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.sleepLengthmedian.night{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.sleepLengthmedian.night{1}(2:3,:))) ]; 

genoCOMBO.averageWaking.day{i}=[(nanmean(geno1.summarytable.averageWaking.day{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.averageWaking.day{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.averageWaking.day{1}(2:3,:))) (nanmean(geno2.summarytable.averageWaking.day{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.averageWaking.day{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.averageWaking.day{1}(2:3,:))) (nanmean(geno3.summarytable.averageWaking.day{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.averageWaking.day{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.averageWaking.day{1}(2:3,:))) ]; 
genoCOMBO.averageWaking.night{i}=[(nanmean(geno1.summarytable.averageWaking.night{i}(2:3,:))-nanmean(nanmean(geno1.summarytable.averageWaking.night{1}(2:3,:))))./nanmean(nanmean(geno1.summarytable.averageWaking.night{1}(2:3,:))) (nanmean(geno2.summarytable.averageWaking.night{i}(2:3,:))-nanmean(nanmean(geno2.summarytable.averageWaking.night{1}(2:3,:))))./nanmean(nanmean(geno2.summarytable.averageWaking.night{1}(2:3,:))) (nanmean(geno3.summarytable.averageWaking.night{i}(2:3,:))-nanmean(nanmean(geno3.summarytable.averageWaking.night{1}(2:3,:))))./nanmean(nanmean(geno3.summarytable.averageWaking.night{1}(2:3,:))) ]; 
 
end

% and reshape the data for analysis:
Genotype2=[zeros(1, length(genoCOMBO.sleep.day{1})) ones(1, length(genoCOMBO.sleep.day{2})) 2*ones(1, length(genoCOMBO.sleep.day{3}))];
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

% And check each one:
[h,p,stats_sleepday]=anovan(ANOVAsleepday,{Genotype})
[h,p,stats_sleepnight]=anovan(ANOVAsleepnight,{Genotype})
[h,p,stats_sleepBoutday]=anovan(ANOVAsleepBoutday,{Genotype})
[h,p,stats_sleepBoutnight]=anovan(ANOVAsleepBoutnight,{Genotype})
[h,p,stats_sleepLengthmedianday]=anovan(ANOVAsleepLengthmedianday,{Genotype})
[h,p,stats_sleepLengthmediannight]=anovan(ANOVAsleepLengthmediannight,{Genotype})
[h,p,stats_sleepLengthmeanday]=anovan(ANOVAsleepLengthmeanday,{Genotype})
[h,p,stats_sleepLengthmeannight]=anovan(ANOVAsleepLengthmeannight,{Genotype})
[h,p,stats_wakeday]=anovan(ANOVAwakeday,{Genotype})
[h,p,stats_wakenight]=anovan(ANOVAwakenight,{Genotype})

% and store the p-value comparisons:
mult_sleepday=multcompare(stats_sleepday)
mult_sleepnight=multcompare(stats_sleepnight)
mult_sleepBoutday=multcompare(stats_sleepBoutday)
mult_sleepBoutnight=multcompare(stats_sleepBoutnight)
mult_sleepLengthmedianday=multcompare(stats_sleepLengthmedianday)
mult_sleepLengthmediannight=multcompare(stats_sleepLengthmediannight)
mult_sleepLengthmeanday=multcompare(stats_sleepLengthmeanday)
mult_sleepLengthmeannight=multcompare(stats_sleepLengthmeannight)
mult_wakeday=multcompare(stats_wakeday)
mult_wakepnight=multcompare(stats_wakenight)

% and make the summary graphs for this as well.
colors=[0 0 0; 0 0 1; 1 0 0];
legendname(1) = string('+/+');
legendname(2) = string('vir/+');
legendname(3) = string('vir/vir');


figure;plotSpread(ANOVAsleepday./(14*60)*60,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepday','FontSize',10) 
    ylabel('Ave Sleep (min/hr)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end
    
 figure;plotSpread(ANOVAsleepnight./600*60,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepnight','FontSize',10) 
    ylabel('Ave Sleep (min/hr)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end
     
   figure;plotSpread(ANOVAsleepBoutday./(14*60)*60,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepBoutday','FontSize',10) 
    ylabel('Ave SleepBout (#/hr)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end
    
 figure;plotSpread(ANOVAsleepBoutnight./600*60,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepBoutnight','FontSize',10) 
    ylabel('Ave SleepBout (#/hr)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end 
    
    
       figure;plotSpread(ANOVAsleepLengthmedianday,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepLegnthmedianday','FontSize',10) 
    ylabel('Median Sleep Length (min)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end
    
 figure;plotSpread(ANOVAsleepLengthmediannight,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r sleepLengthmediannight','FontSize',10) 
    ylabel('Median Sleep Length (min)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end 

     figure;plotSpread(ANOVAwakeday,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r Waking Activity day','FontSize',10) 
    ylabel('mean Waking Activity (s/min)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end
    
 figure;plotSpread(ANOVAwakenight,'categoryIdx',Genotype,'showMM',4,'distributionIdx',Genotype,'categoryColors',colors)
    ax = gca;
    ax.XTickLabel=legendname
    title('Ida_v_i_r Waking Activity Night','FontSize',10) 
    ylabel('mean Waking Activity (s/min)','FontSize',14)
    A=axis;
    ylim([0,A(4)]);
    fg = gcf;
    for j=1:2+length(geno1.data)
        fg.Children.Children(j).MarkerSize=12;
        fg.Children.Children(j).LineWidth=1;
        
    end 



