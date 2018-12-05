% Analysis of Dmist qPCR expression levels from Shannon's qPCR at 2/4
   %cells, 24hpf, and 6dpf
   %ida.barlow.12@ucl.ac.uk

%Import excel spreadsheet
uiopen

%sort data
data{1} = Cqvalue(1:3); %housekeeping
data{2}(1:3,1) = Cqvalue(4:6); %2-4 cell
data{2}(1:3,2) = Cqvalue(7:9);% 24hpf
data{2}(1:3, 3) = Cqvalue (10:12); %6dpf

%calculate mean for each developmental time
dmist_means = nanmean (data{2});

%normalise to housekeeping gene at relevant developmental time
for i =1:3
   norm_cq(:,i) = data{2}(:,i) - data{1}(i); 
end

%calculate relative cDNA
for i =1:3
    cDNA_dmist (:,i) = power(2, norm_cq(:,i));
end

%calculate mean and stdev
mean_express = nanmean(cDNA_dmist);
std_express = nanstd(cDNA_dmist);

%normalise to 2-4 cell expression and make a table;
final_norm = mean_express(:)./ mean_express(1);
final_std = std_express(:)./ mean_express(1);

%plot as bar chart
figure;
bar(final_norm,  'k', 'Barwidth', 0.5);
hold on;
errorbar( final_norm, final_std, '.k', 'Linewidth', 2);
ax = gca;
ax.XTickLabel = {'2-4 cell' '24hpf' '6dpf'};
set(gca, 'FontSize', 16);
box off

%stats
[p,anovatab, stats] = anova1(cDNA_dmist);