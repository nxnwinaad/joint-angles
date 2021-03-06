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
load bodyAndRGB_trial23

% Preprocessing for OpenSim loading calculation
onestosave = [48 73 99 135 150 189 204]; % by inspection
imgexport = videologger(:,:,:,onestosave);
for ii = 1:length(onestosave)
    figure(ii)
    imshow(imgexport(:,:,:,ii))%,['validationImg' num2str(ii) '.png'])
end
% 
% 
% videoint = cast(videologger(:,:,:,46:312),'uint8');
% %% write to an AVI
% v = VideoWriter(['shoulder_pose_initial_sampling.avi'],'Uncompressed AVI');
% open(v);
% 
% for ii = 1:size(videoint,4)
%     frame = videoint(:,:,:,ii);
%     writeVideo(v,frame);
% end
% close(v);
% 
[~,skelexportframsnums] = intersect(bodytimelogger,(videotimelogger(onestosave)));
% skelexport = reshape(bodylogger(:,:,skelexportframsnums),25*3,length(onestosave))';
skelexport = bodylogger(:,:,skelexportframsnums);
% csvwrite('cartesianPositionData.csv',skelexport);
save('cartesianPositionData.mat','skelexport');


jo = generateJointObject(skelexport,'kinect'); %n.b. this can be done online

% for ii = 2:size(bodylogger, 3)
%     modifications = [0 0 0 0]; % assumptions and a priori knowledge, see arREBA for details
%     jointAngles(ii) = jointAnglesOnly(jo(ii));
%     
% end
% 
% figure
% hold on
% for ii = 2:size(bodylogger, 3)
%     plot(ii,jointAngles(ii).shoulderHorizAbductRight,'k.','MarkerSize',14)
% end
% 
% figure
% hold on
% for ii = 2:size(bodylogger, 3)
%     plot(ii,jointAngles(ii).shoulderHorizAbductLeft,'k.','MarkerSize',14)
% end
% 
% figure
% hold on
% for ii = 2:size(bodylogger, 3)
%     plot(ii,jointAngles(ii).trunkBend,'k.','MarkerSize',14)
% end