% plot Jason's old Per and Dmist DD qPCR data
    %Normalise expression levels to ZT15 as that is time when Per1 reaches
    %its nadir
    %data is the mean of three replicates for three replicates at each time
    %point

%% import mean Ct data

[filename, pathname] = uigetfile ({'*.xlsx', '*.xls'});

uiopen(strcat(pathname, filename));

%open as column vectors for each condition

%% normalise Ct values

%first make matrix with Per1 and Dmist in

Data = horzcat(Per1, Dmist);

%normalise to house keeping gene
for i = 1:size(Data,2); %each column (ie each gene)
    norm_data (:,i) = Data(:,i) - EF1alpha;
end

%normalise to average expression at nadir of ZT15 (rows 7:9)
for i = 1:size(norm_data,2) %each column
    for j = 1:size(norm_data,1) %every time point repeat
        norm_data2 (j,i) = norm_data(j,i) - nanmean(norm_data(7:9,i));
        expression (j,i) = power(2, -(norm_data2(j,i)));
    end
end

% now calculate average and std dev for each time point
for i = 1:3:size(expression,1) %each time point
    for j = 1:size(expression, 2) %each gene
        ZT_mean (i,j) = nanmean(expression(i:i+2,j));
        ZT_stddev (i,j) = nanstd(expression(i:i+2,j));
    end
end

%remove zeros;
ZT_index = ZT_mean > 0;;
ZT_mean = ZT_mean(ZT_index);
ZT_mean = reshape (ZT_mean, [], 2);
ZT_stddev = ZT_stddev(ZT_index);
ZT_stddev = reshape (ZT_stddev, [], 2);

%% now have raw values can plot some pretty charts

figure;
subplot (2,1,1) %first plot Per1 data
rectangle ('Position', [0,0, 2.5, 140], 'Edgecolor', [0 0 0]);
hold on;
rectangle ('Position',[2.5, 0, 2.5, 140], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [0 0 0])
rectangle ('Position',[5, 0 ,4, 140], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [0 0 0]);
bar(ZT_mean(:,1), 'k');
errorbar (ZT_mean(:,1), ZT_stddev(:,1), 'k.', 'Linewidth', 2);
ylabel ('Relative expression', 'Fontsize', 14);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 14);
ax = gca;
ax.XTick = [1:1:8];
ax.XTickLabel =round(ZT(1:3:24));
xlim ([0 9]);
ylim ([0 140]);
set(gca, 'Fontsize', 16);
title ('Per1 expression', 'Fontsize', 18);

%add on dmist data
subplot (2,1,2)
rectangle ('Position', [0,0, 2.5, 2], 'Edgecolor', [0 0 0]);
hold on;
rectangle ('Position',[2.5, 0, 2.5, 2], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [0 0 0])
rectangle ('Position',[5, 0 ,4, 2], 'Facecolor', [0.9 0.9 0.9], 'Edgecolor', [0 0 0]);
bar(ZT_mean(:,2), 'k');
errorbar (ZT_mean(:,2), ZT_stddev(:,2), 'k.', 'Linewidth', 2);
ylabel ('Relative expression', 'Fontsize', 14);
xlabel ('Zeitgeber time (hours)', 'Fontsize', 14);
ax = gca;
ax.XTick = [1:1:8];
ax.XTickLabel =round(ZT(1:3:24));
xlim ([0 9]);
ylim ([0 2]);
set(gca, 'Fontsize', 16);
title ('Dmist expression', 'Fontsize', 18);



