% Rose Hendrix
% Placeholder for future work: currently, example of how to calculate time
% history of joint angles given kinect output

% Need further discussion to learn what parameters exactly are needed
% - functional range? angular velocity? if so, which angle? shoulder only,
% or including elbow? see (https://www.physio-pedia.com/Functional_Movement_Screen_(FMS))

clearvars; close all;
% add necessaries to path
addpath('../helper-functions');
addpath('../kinect-logging/data');

% load the file
load bodyAndRGB_trial21
jo = generateJointObject(bodylogger,'kinect'); %n.b. this can be done online

for ii = 2:size(bodylogger, 3)
    modifications = [0 0 0 0]; % assumptions and a priori knowledge, see arREBA for details
    jointAngles(ii) = jointAnglesOnly(jo(ii));
    
end

figure
hold on
for ii = 2:size(bodylogger, 3)
    plot(ii,jointAngles(ii).shoulderRotateRight,'k.','MarkerSize',14)
end