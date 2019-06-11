% Rose Hendrix
% Placeholder for future work: currently, example of how to calculate time
% history of joint angles given kinect output

% Need further discussion to learn what parameters exactly are needed
% - functional range? angular velocity? if so, which angle? shoulder only,
% or including elbow? see (https://www.physio-pedia.com/Functional_Movement_Screen_(FMS))

clear all; close all;
% add necessaries to path
addpath('../helper-functions');
addpath('../kinect-logging/data');

%load the file
load cartesianPositionData.mat
load bodyAndRGB_trial21
jo = generateJointObject(bodylogger,'kinect'); %n.b. this can be done online

for ii = 1:size(bodylogger, 3)
    modifications = [0 0 0 0]; % assumptions and a priori knowledge, see arREBA for details
    jointAngles(ii) = jointAnglesOnly(jo(ii));
    
end

% load cartesianPositionData.mat
% jo = generateJointObject(skelexport,'kinect'); %n.b. this can be done online
% 
% for ii = 1:size(skelexport, 3)
%     modifications = [0 0 0 0]; % assumptions and a priori knowledge, see arREBA for details
%     jointAngles(ii) = jointAnglesOnly(jo(ii));
%     
% end

% figure
% hold on
% for ii = 2:size(skelexport, 3)
%     plot(ii,jointAngles(ii).shoulderRotateRight,'k.','MarkerSize',14)
% end

%average weight of a person (found somewhere online)
averageWeight = 62.14; %N, 137 lbs
%weight of an average person's arm is 6% of total body weight (found somewhere online)
armWeight = 0.06*averageWeight; %lbs
%the forearm is ~2/3 the length of the upper arm and the hand is ~2/3 the
%length of forearm
%the average forearm + hand length is 1.5 ft
bicepLength = 1.35; %ft
forearmhandLength = 1.5; %ft
forearmLength = 0.9; %ft
totalarmLength = 2.85; %ft

%weight was calculated with the assumption that the arm has a constant
%density
forearmWeight = (forearmhandLength/totalarmLength)*armWeight;
upperarmWeight = (bicepLength/totalarmLength)*armWeight;

%%straight arm moment reaction calculation (right side)
%the x,y,z coordinate contributions from each angle was calculated and then
%added together to locate the arm in space
    %the y direction is pointing in the direction of the left hand
    %the x direction is pointing in the direction that the eyes look
    %the z direction is pointing in the direction of the head

%% Calculating moment from the wrist/finger locations from the Kinect
%units taken from the Kinect are in m

%right hand calcs
shoulder_pos_r = [jo.ShoulderRight];
elbow_pos_r = [jo.ElbowRight];
hand_pos_r = [jo.HandRight];

F_fore = ones(size(shoulder_pos_r,2), 1) * -9.81 * forearmWeight;
zerovec = zeros(size(shoulder_pos_r,2), 1);
F_fore = [zerovec zerovec, F_fore];

F_bicep = ones(size(shoulder_pos_r,2), 1) * -9.81 * upperarmWeight;
F_bicep = [zerovec, zerovec, F_bicep];

forearm_vec_r = (hand_pos_r + elbow_pos_r)./2;
helpmeplease_r = forearm_vec_r - shoulder_pos_r;
M_forearm_r = cross(helpmeplease_r.',F_fore);

bicep_vec_r = elbow_pos_r - shoulder_pos_r;
M_bicep_r = cross(bicep_vec_r.'./2,F_bicep);
M_tot_r = M_forearm_r + M_bicep_r;

% forearm_vec_r = hand_pos_r - elbow_pos_r;
% M_forearm_r = cross(forearm_vec_r.'./2,F_fore);
% 
% bicep_vec_r = elbow_pos_r - shoulder_pos_r;
% M_bicep_r = cross(bicep_vec_r.'./2,F_bicep) + M_forearm_r;
    
%left hand calcs
shoulder_pos_l = [jo.ShoulderLeft];
elbow_pos_l = [jo.ElbowLeft];
hand_pos_l = [jo.HandLeft];

forearm_vec_l = (hand_pos_l + elbow_pos_l)./2;
helpmeplease_l = forearm_vec_l - shoulder_pos_l;
M_forearm_l = cross(helpmeplease_l.',F_fore);

bicep_vec_l = elbow_pos_l - shoulder_pos_l;
M_bicep_l = cross(bicep_vec_l.'./2,F_bicep);
M_tot_l = M_forearm_l + M_bicep_l;

% forearm_vec_l = hand_pos_l - elbow_pos_l;
% M_forearm_l = cross(forearm_vec_l.'./2,F_fore);
% 
% bicep_vec_l = elbow_pos_l - shoulder_pos_l;
% M_bicep_l = cross(bicep_vec_l.'./2,F_bicep) + M_forearm_l;

%% Attempt to use Angles to determine positionof elbow/fingers
% please note that code to locate finger position and calculating moment from forearm is wrong

% elbow_pos = [jointAngles(:).shoulderAbductRight];
% 
% %elbow location
% aductangle_r = [jointAngles(:).shoulderAbductRight];
% rotangle_r = [jointAngles(:).shoulderRotateRight];
% bicepx = bicepLength .* sind(rotangle_r) .* cosd(aductangle_r);
% bicepy = bicepLength .* sind(aductangle_r) .* cosd(rotangle_r);
% bicepz = -bicepLength .* cosd(aductangle_r) .* cosd(rotangle_r);
% 
% %fingertip location
% elbowbend_r = [jointAngles(:).elbowBendRight];
% introt_r = [jointAngles(:).shoulderIntRotateRight];
% fingerx = zeros(size(elbowbend_r,2),1);
% fingery = zeros(size(elbowbend_r,2),1);
% fingerz = zeros(size(elbowbend_r,2),1);
% 
% for j = 1: size(elbowbend_r,2)
%     if isempty(jointAngles(j).shoulderIntRotateRight) == 1
%         fingerx(j) = totalarmLength .* sind(rotangle_r(j)) .* cosd(aductangle_r(j));
%         fingery(j) = totalarmLength .* sind(aductangle_r(j)) .* cosd(rotangle_r(j));
%         fingerz(j) = -totalarmLength .* cosd(aductangle_r(j)) .* cosd(rotangle_r(j));
%     else
%         fingerx(j) = bicepx(j) + (forearmLength .* sind(jointAngles(j).shoulderIntRotateRight) .* cosd(elbowbend_r(1,j)));
%         fingery(j) = bicepy(j) + (forearmLength .* sind(elbowbend_r(1,j)) .* cosd(jointAngles(j).shoulderIntRotateRight));
%         fingerz(j) = bicepz(j) + (-forearmLength .* cosd(jointAngles(j).shoulderIntRotateRight) .* cosd(elbowbend_r(1,j)));
%     end
% end
% 
% %Moment calculations for bicep
% Shoulder_pos_r = [jo.ShoulderRight];
% 
% F_fore = ones(size(Shoulder_pos_r,2), 1) * -32.2 * forearmWeight;
% zerovec = zeros(size(Shoulder_pos_r,2), 1);
% F_fore = [zerovec, zerovec, F_fore];
% 
% F_bicep = ones(size(Shoulder_pos_r,2), 1) * -32.2 * upperarmWeight;
% F_bicep = [zerovec, zerovec, F_bicep];
% 
% bicep_vec = [(Shoulder_pos_r(1,:)-bicepx(1,:));(Shoulder_pos_r(2,:)-bicepy(1,:));(Shoulder_pos_r(3,:)-bicepz(1,:))];
% 
% M_bicep = cross((bicep_vec./2).',F_bicep);
% 
% %Moment calculations for forearm
% forearm_vec = [(bicepx(1,:)-fingerx(1,:));(bicepy(1,:)-fingery(1,:));(bicepz(1,:)-fingerz(1,:))];
% 
% M_fore = cross((forearm_vec./2).',F_fore);
% 
% M_tot = M_bicep + M_fore;

%% test section (sorry)
 figure
 for i = 63
     plot(bodylogger(1,:,i),bodylogger(2,:,i),".")
     %plot(bodylogger(1,[1:4 9:end],i),bodylogger(2,[1:4 9:end],i),".")
     axis([-0.6 0.6 -1.5 1])
     plotnum = i;
     title(plotnum)
     %axis([-450 -150 -300 0])
     pause(0.6)
 end
 %notes: for trial23, video is ahead 22, for trial21, video is ahead 5
%shoulderanglesonly = [12:17]
%testframes = [jointAngles(:,[9,26,51,77,113,128,167,182])]