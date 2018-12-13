%Final Script that uses all the functions to make all the Summary figures
%and state transition figures

clear

foldir = uigetdir('', 'Select sleep.mat data folder');

saveDiri8Vir = uigetdir('', 'Select folder to save figures');

namesi8Vir = {'dmist^{+/+}' 'dmist^{i8/+}' 'dmist^{vir/+}' 'dmist^{i8/vir}'};

ControlPosi8Vir =1;

cmapi8Vir = [0 0 0; 1 0 1;0 0 1; 0 1 1]; % Black = WT; magenta = i8het; Blue = virhet; cyan = i8/vir

ymaxD = [0.6 0.6 0.6 0.6 0.6];

ymaxN = [0.8 0.6 0.6 0.6 0.6];


%Summary figures
Summary (foldir, saveDiri8Vir, namesi8Vir, ControlPosi8Vir, cmapi8Vir)

%Activity summary
Summary_Act(foldir, saveDiri8Vir, namesi8Vir, ControlPosi8Vir, cmapi8Vir)

%State transitions
StateTransitions (foldir, saveDiri8Vir, namesi8Vir, ControlPosi8Vir, cmapi8Vir, ymaxD, ymaxN)

%different names for cluster explanation
namesi8Vir2 = {'WT' 'i8Het' 'virHet' 'doubleHom'};

%Cluster explanation
ClusterExplanation(foldir, saveDiri8Vir, namesi8Vir2, ControlPosi8Vir);
