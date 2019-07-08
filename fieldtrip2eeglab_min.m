function [EEG] = fieldtrip2eeglab_min(dataf)

% load data file ('dataf') preprocessed with fieldtrip
% and show in eeglab viewer

[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

% load chanlocs.mat
% EEG.chanlocs = chanlocs;
data = dataf;
EEG.chanlocs = [];

for i=1:size(data.trial,2)
  EEG.data(:,:,i) = single(data.trial{i});
end

EEG.setname    = dataf; %data.cfg.dataset;
EEG.filename   = '';
EEG.filepath   = '';
EEG.subject    = '';
EEG.group      = '';
EEG.condition  = '';
EEG.session    = [];
EEG.comments   = 'preprocessed with fieldtrip';
EEG.nbchan     = size(data.trial{1},1);
EEG.trials     = size(data.trial,2);
EEG.pnts       = size(data.trial{1},2);
EEG.srate      = data.fsample;
EEG.xmin       = data.time{1}(1);
EEG.xmax       = data.time{1}(end);
EEG.times      = data.time{1};
EEG.ref        = []; %'common';
EEG.event      = [];
EEG.epoch      = [];
EEG.icawinv    = [];
EEG.icasphere  = [];
EEG.icaweights = [];
EEG.icaact     = [];
EEG.saved      = 'no';


% eeglab redraw;  % show eeg graphic interface if you did not open it
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG); % update dataset information
% eeglab redraw            % show eeg graphic interface 
% pop_eegplot( EEG, 1, 1, 1); % plot eeg data 
 pop_saveset(EEG, 'filename', inputname(1),'filepath','eeglab/'); % use an interactive pop-up window 
 
% to transform a channel location file, simply type in
% 
% EEG.chanlocs = struct('labels', cfg.elec.label, 'X', mattocell(cfg.elec.pnt(1,:)), 'Y', mattocell(cfg.elec.pnt(2,:)),'Z', mattocell(cfg.elec.pnt(3,:)));
% EEG.chanlocs = convertlocs(EEG.chanlocs, 'cart2all');
% 
% This code is untested. You might have to switch X, Y and Z to obtain the correct orientation for the electrode cap.