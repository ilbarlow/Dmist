%Final Script that uses all the functions to make all the Summary figures
%and state transition figures

clear
warning('off','all')
addpath (genpath('C:\Users\ilbar\Documents\MATLAB\DreammistPaper'))
%% normal LD
foldir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LD\RawData';

saveDiri8 = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LD\Figures';

namesi8 = {'dmist^{i8/i8}' 'dmist^{i8/+}' 'dmist^{+/+}'};

ControlPosi8 =3;

cmapi8 = [1 0 1; 0 1 0; 0 0 0]; % Black = WT; Green = Het; Magenta = Hom

ymaxD = [0.6 0.6 0.6 0.6 0.6];

ymaxN = [0.8 0.6 0.6 0.6 0.6];

%Summary figures
Summary (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%Activity summary
Summary_Act(foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%State transitions
StateTransitions (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8, ymaxD, ymaxN);

%names2 for clustering
namesi82 = {'i8Hom' 'i8Het' 'i8WT'};

%Cluster values
ClusterExplanation(foldir, saveDiri8, namesi82, ControlPosi8);

%% LL 
clearvars -except cmapi8 namesi8 ControlPosi8 namesi82 ymaxD ymaxN

foldir =  'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LL\RawData'
saveDiri8 = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\LL\Figures';

%Summary figures
Summary (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%Activity summary
Summary_Act(foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%State transitions
StateTransitions (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8, ymaxD, ymaxN);

%Cluster explanation
ClusterExplanation(foldir, saveDiri8, namesi82, ControlPosi8);


%% DD
clearvars -except cmapi8 namesi8 namesi82 ControlPosi8

foldir = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\DD\RawData';

saveDiri8 = 'C:\Users\ilbar\Documents\MATLAB\DreammistPaper\Dmisti8\DD\Figures';
 
ymaxD = [0.8 0.6 0.6 0.6 0.6];
ymaxN = [1 0.6 0.6 0.6 0.6];

%Summary figures
Summary (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%Activity summary
Summary_Act(foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%State transitions
StateTransitions (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8, ymaxD, ymaxN)

%Cluster Explanation
ClusterExplanation(foldir, saveDiri8, namesi82, ControlPosi8);


%% dimmed lights
    %need to look up whether these experiments are 4-7dpf or 5-8dpf
    
clearvars -except cmapi8 namesi8 ControlPosi8

foldir = uigetdir('', 'Select sleep.mat data folder');

saveDiri8 = uigetdir('', 'Select folder to save figures');

%Summary figures
Summary (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%Activity summary
Summary_Act(foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)

%State transitions
StateTransitions (foldir, saveDiri8, namesi8, ControlPosi8, cmapi8)