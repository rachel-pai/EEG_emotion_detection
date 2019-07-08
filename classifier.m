%%
clear all;clc;close all;
addpath('D:\software\fieldtrip-20190325');
addpath('D:\software\eeglab14_1_2b');
%%
clear all; clc; close all;
% fileNameList = {'person1','person2','person1_2','person2_2'};
fileNameList = {'person2_2'};
for fileI = 1:length(fileNameList)
    fileName1 = fileNameList{fileI};
    EEG = pop_loadset(strcat(fileName1,'.set'), 'eeglab/');
    % inEEG = pop_chanedit(inEEG, 'lookup','C:\\Users\\laura\\Documents\\MATLAB\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',{'C:\\Users\\laura\\Google Drive\\EIT HCID\\Brain Computer Interfacing\\Project\\loc.ced' 'filetype' 'autodetect'});
    EEG=pop_chanedit(EEG, 'lookup','D:\\software\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',{'D:\\work\\eeg\\BCI_class\\eeg_emotion_music_generation\\loc.ced' 'filetype' 'autodetect'});
    % EEG = pop_select(EEG,'nochannel',{'T7' 'Cz' 'T8' 'P7' 'P3' 'P4' 'P8' 'A1' 'A2' 'O1' 'Oz' 'O2'});
    EEG = pop_select(EEG,'nochannel',{'T7' 'C3' 'T8' 'P7' 'P3' 'P4' 'P8' 'A1' 'A2' 'O1' 'Oz' 'O2','Pz','Cz'}); 
    EEG = pop_eegfiltnew(EEG,1,45,6760,0,[],1); % filter the data
    EEG = pop_resample(EEG,128);
    pop_saveset(EEG, 'filename',strcat(fileName1,'_channel_clean'),'filepath','eeglab/');
end
%%
% DO MARA in eeglab 

%%

%PERSON 1 experiment2
fileName1 = 'person1_2';
fileName2 = strcat(fileName1,'_channel_clean_filteredICA');
EEG = pop_loadset(strcat(fileName2,'.set'), 'eeglab/');

%surprise
EEG1 = pop_select( EEG,'trial',[1:5 22:26 43:47 64:68 85:89] );
pop_saveset(EEG1, 'filename','surp1_2.set','filepath','eeglab/');

%anger
EEG2 = pop_select( EEG,'trial',[6:21 27:42 48:63 69:84 90:105] );
pop_saveset(EEG2, 'filename','happy1_2.set','filepath','eeglab/');

%sad
EEG3 = pop_select( EEG,'trial',[106:120 121:135 136:150 151:165 166:180]);
pop_saveset(EEG3, 'filename','sad1_2.set','filepath','eeglab/');

%% PERSON 1 experiment1
fileName1 = 'person1';
fileName2 = strcat(fileName1,'_channel_clean_filteredICA');
EEG = pop_loadset(strcat(fileName2,'.set'), 'eeglab/');

%surprise
EEG1 = pop_select( EEG,'trial',[1 6 12 14 16 21 27 29 31 36 42 44 46 51 ...
    57 59 61 66 72 74 76 81 87 89 91 96 102 104 106 111 117 119 121 126 132 134]);
pop_saveset(EEG1, 'filename','surp1.set','filepath','eeglab/');

%anger
EEG2 = pop_select( EEG,'trial',[2 5 7 9 17 20 22 24 32 35 37 39 47 50 52 54 ...
    62 65 67 69 77 80 82 84 92 95 97 99 107 110 112 114 122 125 127 129]);
pop_saveset(EEG2, 'filename','anger1.set','filepath','eeglab/');

%sad
EEG3 = pop_select( EEG,'trial',[3 8 13 18 23 28 33 38 43 48 53 58 63 ...
    68 73 78 83 88 93 98 103 108 113 118 123 128 133]);
pop_saveset(EEG3, 'filename','sad1.set','filepath','eeglab/');

%% PERSON 2
fileName1 = 'person2';
fileName2 = strcat(fileName1,'_channel_clean_filteredICA');
EEG = pop_loadset(strcat(fileName2,'.set'), 'eeglab/');

%surprise
EEG1 = pop_select( EEG,'trial',[7 8 17 18 27 28 37 38 47 48 57 58 67 68 77 78 87 88] );
pop_saveset(EEG1, 'filename','surp2.set','filepath','eeglab/');

