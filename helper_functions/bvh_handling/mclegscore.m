function Al = mclegscore()
d = mcread;

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% Al is the leg score
% d is the mocap data structure
% bl is notmal to the plane at hip (l for leg)

bl = mcgetmarker(d, [24 29]);
blx = bl.data(:,4) - bl.data(:,1);
bly = bl.data(:,5) - bl.data(:,2);
blz = bl.data(:,6) - bl.data(:,3);

%% Left Leg Angle Calculations
% L1 represents the left femur bone (ie left upper leg)
% [39 30] is the set of the markers which defines the left upper leg
L1 = mcgetmarker(d, [29 30]);
L1x = L1.data(:,4) - L1.data(:,1);
L1y = L1.data(:,5) - L1.data(:,2);
L1z = L1.data(:,6) - L1.data(:,3);

% calculating the projections
% aL1 is the projection of the left upper leg on to the plane defined by b
aL1 = [];
aL1x = bly.*(L1x.*bly-blx.*L1y) - blz.*(L1z.*blx-blz.*L1x);
aL1y = blz.*(L1y.*blz-bly.*L1z) - blx.*(L1x.*bly-blx.*L1y);
aL1z = blx.*(L1z.*blx-blz.*L1x) - bly.*(L1y.*blz-bly.*L1z);
aL1.data = [aL1x aL1y aL1z];

% calculating the norm of the projecttions
% norm_aL1 represents the norm of the projections
norm_aL1 = [];
norm_aL1.data = [sqrt(aL1x.*aL1x + aL1y.*aL1y + aL1z.*aL1z)];
% calcualting normalized projections
% aL1N represents the normalized projections
aL1N = [];
aL1N.data = [aL1x./(norm_aL1.data) aL1y./(norm_aL1.data) aL1z./(norm_aL1.data)];

% L2 represents the left fibua or tibia bone (ie left lower leg)
% [30 31] is the set of the markers which defines the left lower leg
L2 = mcgetmarker(d, [30 31]);
L2x = L2.data(:,4) - L2.data(:,1);
L2y = L2.data(:,5) - L2.data(:,2);
L2z = L2.data(:,6) - L2.data(:,3);

% calculating the projections
% aL2 is the projection of the left lower leg on to the plane defined by b
aL2 = [];
aL2x = bly.*(L2x.*bly-blx.*L2y) - blz.*(L2z.*blx-blz.*L2x);
aL2y = blz.*(L2y.*blz-bly.*L2z) - blx.*(L2x.*bly-blx.*L2y);
aL2z = blx.*(L2z.*blx-blz.*L2x) - bly.*(L2y.*blz-bly.*L2z);
aL2.data = [aL2x aL2y aL2z];

% calculating the norm of the projecttions
% norm_aL2 represents the norm of the projections
norm_aL2 = [];
norm_aL2.data = [sqrt(aL2x.*aL2x + aL2y.*aL2y + aL2z.*aL2z)];
% calcualting normalized projections
% aL2N represents the normalized projections
aL2N = [];
aL2N.data = [aL2x./(norm_aL2.data) aL2y./(norm_aL2.data) aL2z./(norm_aL2.data)];

% calculating the angle between left upper and left lower leg using
% normalized projections
% AL represents the angle between upper nad lower leg (Left)
AL = [];
AL.data = [radtodeg(acos((aL1N.data(:,1)).*(aL2N.data(:,1)) + (aL1N.data(:,2)).*(aL2N.data(:,2)) + (aL1N.data(:,3)).*(aL2N.data(:,3))))];

%% Right Leg Angle Calculations
% R1 represents the right femur bone (ie right upper leg)
% [24 25] is the set of the markers which defines the right upper leg
R1 = mcgetmarker(d, [24 25]);
R1x = R1.data(:,4) - R1.data(:,1);
R1y = R1.data(:,5) - R1.data(:,2);
R1z = R1.data(:,6) - R1.data(:,3);

% calculating the projections
% aR1 is the projection of the right upper leg on to the plane defined by b
aR1 = [];
aR1x = bly.*(R1x.*bly-blx.*R1y) - blz.*(R1z.*blx-blz.*R1x);
aR1y = blz.*(R1y.*blz-bly.*R1z) - blx.*(R1x.*bly-blx.*R1y);
aR1z = blx.*(R1z.*blx-blz.*R1x) - bly.*(R1y.*blz-bly.*R1z);
aR1.data = [aR1x aR1y aR1z];

