%% 
clear all;clc;close all;
addpath('D:\software\fieldtrip-20190325');
% addpath('D:\software\eeglab14_1_2b');
%%  [event label, timepoint index] 
% 32769: music starts; 32770: music is over
temp_1630 = [32769.0,37291.0
32769.0,72529.0  
32769.0,343594.0 
32769.0,401555.0 
32769.0,808601.0 
32769.0,878539.0 
32769.0,911673.0  
32769.0,938088.0 
32769.0,988026.0 
32769.0,1030018.0 
32769.0,1049313.0 
32769.0,1098202.0 
32769.0,1155729.0 
32769.0,1187505.0 
32769.0,1218764.0 
32769.0,1257626.0 
32769.0,1297768.0 
32769.0,1586039.0 
32769.0,1710740.0 
32769.0,1799315.0 
32769.0,1835123.0];

temp_1647 = [32769.0,110357.0 
32769.0,141627.0
32769.0,198227.0
32769.0,247953.0
32769.0,247954.0
32769.0,282992.0
32769.0,334569.0
32769.0,362552.0
32769.0,397031.0
32769.0,517226.0
32769.0,659028.0 
32769.0,727147.0
32769.0,777814.0
32769.0,807102.0
32769.0,830907.0
];
%% 
cfg            = [];
cfg.dataset    = 'data/record-[2019.04.04-16.30.12]-1024.gdf';
cfg.continuous = 'yes';
cfg.channel    = 'all';
sample_data   = ft_preprocessing(cfg);
%% 
data1= ft_read_data('data/record-[2019.04.04-16.30.12]-1024.gdf');
data2 = ft_read_data('data/record-[2019.04.04-16.47.36]-1024.gdf');
%% time-locked from -2s to 2s to event  
trailSize = length(temp_1630);
for i_1630=1:trailSize
    person1_2(:,:,i_1630) = data1(:,[temp_1630(i_1630,2)-2*2048:temp_1630(i_1630,2)]);
end

for i_1630=1:trailSize
    person1_2(:,:,i_1630+trailSize) = data1(:,[temp_1630(i_1630,2)-1*2048:temp_1630(i_1630,2)+1*2048]);
end

for i_1630=1:trailSize
    person1_2(:,:,i_1630+trailSize*2) = data1(:,[temp_1630(i_1630,2):temp_1630(i_1630,2)+2*2048]);
end

for i_1630=1:trailSize
    person1_2(:,:,i_1630+trailSize*3) = data1(:,[temp_1630(i_1630,2)+1*2048:temp_1630(i_1630,2)+3*2048]);
end

for i_1630=1:trailSize
    person1_2(:,:,i_1630+trailSize*4) = data1(:,[temp_1630(i_1630,2)+2*2048:temp_1630(i_1630,2)+4*2048]);
end

% trial2
trailSize = length(temp_1647);
for i_1647=1:length(temp_1647)
    person1_2(:,:,i_1647+i_1630*5) = data1(:,[temp_1647(i_1647,2)-2*2048:temp_1647(i_1647,2)]);
end

for i_1647=1:length(temp_1647)
    person1_2(:,:,i_1647+i_1630*5+trailSize) = data1(:,[temp_1647(i_1647,2)-1*2048:temp_1647(i_1647,2)+1*2048]);
end

for i_1647=1:length(temp_1647)
    person1_2(:,:,i_1647+i_1630*5+trailSize*2) = data1(:,[temp_1647(i_1647,2):temp_1647(i_1647,2)+2*2048]);
end

for i_1647=1:length(temp_1647)
    person1_2(:,:,i_1647+i_1630*5+trailSize*3) = data1(:,[temp_1647(i_1647,2)+1*2048:temp_1647(i_1647,2)+3*2048]);
end

for i_1647=1:length(temp_1647)
    person1_2(:,:,i_1647+i_1630*5+trailSize*4) = data1(:,[temp_1647(i_1647,2)+2*2048:temp_1647(i_1647,2)+4*2048]);
end
%%
cfg = []; data = [];
interval = 1/sample_data.fsample;

[~,timePoints,trilNum ] = size(person1_2);
if timePoints ~= 0
    interval = 1/sample_data.fsample;
    for i = 1:trilNum
        data.trial{1,i} = person1_2(:,:,i);
        data.time{i,1} = 0:interval:interval * (timePoints-1);
    end
    data.label = sample_data.label;
    data.fsample = sample_data.fsample;
    [person1_2] = ft_preprocessing (cfg, data);
end
%%
save eeglab/person1_2.mat person1_2
%% change fieldtrip format into EEGLab set format, save into data/eeglab directory 
fieldtrip2eeglab_min(person1_2);
%%