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

%average weight of a person (found somewhere online)
averageWeight = 137; %lbs
%weight of an average person's arm is 6% of total body weight (found somewhere online)
armWeight = 0.06*averageWeight; %lbs
%the forearm is ~2/3 the length of the upper arm and the hand is ~2/3 the
%length of forearm
%the average forearm + hand length is 1.5 ft
upperarmLength = 1.35; %ft
forearmhandLength = 1.5; %ft
forearmLength = 0.9; %ft
totalarmLength = 2.85; %ft

%weight was calculated with the assumption that the arm has a constant
%density
forearmWeight = (forearmhandLength/totalarmLength)*armWeight;
upperarmWeight = (upperarmLength/totalarmLength)*armWeight;

%%straight arm moment reaction calculation (right side)
%the x,y,z coordinate contributions from each angle was calculated and then
%added together to locate the arm in space
    %the x direction is pointing in the direction of the left hand
    %the y direction is pointing in the direction that the eyes look
    %the z direction is pointing in the direction of the head
    
%from the shoulder aduction angle
aductangle_r = [jointAngles(:).shoulderAbductRight];
x_aduct_r = -totalarmLength * sind(aductangle_r(:));
z_aduct_r = totalarmLength - totalarmLength*cosd(aductangle_r(:));

%from the shoulder rotation angle
rotangle_r = [jointAngles(:).shoulderRotateRight];
z_rot_r = totalarmLength - totalarmLength*cosd(rotangle_r(:));
y_rot_r = totalarmLength * sind(rotangle_r(:));

%total position
position_r = ones(length(x_aduct_r),3);
position_r(:,1) = (x_aduct_r);
position_r(:,2) = (y_rot_r);
position_r(:,3) = (totalarmLength-(z_aduct_r + z_rot_r));
position_r = position_r*0.5;
%the x,y,z components of force is then calculated
F = zeros(length(x_aduct_r),3);
F(:,3) = -armWeight*ones(length(x_aduct_r),1);

%the moment is calculated as the cross product of the position and the
%force
M_r = (cross(position_r,F)); %lbs*ft