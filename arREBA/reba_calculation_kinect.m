% Rose Hendrix
% Test REBA calculation on participant data from 2018
% Example script for how the pipeline works

clearvars; close all;
% add necessaries to path
addpath('../helper-functions');
addpath('../kinect-logging/data');

% load the file
load bodyAndRGB_trial22
jo = generateJointObject(bodylogger,'kinect'); %n.b. this can be done online

for ii = 2:size(bodylogger, 3)
    modifications = [0 0 0 0]; % assumptions and a priori knowledge, see arREBA for details
    frameScore(ii) = arREBA(jo(ii),modifications);
    
end

% figure;
% plot(frameScore)

% unnecessary for kinect, used for when labels already exist
% labels = fulllabels.data((startend(trialnum,1):startend(trialnum,2)),[1 2 4 6 8]);
% crossings = logical(diff(labels(:,3:5)));
% [idx,~] = find(crossings);
% idx = [1; unique(sort(idx,'ascend')); ii];

% for ii = 1:length(idx)-1
%     sectidx = idx(ii):idx(ii+1);
%     sectlabels = frameScore(sectidx);
%     worstscore = max(sectlabels);
%     if worstscore > 7
%         labelappend(sectidx) = 2*ones(length(sectidx),1);
%     elseif worstscore > 3
%         labelappend(sectidx) = 1*ones(length(sectidx),1);
%     else
%         labelappend(sectidx) = 0*ones(length(sectidx),1);
%     end
% end
% 
% labels = [labels labelappend'];
% save(['augmentedLablels_' filelist(trialnum).name(1:2) '.txt'], 'labels', '-ASCII');
% save(['augmentedLablels_' filelist(trialnum).name(1:2) '.mat'], 'labels');

clearvars -except trialnum filelist startend


