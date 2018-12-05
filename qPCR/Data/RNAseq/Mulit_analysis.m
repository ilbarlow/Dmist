%qPCR analysis for RNAseq

%% open qpcr excel sheet

[filename, pathname] = uigetfile({'*.xlsx' '*.xls'}, 'Select qPCR file');

uiopen (strcat(pathname, filename),1)

%% sort data

for i=1:3
   data_ref = find(Collection == i); 
   data{i} = Cq(data_ref);
   gene_ref{i} = Gene(data_ref);
   clear data_ref

   for g=1:size(data{i},1) %now sort by gene
       if strfind (char(gene_ref{i}(g)), 'EF1alpha') ==1
           data_2{i,1}(g) = data{i}(g); %housekeeping gene
       end
       if strfind(char(gene_ref{i}(g)), 'Dmist') ==1;
           data_2{i,2}(g) = data{i}(g); %dmist
 
       end
    end
    scrap= find (data_2{i,2});
    data_2{i,2} = data_2{i,2}(scrap);
    clear scrap
end

%now sort out wts and homs
for i=1:size(data_2,1)
   
    for k =1:size(data_2,2)
        
       data_3 {i,k} (:,1) = data_2{i,k}(1:3); %homs
       
       data_3{i,k} (:,2) = data_2{i,k}(4:6); %wts
         
    end
    
end

%now for calculations
for i=1:size(data_3,1)
   dmist_norm {i} = data_3{i,1} -data_3{i,2}; %normalise to housekeeping gene
   
   cDNA_dmist {i} = power(2, dmist_norm{i}); %calculate fold change
   
   mean_dmist {i} = nanmean(cDNA_dmist{i});
   std_dmist {i} = nanstd(cDNA_dmist{i});
  
   mean_express {i} = mean_dmist{i}/ mean_dmist{i}(:,2);
   std_express{i} = std_dmist{i}/ mean_dmist{i} (:,2);
   
end

figure;
title ('dmist^i8 expression','FontSize', 14)
for i=1:3
   subplot (1,3,i)
   bar(fliplr(mean_express{i}), 'k', 'Barwidth', 0.5)
    hold on;
    errorbar(1:2, fliplr(mean_express{i}), fliplr(std_express{i}), '.k', 'Linewidth', 2);
    ax = gca;
    ax.XTickLabel = {'+/+' '-/-'}
    ax.YTick = [0:0.2:1.5];
    set(gca, 'Fontsize', 16)
    ylabel('Relative expression', 'Fontsize' ,18);
    xlabel('Genotype', 'FontSize', 18);
    box off
    
end