%sad
EEG2 = pop_select( EEG,'trial',[2 4 5 12 14 15 22 24 25 32 34 35 42 44 ...
    45 52 54 55 62 64 65 72 74 75 82 84 85] );
pop_saveset(EEG2, 'filename','sad2.set','filepath','eeglab/');
%% PERSON 2 experiment2
fileName1 = 'person2_2';
fileName2 = strcat(fileName1,'_channel_clean_filteredICA');
EEG = pop_loadset(strcat(fileName2,'.set'), 'eeglab/');

%surprise
EEG1 = pop_select( EEG,'trial',[69:72 141:144 213:216 217:231 240:254 263:277]);
pop_saveset(EEG1, 'filename','surp2_2.set','filepath','eeglab/');
%anger
EEG2 = pop_select( EEG,'trial',[42:68 114:140 186:212]);
pop_saveset(EEG2, 'filename','anger2_2.set','filepath','eeglab/');
%sad
EEG3 = pop_select( EEG,'trial',[12:41 84:113 156:185]);
pop_saveset(EEG3, 'filename','sad2_2.set','filepath','eeglab/');
% happy
EEG3 = pop_select( EEG,'trial',[1:11 73:83 145:155 232:239 255:262 278:285]);
pop_saveset(EEG3, 'filename','happy2_2.set','filepath','eeglab/');
%%
% Extract features: (adopted from slides lecture 4)
% Time-domain features: 
% 6 statistics of signal: sampling rate; duration; maximum, minimum,
% avwrage, mean-squred 
    % Hjort Features: mobility, complexity
    % NSI: non-stationary index
    % FD: fractal dimension
    % HOC: high order crossing
% Frequency-domain features:
    % Band power (FFT): Theta, Alpha, Beta, Gamma
    % Bin Power: 4-40 Hz with length of freq. 
    % Time-frequency-domain features
    % Discrete wavelet transform
% Cross-channel features:
    % Band-power difference (left-right)
    % Brand-power Ratio (left/right)
    % Magnitude Squared Coherence Estimate (MSCE)
%% PSD features
clear all; clc; close all;
filenames = {'surp1_2','happy1_2','happy2_2','sad1_2','sad2_2','anger1','anger2_2','sad1','sad2','surp1','surp2','surp2_2'};

for i=1:length(filenames)
    fileName1 = filenames{i};
    EEG = pop_loadset(strcat(fileName1,'.set'), 'eeglab/');
    myfractal2(EEG,1,1,[],'64','0.5');
end
%%
for i=1:length(filenames)
    fileName1 = filenames{i};
    EEG = pop_loadset(strcat(fileName1,'.set'), 'eeglab/'); 
    % normalize data, doesnt influence SVM
    [channNum,timePoints,epochNum] = size(EEG.data);
%     for trialI = 1:epochNum
%         for channI = 1:channNum
%             temp = EEG.data(channI,:,trialI);
%             EEG.data(channI,:,trialI) =  (temp - min(temp)) / ( max(temp) - min(temp));
%         end
%     end
    fs = EEG.srate;
    % FD
    myfractal2(EEG,1,1,[],'64','0.5');
    load('Epoch FD Values.mat','epoch_fds');
    feas = [];
    for epochI = 1:epochNum
        x = EEG.data(:,:,epochI)';
        % for gamma (32-45), beta (16-31), alpha (8-15) and theta (4-7) band 
        % PSD
        freq_gamma = 32:1:45; 
        feas(1,:,epochI) = mean(periodogram(x,[],freq_gamma,fs),1);
        freq_beta = 16:1:31; 
        feas(2,:,epochI) = mean(periodogram(x,[],freq_beta,fs),1);
        freq_alpha = 8:1:15; 
        feas(3,:,epochI) = mean(periodogram(x,[],freq_alpha,fs),1);
        freq_theta = 4:1:7; 
        feas(4,:,epochI) = mean(periodogram(x,[],freq_theta,fs),1);
        feas(5,:,epochI) = epoch_fds(epochI,:);   % concate FD into the last row of PSD feature
        % spectral entropy feature
        spe_ent = [];
        for chanI = 1:channNum
            spe_ent(chanI) = mean(pentropy(EEG.data(chanI,:,epochI),fs));
        end
        feas(6,:,epochI) = spe_ent;
    end
    saved_fileName = strcat('features/',fileName1,'_feature.mat');
    save(saved_fileName,'feas');
