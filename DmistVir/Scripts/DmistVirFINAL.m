%Final Script that uses all the functions to make all the Summary figures
%and state transition figures
clear;

foldir = uigetdir('', 'Select sleep.mat data folder');

saveDirVir = uigetdir('', 'Select folder to save figures');

namesVir = {'dmist^{+/+}' 'dmist^{vir/+}' 'dmist^{vir/vir}'};

ControlPosVir =1;

cmapVir = [0 0 0; 0 0 1; 1 0 0]; % Black = WT; Blue = Het; Red = Hom

ymaxD = [0.6 0.6 0.6 0.6 0.6];

ymaxN = [0.8 0.6 0.6 0.6 0.6];

%Summary figures
Summary (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%Activity summary
Summary_Act(foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%State transitions
StateTransitions (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir, ymaxD, ymaxN)

%make new names file for Vir
namesVir2 = {'WT' 'HET' 'HOM'};

%Clustering explanation
ClusterExplanation(foldir, saveDirVir, namesVir2, ControlPosVir);


%% LL
clearvars -except cmapVir ControlPosVir namesVir namesVir2 ymaxD ymaxN

foldir = uigetdir('', 'Select sleep.mat data folder');

saveDirVir = uigetdir('', 'Select folder to save figures');

%Summary figures
Summary (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%Activity summary
Summary_Act(foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%State transitions
StateTransitions (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir, ymaxD, ymaxN)

%Cluster explanation
ClusterExplanation(foldir, saveDirVir, namesVir2, ControlPosVir);

%% DD
clearvars -except cmapVir ControlPosVir namesVir namesVir2

foldir = uigetdir('', 'Select sleep.mat data folder');

saveDirVir = uigetdir('', 'Select folder to save figures');

ymaxD = [0.8 0.6 0.6 0.6 0.6];
ymaxN = [1 0.6 0.6 0.6 0.6];

%Summary figures
Summary (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%Activity summary
Summary_Act(foldir, saveDirVir, namesVir, ControlPosVir, cmapVir)

%State transitions
StateTransitions (foldir, saveDirVir, namesVir, ControlPosVir, cmapVir, ymaxD, ymaxN)

%Cluster explanation
ClusterExplanation(foldir, saveDirVir, namesVir2, ControlPosVir);
