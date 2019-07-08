%% 
clear all;clc;close all;
addpath('D:\software\eeglab14_1_2b');
addpath('D:\software\fieldtrip-20190325');
%%  [event label, timepoint index] 
% 32769: music starts; 32770: music is over
temp_8080 = [32770.0,115175.0
32770.0,178909.0
32770.0,359111.0
32770.0,416310.0
32770.0,467030.0
32770.0,506324.0
32770.0,552032.0
32770.0,595114.0
32770.0,691078.0
32770.0,749554.0
32770.0,787273.0
32770.0,890401.0
32770.0,934125.0
32770.0,1030870.0
32770.0,1077714.0];

temp_1024_1719 = [
32770.0,354618.0
32770.0,519988.0
32770.0,923904.0
32770.0,968982.0
32770.0,1123257.0
32770.0,1174672.0
32770.0,1235784.0
32770.0,1347179.0
32770.0,1465973.0
32770.0,1597008.0
];
%% 
cfg            = [];
cfg.dataset    = 'data/record-[2019.04.01-17.54.06]-8000.gdf';
cfg.continuous = 'yes';
cfg.channel    = 'all';
sample_data   = ft_preprocessing(cfg);
%% 
data1= ft_read_data('data/record-[2019.04.01-17.54.06]-8000.gdf');
data2 = ft_read_data('data/record-[2019.04.01-17.19.20]-1024.gdf');
%% 32769 is start, 32770 is end, extract last 10 seconds
% the first participant, surp(1,6,12,14, 16,21,27,29,  31,36,42,44, 
% 46,51,57,59,  61,66,72,74,  76,81,87,89,  
% 91,96,102,104,  106,111,117,119,  121,126,132,134); 

% anger(2,5,7,9, 17,20,22,24,  32,35,37,39,  47,50,52,54, 
% 62,65,67,69,  77,80,82,84,  92,95,97,99,  107,110,112,114, 122,125,127,129 ), 
% sad(3,8,13, 18,23,28,  33,38,43,  48,53,58, 63,68,73, 78,83,88, 
% 93,98,103, 108,113,118, 123,128,133);
% tender(4,10,11,15)

% % the second participant, surp(7,8, 17,18, 27,28,37,38,47,48,57,58,67,68,77,78,87,88), 
% sad(2,4,5, 12,14,15, 22,24,25, 32,34,35, 42,44,45, 52,54,55, 62,64,65, 72,74,74, 82,84,85)
% tender(1,3,6,9,10, 11,13,16,19,20  21,23,26,29,30,  31,33,36,39,40, 
% 41,43,46,49,50, 51,53,56,59,60, 61,63,66,69,70, 71,73,76,79,80, 81,83,86,89,90),

trialSize = length(temp_8080); %15
for multiI = 1:9
    for personI = (trialSize*multiI-trialSize+1):trialSize*multiI
        person1(:,:,personI) = data1(:,...
        [temp_8080(personI-(trialSize*multiI-trialSize),2)-2*2048:temp_8080(personI-(trialSize*multiI-trialSize),2)]);
    end
end
%% the second participant
trialSize = length(temp_1024_1719); %10
for multiI = 1:9
    for personI = (trialSize*multiI-trialSize+1):trialSize*multiI
        person2(:,:,personI) = data2(:,...
        [temp_1024_1719(personI-(trialSize*multiI-trialSize),2)-2*2048:temp_1024_1719(personI-(trialSize*multiI-trialSize),2)]);
    end
end
%% concate each emotion for eacch person
% [person1,anger1,sad1,tender1] = preprocess_fildt(person1,anger1,sad1,tender1,sample_data);
% [person2,~,person2,person2] = preprocess_fildt(person2,[],person2,person2,sample_data);
cfg = []; data = [];
interval = 1/sample_data.fsample;

[~,timePoints,trilNum ] = size(person2);
if timePoints ~= 0
    interval = 1/sample_data.fsample;
    for i = 1:trilNum
        data.trial{1,i} = person2(:,:,i);
        data.time{i,1} = 0:interval:interval * (timePoints-1);
    end
    data.label = sample_data.label;
    data.fsample = sample_data.fsample;
    [person2] = ft_preprocessing (cfg, data);
end

[~,timePoints,trilNum ] = size(person1);
if timePoints ~= 0
    interval = 1/sample_data.fsample;
    for i = 1:trilNum
        data.trial{1,i} = person1(:,:,i);
        data.time{i,1} = 0:interval:interval * (timePoints-1);
    end
    data.label = sample_data.label;
    data.fsample = sample_data.fsample;
    [person1] = ft_preprocessing (cfg, data);
end
%%
% save data/fieldtrip/surp1.mat person1
% save data/fieldtrip/anger1.mat anger1
% save data/fieldtrip/sad1.mat sad1
% save data/fieldtrip/tender1.mat tender1

save eeglab/person1.mat person1
save eeglab/person2.mat person2
% save data/fieldtrip/tender2.mat person2

%% change fieldtrip format into EEGLab set format, save into data/eeglab directory 
fieldtrip2eeglab_min(person1);
fieldtrip2eeglab_min(person2);
% 
% fieldtrip2eeglab_min(anger1);
% fieldtrip2eeglab_min(sad1);
% fieldtrip2eeglab_min(tender1);
% 
% fieldtrip2eeglab_min(person2);
% fieldtrip2eeglab_min(person2);
% fieldtrip2eeglab_min(person2);
%%