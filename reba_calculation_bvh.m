% Rose Hendrix
% Test REBA calculation on participant data from 2018

clearvars; close all;
% add necessaries to path
addpath('helper_functions');
% addpath('../kinect-logging/data');
addpath('helper_functions/bvh_handling')
format shortG

startend = [240	1480;
255	1530;
234	1190;
306	2206;
256	1763;
281	1645;
240	1720;
237	1520;
254	1910;
215	1850;
290	2100;
265	1400;
309	2320;
195	2030;
228	2000;
255	1988;
242	1890;
205	6710;
239	2280;
200	2060];


cd TUMKitchen
filelist = dir('*.bvh');

for trialnum = 1:length(filelist)
    % load the file
    d = mcread(filelist(trialnum).name);
    % set modifications vector of unknowns (object weight, etc)
    pos = mcgetmarker(d,1:33);
    position = reshape(pos.data,pos.nFrames,3,33);
    jo = generateJointObject(position,'TUMKitchen');
    % load labels for current
    fulllabels = importdata(['TUM_Labels\' filelist(trialnum).name(1:2) '.txt']);
    cd ..
    for ii = 1:length(position)
        modifications = [0 0 0 0]; % assumptions and a priori knowledge
        frameScore(ii) = arREBA(jo(ii),modifications);
        
    end
    cd TUMKitchen
    
    labels = fulllabels.data((startend(trialnum,1):startend(trialnum,2)),[1 2 4 6 8]);
    crossings = logical(diff(labels(:,3:5)));
    [idx,~] = find(crossings);
    idx = [1; unique(sort(idx,'ascend')); ii];
    
    for ii = 1:length(idx)-1
        sectidx = idx(ii):idx(ii+1);
        sectlabels = frameScore(sectidx);
        worstscore = max(sectlabels);
        if worstscore > 7
            labelappend(sectidx) = 2*ones(length(sectidx),1);
        elseif worstscore > 3
            labelappend(sectidx) = 1*ones(length(sectidx),1);
        else
            labelappend(sectidx) = 0*ones(length(sectidx),1);
        end
    end
    
    labels = [labels labelappend'];
    save(['augmentedLablels_' filelist(trialnum).name(1:2) '.txt'], 'labels', '-ASCII');
    save(['augmentedLablels_' filelist(trialnum).name(1:2) '.mat'], 'labels');
    
    clearvars -except trialnum filelist startend
        
    
    
end


% extract the appropriate positions through time


