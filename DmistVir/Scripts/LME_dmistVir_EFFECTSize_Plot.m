%Now that I've bulid the LMMs, I want to show the effect size plots with p
%values. % I start by loading the all viral data:

load('Jason_Ida_dmistCOMBINED.mat')

% Transform the data for normality (note: it is the output of the LME model
% that should be checked for normality. I will plotResiduals at the end).

ANOVAsleepday4=log(1+ANOVAsleepday3)
ANOVAsleepnight4=log(1+ANOVAsleepnight3);
ANOVAsleepBoutday4=ANOVAsleepBoutday3;
ANOVAsleepBoutnight4=ANOVAsleepBoutnight3;
ANOVAsleepLengthmedianday4=log(1+ANOVAsleepLengthmedianday3)
ANOVAsleepLengthmediannight4=log(1+ANOVAsleepLengthmediannight3);
ANOVAwakeday4=log(1+ANOVAwakeday3)
ANOVAwakenight4=log(1+ANOVAwakenight3);

tableB2=array2table([string(Experiment3)' string(Genotype3)'],'VariableNames',{'Experiment','Genotype'})
tableC2=array2table([ANOVAsleepday4' ANOVAsleepnight4' ANOVAsleepBoutday4' ANOVAsleepBoutnight4' ANOVAsleepLengthmedianday4' ANOVAsleepLengthmediannight4' ANOVAwakeday4' ANOVAwakenight4'],'VariableNames',{'SleepD','SleepN','SleepBoutD','SleepBoutN','SleepLengthD','SleepLengthN','WakeD','WakeN'})
tableD2=[tableB2 tableC2]

