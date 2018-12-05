%% open qpcr excel sheet

uiopen('C:\Users\ilbar\Documents\MATLAB\qPCR_data\Matlab\210617\dmist_vir_qPCR.xlsx',1)

%% sort data - 1st cell housekeeping, 2nd cell dmist 3rd cell slc6a4b
data {1} (1:3,1) = dmistvirqPCR(1:3); %-/-
data {1}(1:3,2) = dmistvirqPCR(4:6); % +/+
data {1} (1:3,3) = dmistvirqPCR(7:9); %+/+
data {2}(1:3,1) = dmistvirqPCR(10:12);
data {2} (1:3,2) = dmistvirqPCR (13:15);
data {2} (1:3,3) = dmistvirqPCR (16:18);
data{3}(1:3,1) = dmistvirqPCR (19:21);
data{3}(1:3,2) = dmistvirqPCR(22:24);
data{3} (1:3,3) = dmistvirqPCR(25:27);

%% normalise to housekeeping gene
dmist_norm = data{1} - data{2};
slc6a4b_norm = data{1} - data{3};

%calculate relative cDNA value
for i =1:3 %each
    cDNA_dmist (:,i) = power(2,dmist_norm(:,i));
    cDNA_slc6a4b (:,i) = power(2, slc6a4b_norm(:,i));
end

%calculate mean
mean_dmist = nanmean(cDNA_dmist);
mean_slc6a4b = nanmean(cDNA_slc6a4b);

%calculate std
std_dmist = nanstd(cDNA_dmist);
std_slc6a4b = nanstd(cDNA_slc6a4b);

%make table for plotting bar chart
for i =1:3
mean_express (1,i) = mean_dmist(1,i)/mean_dmist(1,3); %dmist
mean_express (3,i) = mean_slc6a4b(1,i)/ mean_slc6a4b(1,3); %slc6a4b
std_express (1,i) =std_dmist (1,i)/ mean_dmist(1,3);
std_express (3,i) = std_slc6a4b(1,i)/ mean_slc6a4b(1,3);
end

%dmist
figure;
errorbar(1:3, flip(mean_express(1,:)), flip(std_express(1,:)), '.k', 'Linewidth', 2);
hold on;
bar(flip(mean_express(1,:)), 'FaceColor', [1 0 0], 'Barwidth', 0.5)
ax = gca;
ax.XTickLabel = {'+/+' '+/-' '-/-'}
ax.YTick = [0:0.2:1.5];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Dreammist', 'Fontsize', 22)
box off

%slc6a4b
figure;
bar(flip(mean_express(3,:)), 'k', 'Barwidth', 0.5)
hold on;
errorbar(1:3, flip(mean_express(3,:)), flip(std_express(3,:)), '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'+/+' '+/-' '-/-'}
ax.YTick = [0:0.2:1.5];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
title ('Slc6a4b', 'Fontsize', 22)
box off


%% finally concatenate all experiments and make a final bar chart

all{1}(1,:) = [0.292693861 0.598026725 1]; %3/10/16 relative values for dmist
all{1} (2,:) = [0.286626918 0.946166264 1]; %15/10/16 rleative values for dmist
all{1}(3,:) = [0.289414746 0.786192232 1] %210617 relative values for dmist

all{2}(1,:) = [1.2243071 1.294269943 1]; %3/10/16 relative values for ankrd13a
all{2} (2,:) = [0.91522803 1.491067438 1] %15/10/16 relative values for ankdr13a

all{3} (1,:) = [1.276352715 1.621532365 1] %15/10/16 relative values for slc6a4b
all{3}(2,:) = [1.494389515 1.319652659 1] %21/06/17 relative values for slc6a4b

%make figures
figure;
b = bar(flip(nanmean(all{1})), 'Barwidth', 0.5);
b.FaceColor = [1 0 1];
hold on;
errorbar (flip(nanmean(all{1})), flip(nanstd(all{1})), '.k', 'Linewidth', 2)
ax = gca;
ax.XTickLabel = {'+/+' 'vir/+' 'vir/vir'}
ax.YTick = [0:0.2:2];
set(gca, 'Fontsize', 16)
ylabel('Relative expression', 'Fontsize' ,18);
xlabel('Genotype', 'FontSize', 18);
box off

%make figures
cmap = [1 0 1; 0 0 1; 0 1 0];

for p=1:3
    figure;
    b = bar(flip(nanmean(all{p})), 'Barwidth', 0.5);
    b.FaceColor = cmap(p,:);
    hold on;
    errorbar (flip(nanmean(all{p})), flip(nanstd(all{p})), '.k', 'Linewidth', 2)
    ax = gca;
    ax.XTickLabel = {'+/+' 'vir/+' 'vir/vir'}
    ax.YTick = [0:0.2:2];
    ylim ([0 1.6])
    set(gca, 'Fontsize', 16)
    ylabel('Relative expression', 'Fontsize' ,18);
    xlabel('Genotype', 'FontSize', 18);
    box off
end

for p=1:3
    [P{p},anovatab,stats] = anova1(all{p});
    multcompare(stats)
end