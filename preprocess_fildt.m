function [surp1,anger1,sad1,tender1] = preprocess_fildt(surp1,anger1,sad1,tender1,sample_data)
    cfg = []; data = [];
    interval = 1/sample_data.fsample;

    [~,timePoints,trilNum ] = size(surp1);
    if timePoints ~= 0
        interval = 1/sample_data.fsample;
        for i = 1:trilNum
            data.trial{1,i} = surp1(:,:,i);
            data.time{i,1} = 0:interval:interval * (timePoints-1);
        end
        data.label = sample_data.label;
        data.fsample = sample_data.fsample;
        [surp1] = ft_preprocessing (cfg, data);
    end

    % tender
    cfg = []; data=[];
    [~,timePoints,trilNum ] = size(tender1);
    if timePoints ~= 0
        for i = 1:trilNum
            data.trial{1,i} = tender1(:,:,i);
            data.time{i,1} = 0:interval:interval * (timePoints-1);
        end
        data.label = sample_data.label;
        data.fsample = sample_data.fsample;
    [tender1] = ft_preprocessing (cfg, data);
    end


    % anger
    cfg = [];data = [];
    [~,timePoints,trilNum ] = size(anger1);
    if timePoints ~= 0 
         for i = 1:trilNum
            data.trial{1,i} = anger1(:,:,i);
            data.time{i,1} = 0:interval:interval * (timePoints-1);
        end
        data.label = sample_data.label;
        data.fsample = sample_data.fsample;
        [anger1] = ft_preprocessing (cfg, data);
    end


    % sad
    cfg = [];
    [~,timePoints,trilNum ] = size(sad1);
    if timePoints ~= 0 
        for i = 1:trilNum
            data.trial{1,i} = sad1(:,:,i);
            data.time{i,1} = 0:interval:interval * (timePoints-1);
        end
        data.label = sample_data.label;
        data.fsample = sample_data.fsample;
        [sad1] = ft_preprocessing (cfg, data);
    end
end