% calculating the norm of the projecttions
% norm_aR1 represents the norm of the projections
norm_aR1 = [];
norm_aR1.data = [sqrt(aR1x.*aR1x + aR1y.*aR1y + aR1z.*aR1z)];
% calcualting normalized projections
% aR1N represents the normalized projections
aR1N = [];
aR1N.data = [aR1x./(norm_aR1.data) aR1y./(norm_aR1.data) aR1z./(norm_aR1.data)];

% R2 represents the right fibua or tibia bone (ie right lower leg)
% [25 26] is the set of the markers which defines the right lower leg
R2 = mcgetmarker(d, [25 26]);
R2x = R2.data(:,4) - R2.data(:,1);
R2y = R2.data(:,5) - R2.data(:,2);
R2z = R2.data(:,6) - R2.data(:,3);

% calculating the projections
% aR2 is the projection of the right lower leg on to the plane defined by b
aR2 = [];
aR2x = bly.*(R2x.*bly-blx.*R2y) - blz.*(R2z.*blx-blz.*R2x);
aR2y = blz.*(R2y.*blz-bly.*R2z) - blx.*(R2x.*bly-blx.*R2y);
aR2z = blx.*(R2z.*blx-blz.*R2x) - bly.*(R2y.*blz-bly.*R2z);
aR2.data = [aR2x aR2y aR2z];

% calculating the norm of the projecttions
% norm_aR2 represents the norm of the projections
norm_aR2 = [];
norm_aR2.data = [sqrt(aR2x.*aR2x + aR2y.*aR2y + aR2z.*aR2z)];
% calcualting normalized projections
% aR2N represents the normalized projections
aR2N = [];
aR2N.data = [aR2x./(norm_aR2.data) aR2y./(norm_aR2.data) aR2z./(norm_aR2.data)];

% calculating the angle between left upper and left lower leg using
% normalized projections
% AL represents the angle between upper and lower leg (right)
AR = [];
AR.data = [radtodeg(acos((aR1N.data(:,1)).*(aR2N.data(:,1)) + (aR1N.data(:,2)).*(aR2N.data(:,2)) + (aR1N.data(:,3)).*(aR2N.data(:,3))))];

%% Leg Score Calculations 
% Take the thresold value to be 2 degrees (bcs we can have calculation error
% of upto 2 degrees)
Al = [];
n = size(AR.data);
for i = 1:n;
    thetaL = AL.data;
    thetaR = AR.data;
    if thetaL(i,1) == 0 && thetaR(i,1) == 0;
        Al.data(i,1) = 1;
    elseif 0 < thetaL(i,1) && thetaL(i,1) <= 30 && thetaR(i,1) == 0;
        Al.data(i,1) = 2;
    elseif 0 < thetaR(i,1) && thetaR(i,1) <= 30 && thetaL(i,1) == 0;
        Al.data(i,1) = 2;
    elseif 0 <= thetaL(i,1) && thetaL(i,1) <= 30 && 0 <= thetaR(i,1) && thetaR(i,1) <= 30;
        Al.data(i,1) = 1;
    elseif 0 <= thetaL(i,1) && thetaL(i,1) <= 30 && 30 <= thetaR(i,1) && thetaR(i,1) <= 60;
        Al.data(i,1) = 2;
    elseif 30 < thetaL(i,1) && thetaL(i,1) <= 60 && 0 <= thetaR(i,1) && thetaR(i,1) <= 30;
        Al.data(i,1) = 2;
    elseif 0 <= thetaL(i,1) && thetaL(i,1) <= 30 && thetaR(i,1) >= 60;
        Al.data(i,1) = 3;
    elseif 0 <= thetaR(i,1) && thetaR(i,1) <= 30 && thetaL(i,1) >= 60;
        Al.data(i,1) = 3;
    elseif 30 < thetaL(i,1) && thetaL(i,1) <= 60 && thetaR(i,1) >= 60;
        Al.data(i,1) = 3;
    elseif 30 < thetaR(i,1) && thetaR(i,1) <= 60 && thetaL(i,1) >= 60;
        Al.data(i,1) = 3;
    elseif 30 < thetaL(i,1) && thetaL(i,1) <= 60 && 30 < thetaR(i,1) && thetaR(i,1) <= 60;
        Al.data(i,1) = 2;
    elseif 60 < thetaL(i,1) && 60 < thetaR(i,1);
        Al.data(i,1) = 4;
    end
end

%% Plotting the Leg Score wrt Frame Number
m = size(Al.data);
x = 1:m;
y = Al.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Leg Score vs Frame Number')
xlabel('Frame Number')
ylabel('Leg Score')




