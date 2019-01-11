function dist_plot(state_trans, no_subplots, cmap, labels, stats, filename, ymax)
%this function makes the distribution plots with larger marker sizes
    %other required function is plotSpread.m
    
%Inputs:
    %state_trans - cell array of state transitions (every row is a state,
    %every column is a day/combined days
    
    %no_subplots - number of subplots to plot (usuually 5)
    
    %cmap - colormap to use
    
    %labels - cell array of labels (should correspond to the number of
    %conditions/genotypes
    
    %stats - cell array of the stats of difference between first and last group
    
    %filename- the filename to use to save the figure
    
    %ymax - vector of ymaxes for each subplot
  
  %Output:
    %.eps an .fig saved into assigned folder

    %inline functiont to define sem
    sem = @(x) ((nanstd(x'))./ sqrt(size(x,2))); %inline function for standard error of mean

    figure('position', [25, 50, 1500, 500]);
for s=1:no_subplots
        subplot (1,5,s)
        title (num2str(s-1))  
        h= plotSpread(state_trans{s,3}, 'distributionColors', cmap);   
        errorbar(nanmedian(state_trans{s,3}), sem(state_trans{s,3}'), ...
            '+', 'Color', [0.5 0.5 0.5], 'LineWidth', 1); 
        ax=gca;   
        ax.XTickLabel =labels;
        ax.XTickLabelRotation = 45;   
        ax.FontSize = 12;
        set(findall(gca, 'type', 'line'), 'markersize', 10) 
        h{2}(1).LineWidth = 2;
        h{2}(1).Color = [0.5 0.5 0.5];
        ylim ([0 ymax(s)]);  
        text(2, 1, num2str(stats(3,s)))   
        ylabel ('Probability of transition', 'Fontsize', 12)  
end
print(filename, '-depsc', '-tiff')
savefig(strcat(filename, '.fig'));
saveas(gcf, strcat(filename, '.tiff'), 'tiff')
%close;

end



