function dist_plot(state_trans, no_subplots, cmap, labels, stats, filename)
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
  
  %Output:
    %.eps an .fig saved into assigned folder

for s=1:no_subplots
        subplot (1,5,s)
        title (num2str(s-1))  
        h= plotSpread(state_trans{s,3}, 'distributionColors', cmap, 'showMM', 2);   
        ax=gca;   
        ax.XTickLabel =labels;
        ax.XTickLabelRotation = 45;   
        ax.FontSize = 12;
        set(findall(gca, 'type', 'line'), 'markersize', 10) 
        h{2}(1).LineWidth = 3;
        h{2}(1).Color = [0.5 0.5 0.5];
        ylim ([0 1]);  
        text(2, 1, num2str(stats(s,3)))   
        ylabel ('Probability of transition', 'Fontsize', 12)  
end
print(filename, '-depsc', '-tiff')
savefig(strcat(filename, '.fig'));
close;

end