lmeSleepD2 = fitlme(tableD2,'SleepD ~ 1 + Genotype + (1|Experiment)')
lmeSleepN2 = fitlme(tableD2,'SleepN ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutD2 = fitlme(tableD2,'SleepBoutD ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutN2 = fitlme(tableD2,'SleepBoutN ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthD2 = fitlme(tableD2,'SleepLengthD ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthN2 = fitlme(tableD2,'SleepLengthN ~ 1 + Genotype + (1|Experiment)')
lmeWakeD2 = fitlme(tableD2,'WakeD ~ 1 + Genotype + (1|Experiment)')
lmeWakeN2 = fitlme(tableD2,'WakeN ~ 1 + Genotype + (1|Experiment)')


% This does improve the lme modelling a little bit, esp. for the
% SleepLength data but looks similar in scale for the Sleep and Wake
% effects. 


%Pull out the fixed effects tabledata:
[fixed{1},B,SE{1}]=fixedEffects(lmeSleepD2);
[fixed{2},B,SE{2}]=fixedEffects(lmeSleepN2);
[fixed{3},B,SE{3}]=fixedEffects(lmeSleepBoutD2);
[fixed{4},B,SE{4}]=fixedEffects(lmeSleepBoutN2);
[fixed{5},B,SE{5}]=fixedEffects(lmeSleepLengthD2);
[fixed{6},B,SE{6}]=fixedEffects(lmeSleepLengthN2);
[fixed{7},B,SE{7}]=fixedEffects(lmeWakeD2);
[fixed{8},B,SE{8}]=fixedEffects(lmeWakeN2);

% for the exponentials, to plot into the graph, I just need to calculate:
%exp(SE{x}.Estimate2)-1 with error bars from .Upper and .Lower in same 
%for linear ones, I divide Estimate3 from Estimate1, with .Upper/Estimate1
%and .Lower/Estimate1 as the CI

for j=2:3
effectSize_m(j-1,1)=exp(fixed{1}(j))-1;
effectSize_m(j-1,2)=exp(fixed{2}(j))-1;
effectSize_m(j-1,3)=fixed{3}(j)./fixed{3}(1);
effectSize_m(j-1,4)=fixed{4}(j)./fixed{4}(1);
effectSize_m(j-1,5)=exp(fixed{5}(j))-1;
effectSize_m(j-1,6)=exp(fixed{6}(j))-1;
effectSize_m(j-1,7)=exp(fixed{7}(j))-1;
effectSize_m(j-1,8)=exp(fixed{8}(j))-1;

effectSize_u(j-1,1)=exp(SE{1}.Upper(j))-1;
effectSize_u(j-1,2)=exp(SE{2}.Upper(j))-1;
effectSize_u(j-1,3)=SE{3}.Upper(j)./fixed{3}(1)
effectSize_u(j-1,4)=SE{4}.Upper(j)./fixed{4}(1)
effectSize_u(j-1,5)=exp(SE{5}.Upper(j))-1;
effectSize_u(j-1,6)=exp(SE{6}.Upper(j))-1;
effectSize_u(j-1,7)=exp(SE{7}.Upper(j))-1;
effectSize_u(j-1,8)=exp(SE{8}.Upper(j))-1;

effectSize_l(j-1,1)=exp(SE{1}.Lower(j))-1;
effectSize_l(j-1,2)=exp(SE{2}.Lower(j))-1;
effectSize_l(j-1,3)=SE{3}.Lower(j)./fixed{3}(1)
effectSize_l(j-1,4)=SE{4}.Lower(j)./fixed{4}(1)
effectSize_l(j-1,5)=exp(SE{5}.Lower(j))-1;
effectSize_l(j-1,6)=exp(SE{6}.Lower(j))-1;
effectSize_l(j-1,7)=exp(SE{7}.Lower(j))-1;
effectSize_l(j-1,8)=exp(SE{8}.Lower(j))-1;

effectSize_p(j-1,1)=SE{1}.pValue(j);
effectSize_p(j-1,2)=SE{2}.pValue(j);
effectSize_p(j-1,3)=SE{3}.pValue(j);
effectSize_p(j-1,4)=SE{4}.pValue(j);
effectSize_p(j-1,5)=SE{5}.pValue(j);
effectSize_p(j-1,6)=SE{6}.pValue(j);
effectSize_p(j-1,7)=SE{7}.pValue(j);
effectSize_p(j-1,8)=SE{8}.pValue(j);

end

finalScaled_allmean(1,:)=0;
names=[1,1,1;1,1,1;1,1,1];
cmap = [0 0 1; 1 0 0];
legendname=string(['+/-';'-/-']);

for i=1:2
   nFish(i)=length(find(Genotype3==i))
end
   clear Leg
   for i=1:2
   Leg{i}=strcat('dmist  ', legendname(i),'  n=',num2str(nFish(i)))
   end
    
    
    figure;
    for i=1.5:2:8.5
        rectangle ('Position', [i -80 1 120], 'Facecolor', [0.95 0.95 0.95], 'Edgecolor', [1 1 1]);
        hold on;
        rectangle ('Position', [i+1 -80 1 120], 'Facecolor', [1 1 1], 'Edgecolor', [1 1 1]);
    end
    
    for g=1:(size(names,2)-1) %every genotype
         errorbar([0.7+(.2*g) 1.7+(.2*g) 2.7+(.2*g) 3.7+(.2*g) 4.7+(.2*g) 5.7+(.2*g) 6.7+(0.2*g) 7.7+(0.2*g)],effectSize_m(g,:)*100, (effectSize_l(g,:)*100)-(effectSize_m(g,:)*100),(effectSize_u(g,:)*100)-(effectSize_m(g,:)*100), 'o', 'Color', ...
         cmap(g,:), 'Markerfacecolor', cmap(g,:), 'Linewidth', 2);
        hold on
    end
    box off;
    xlim ([0.5 8.5]);
    line([0.5,8.5],[0,0],'Linewidth',1,'Color','black','Linestyle','--')
   % ylim([-50 40]);
    ax=gca;
    ax.XTick = [1.5:2:7.5];
    ax.XTickLabel = {'Sleep' 'Sleep Bouts' 'Sleep bout length' 'Waking Activity'};
    ax.XTickLabelRotation = 45;
    ax.FontSize = 16;
    ax.YTick = [-60:10:40];
    ylabel ('% Effect Sizes relative to WT', 'FontSize', 16);
    legend (Leg, 'FontSize', 18);
    %plot stats on top
  % for i=1:size(mult,1)
  %    text(i-0.25, -20, strcat('P=', num2str(mult{i}(2,6))), 'Fontsize', 14) 
  %  end
  %  print(fullfile(saveDir, 'Summary'), '-depsc', '-tiff')
   % savefig(fullfile(saveDir, 'Summary.fig'));
   % close;

%Grab Pvalues (can be seen above)

% I flip the data so mutant is the baseline to get all the stats for mutant
% vs. het and WT:

tableB2=array2table([flip(Experiment4)' flip(Genotype4)'],'VariableNames',{'Experiment','Genotype'})
tableC2=array2table([flip(ANOVAsleepday4)' flip(ANOVAsleepnight4)' flip(ANOVAsleepBoutday4)' flip(ANOVAsleepBoutnight4)' flip(ANOVAsleepLengthmedianday4)' flip(ANOVAsleepLengthmediannight4)' flip(ANOVAwakeday4)' flip(ANOVAwakenight4)'],'VariableNames',{'SleepD','SleepN','SleepBoutD','SleepBoutN','SleepLengthD','SleepLengthN','WakeD','WakeN'})
tableD2=[tableB2 tableC2]

lmeSleepD2 = fitlme(tableD2,'SleepD ~ 1 + Genotype + (1|Experiment)')
lmeSleepN2 = fitlme(tableD2,'SleepN ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutD2 = fitlme(tableD2,'SleepBoutD ~ 1 + Genotype + (1|Experiment)')
lmeSleepBoutN2 = fitlme(tableD2,'SleepBoutN ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthD2 = fitlme(tableD2,'SleepLengthD ~ 1 + Genotype + (1|Experiment)')
lmeSleepLengthN2 = fitlme(tableD2,'SleepLengthN ~ 1 + Genotype + (1|Experiment)')
lmeWakeD2 = fitlme(tableD2,'WakeD ~ 1 + Genotype + (1|Experiment)')
lmeWakeN2 = fitlme(tableD2,'WakeN ~ 1 + Genotype + (1|Experiment)')