end
%% build classifier  happy:1, suprise:2, sad:3, anger:4
% %all persons
fileNames = {'features/happy1_2_feature','features/surp1_2_feature',...
    'features/sad1_2_feature','features/anger1_feature','features/anger2_2_feature'...
    'features/sad1_feature','features/sad2_feature','features/surp1_feature','features/surp2_feature'};
labels_val = {1,2,3,4,4,3,3,2,2}; labels_array = [];flagNum = 0;
% %person 1
% fileNames = {'features/happy1_2_feature','features/surp1_2_feature', ...
%     'features/sad1_2_feature', 'features/anger1_feature', ...
%     'features/sad1_feature','features/surp1_feature',};
% labels_val = {1,2,3,4,3,2}; labels_array = [];flagNum = 0;
% %person 2
% fileNames = {'features/happy2_2_feature','features/surp2_2_feature',...
%     'features/sad2_2_feature','features/anger2_2_feature',...
%     'features/sad2_feature','features/surp2_feature'};
% labels_val = {1,2,3,4,3,2}; labels_array = [];flagNum = 0;
%  happy:1, suprise:2, sad:3, anger:4
for fileI = 1:length(fileNames)
    load(fileNames{fileI});
    [featureNum, channNum,epochNum] = size(feas);
    for trialI = 1:epochNum % 1-5, 6-11,
        for chanI = 1:channNum
        % 1-46;47-46x2;
        features((chanI-1)*featureNum+1:featureNum*chanI,flagNum + trialI) = feas(:,chanI,trialI);
        end
    end
    labels_array = [labels_array zeros(1,epochNum) + labels_val{fileI}];
    flagNum = flagNum+ trialI;
    clear('feas');
end
%% KNN, get the best parameters
rng('default');
Mdl = fitcknn(features',labels_array','OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));
%% train model 
Mdl =fitcknn(features',labels_array','NumNeighbors',5,'Distance','seuclidean');
rloss = resubLoss(Mdl);  % training error is 12.10%
CVMdl = crossval(Mdl);
kloss = kfoldLoss(CVMdl);  % cross-alidation loss is 18.27%
save model/person1_and_2/Mdl
%% SVM, hyper tunning 
rng default
Mdl = fitcecoc(features',labels_array','OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'));
%% 
t = templateSVM('Standardize',true,'BoxConstraint',138.49,'KernelScale',1.2743);
Mdl = fitcecoc(features',labels_array','Learners',t,'Coding','onevsone');
rloss = resubLoss(Mdl);            
CVMdl = crossval(Mdl);
genError = kfoldLoss(CVMdl);  
% save model/person1_and_2/Mdl

% for person 1
% t = templateSVM('Standardize',true,'BoxConstraint',996.96,'KernelScale',3.3688);
% Mdl = fitcecoc(features',labels_array','Learners',t,'Coding','onevsone');
% rloss = resubLoss(Mdl);              % train error : 2.15%
% CVMdl = crossval(Mdl);
% genError = kfoldLoss(CVMdl);        % 10-fold cross validation loss: 27.96%
% save model/person1/Mdl

% for person 2
% t = templateSVM('Standardize',true,'BoxConstraint',26.022,'KernelScale',0.13348);
% Mdl = fitcecoc(features',labels_array','Learners',t,'Coding','onevsall');
% rloss = resubLoss(Mdl);              % train error : 23.94%
% CVMdl = crossval(Mdl);
% genError = kfoldLoss(CVMdl);        % 10-fold cross validation loss: 42.73 %
% save model/person2/Mdl
%%
[validationPredictions, validationScores] = kfoldPredict(CVMdl);
Conf_Mat = confusionmat(labels_array',validationPredictions);
%% happy:1, suprise:2, sad:3, anger:4
xvalues = {'happy','suprise','sad','anger'};
yvalues =  {'happy','suprise','sad','anger'};
h = heatmap(xvalues,yvalues,Conf_Mat);
h.Title = 'Emotion detection confussion matrix';
h.XLabel = 'Predicted';
h.YLabel = 'Actual';
%%
