%Final Script that uses all the functions to make all the Summary figures
%and state transition figures
clear;

foldir ='C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\IdaExpsLD\RawData';

saveDirVir ='C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\IdaExpsLD\FinalFigures';

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
namesVir2 = {'virWT' 'virHet' 'virHom'};

warning('off','all')
%Clustering explanation
ClusterExplanation(foldir, saveDirVir, namesVir2, ControlPosVir);


%% LL
clearvars -except cmapVir ControlPosVir namesVir namesVir2 ymaxD ymaxN

foldir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\LL\RawData';

saveDirVir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\LL\FinalFigures';

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

foldir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\DD\RawData';

saveDirVir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\DmistVir\DD\FinalFigures';

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
