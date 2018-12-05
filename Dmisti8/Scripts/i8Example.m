%Figure 3 - example sleep wake traces for dmist i8 - use experiment 160701_24

fname = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LD\RawData\160701_24.mat'
[filepath,name,ext] = fileparts(fname)
load(fname)

%first just plot waking activity trace
%find lightboundries for shading
LB = find(geno.lightboundries)/10;
nFish = NaN(1,size(geno.data,2));
for i=1:size(geno.data,2)
   nFish(i) = size(geno.data{i},2); 
end

%set colormap
cmap = [1 0 1; 0 1 0 ; 0 0 0]; %black = wt, green = het, hom = mag
sem = @(x) (nanstd(x')./ sqrt(size(x,2))); %inline function for standard error of mean

%now plot shaded boxes for traces
figure;
for i =1:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 15], 'Edgecolor', [1 1 1]);
    hold on
end
hold on
for i = 2:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 15], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
    hold on
end

%now add traces
for i= 1:size(geno.data,2)
   shadedErrorBar_2(1:size(geno.tenminutetime,2), smooth(nanmean(geno.avewakechart{i}(:,:)'),3),...
       smooth(sem(geno.avewakechart{i}(:,:)),3),{'Color', [cmap(i,:)]}, 'transparent');
   key {i,1} = char(strcat(geno.name{i}, ',n=',...
       num2str(size(geno.data{i},2)))); %character array defines labels for legend - only need to do this once
   hold on
end    
ax = gca; %define axes ticks and labels
ylim ([0 15]);
xlim ([LB(3) LB(end)])
ax.XTick = LB(:);
ax.XTickLabel = {'' '23' '0' '14' '0' '14' '0'};
set(gca, 'Fontsize', 16);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
ylabel ('Waking Activity (sec/min/10min)', 'Fontsize', 18)
%title('Waking Activity', 'Fontsize', 20)
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minWactivity.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minWactivity')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivity1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivity2')),'tiff')
legend ('off')

gcf;
xlim ([LB(4), LB(5)]);
ylim ([0 2]);
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minWactivityZoomNight1.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minWactivityZoomNight1')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivityZoomNight1_1')),'tiff')
legend (key, 'Fontsize', 18)
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minWactivityZoomNight1_2')),'tiff')

%sleep traces
figure;
for i =1:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 10], 'Edgecolor', [1 1 1]);
    hold on
end
hold on
for i = 2:2:size(LB,1)-1
    rectangle ('Position', [LB(i) 0 (LB(i+1) - LB(i)) 10], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [1 1 1]); %plot dark boxes for night
    hold on
end

%now add traces
   for i= 1:size(geno.data,2)
       shadedErrorBar_2(1:size(geno.tenminutetime,2), smooth(nanmean(geno.sleepchart{i}(:,:)'),3), smooth(sem(geno.sleepchart{i}(:,:)),3),...
           {'Color', [cmap(i,:)]}, 'transparent');
       key {i,1} = char(strcat(geno.name{i}, ',n=',...
           num2str(size(geno.data{i},2)))); %character array defines labels for legend - only need to do this once
       hold on
   end    
ax = gca; %define axes ticks and labels
ylim ([0 10]);
xlim ([LB(3) LB(end)])
ax.XTick = LB(:);
ax.XTickLabel = {'' '14' '0' '14' '0' '14' '0'};
set(gca, 'Fontsize', 16);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 18);
ylabel ('Sleep (min/10 mins)', 'Fontsize', 18)
% title('Sleepchart', 'Fontsize', 20)
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minSleep.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minSleep')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleep1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleep2')),'tiff')

legend('off')
gcf;
xlim ([LB(4), LB(5)]);
ylim ([0 6]);
savefig(gcf, fullfile(fileparts (filepath),'Figures', strcat(name,...
   '_10minSleepZoomNight1.fig')));
print(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name, ...
   '_10minSleepZoomNight1')), '-depsc')
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleepZoomNight1_1')),'tiff')
legend (key, 'Fontsize', 18) %adds legend
saveas(gcf, fullfile(fileparts(filepath), 'Figures', strcat(name,...
   '_10minSleepZoomNight1_2')),'tiff')


%% repeated measures ANOVA

%make cell array of the genotypes
genolist= {};
for i=1:3
    genotype = cell(nFish(i),1);
    for j=1:nFish(i)
       genotype(1:j) = geno.name{i}; 
    end
    genolist = vertcat(genolist, genotype)
    clear genotype
end

%vcat the avewakechart measures
measures = [];
for i=1:size(geno.avewakechart,2)
    measures = [measures; geno.avewakechart{i}(LB(4):LB(5),:)' geno.avewakechart{i}(LB(6):LB(7),:)'];
end
measureNames = cell(size(measures,2),1);
for i=1:size(measures,2)
   measureNames{i} = strcat('t_', num2str(i)); 
end

genocell = {'genotype'};

varNames = vertcat(genocell, measureNames);

%make a table
t = array2table(measures);
t.genotype = genolist;

Meas = table([1:size(measureNames,1)]', 'VariableNames', {'Measurements'})

rm = fitrm(t, 'measures1-measures122~genotype', 'WithinDesign', Meas);

ranovatbl = ranova(rm)