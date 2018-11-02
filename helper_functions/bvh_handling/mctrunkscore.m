function At = mctrunkscore()
d = mcread;

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% At is the trunk score
% d is the mocap data structure
% bt is notmal to the plane at hip (t for trunk)

bt = mcgetmarker(d, [24 29]);
btx = bt.data(:,4) - bt.data(:,1);
bty = bt.data(:,5) - bt.data(:,2);
btz = bt.data(:,6) - bt.data(:,3);

%% Trunk Angle Calculations wrt hip

% T1 represents the lower trunk bone (ie bone near the hip)
% [2 3] is the set of the markers which defines the lower trunk bone
T1 = mcgetmarker(d, [1 3]);
T1x = T1.data(:,4) - T1.data(:,1);
T1y = T1.data(:,5) - T1.data(:,2);
T1z = T1.data(:,6) - T1.data(:,3);

% calculating the projections
% aT1 is the projection of the lower trunk bone on to the plane defined by b
aT1 = [];
aT1x = bty.*(T1x.*bty-btx.*T1y) - btz.*(T1z.*btx-btz.*T1x);
aT1y = btz.*(T1y.*btz-bty.*T1z) - btx.*(T1x.*bty-btx.*T1y);
aT1z = btx.*(T1z.*btx-btz.*T1x) - bty.*(T1y.*btz-bty.*T1z);
aT1.data = [aT1x aT1y aT1z];

% calculating the norm of the projecttions
% norm_aT1 represents the norm of the projections
norm_aT1 = [];
norm_aT1.data = [sqrt(aT1x.*aT1x + aT1y.*aT1y + aT1z.*aT1z)];
% calcualting normalized projections
% aT1N represents the normalized projections
aT1N = [];
aT1N.data = [aT1x./(norm_aT1.data) aT1y./(norm_aT1.data) aT1z./(norm_aT1.data)];

% T2 represents the trunk bone (upper to the hip)
% [3 7] is the set of the markers which defines the trunk bone (upper to
% the hip
T2 = mcgetmarker(d, [3 7]);
T2x = T2.data(:,4) - T2.data(:,1);
T2y = T2.data(:,5) - T2.data(:,2);
T2z = T2.data(:,6) - T2.data(:,3);

% calculating the projections
% aT2 is the projection of the trunk bone (upper) on to the plane defined by b
aT2 = [];
aT2x = bty.*(T2x.*bty-btx.*T2y) - btz.*(T2z.*btx-btz.*T2x);
aT2y = btz.*(T2y.*btz-bty.*T2z) - btx.*(T2x.*bty-btx.*T2y);
aT2z = btx.*(T2z.*btx-btz.*T2x) - bty.*(T2y.*btz-bty.*T2z);
aT2.data = [aT2x aT2y aT2z];

% calculating the norm of the projecttions
% norm_aT2 represents the norm of the projections
norm_aT2 = [];
norm_aT2.data = [sqrt(aT2x.*aT2x + aT2y.*aT2y + aT2z.*aT2z)];
% calcualting normalized projections
% aT2N represents the normalized projections
aT2N = [];
aT2N.data = [aT2x./(norm_aT2.data) aT2y./(norm_aT2.data) aT2z./(norm_aT2.data)];

% calculating the angle between trunk and hip using normalized projections
% AT represents the angle between trunk and hip (hip angle)
AT = [];
AT.data = [radtodeg(acos((aT1N.data(:,1)).*(aT2N.data(:,1)) + (aT1N.data(:,2)).*(aT2N.data(:,2)) + (aT1N.data(:,3)).*(aT2N.data(:,3))))];

%% Trunk Score Calculations
n = size(AT.data);
At1 = [];
for i = 1:n;
    theta = AT.data;
    if theta(i,1) <= 20;
        At1.data(i,1) = 1;
    elseif theta(i,1) < 0;
        At1.data(i,1) = 2;
    elseif theta(i,1) > 20;
        At1.data(i,1) = 2;
    end
end

%% ================================================ Adjustment 1: If trunk is twisted ==========================================================

% Defining the using the Spine bone 
% [2 7] is the set of the markers which represents the spine ie. normal to the plane 
% m1 are the matrix containing the locations of the markers 2 & 7
% respectively
% m is the normal to the plane
m = [];
m1 = mcgetmarker(d, [2 7]);
mx = m1.data(:,4) - m1.data(:,1);
my = m1.data(:,5) - m1.data(:,2);
mz = m1.data(:,6) - m1.data(:,3);
m.data = [mx my mz];

% H represents the hip bone
% [24 29] is the set of the markers which represents  the hip bone 'H'
H = mcgetmarker(d, [24 29]);
Hx = H.data(:,4) - H.data(:,1);
Hy = H.data(:,5) - H.data(:,2);
Hz = H.data(:,6) - H.data(:,3);

% calculating the projections
% aH1 is the projection of the HIP bone on to the plane defined by m
aH1 = [];
aH1x = my.*(Hx.*my-mx.*Hy) - mz.*(Hz.*mx-mz.*Hx);
aH1y = mz.*(Hy.*mz-my.*Hz) - mx.*(Hx.*my-mx.*Hy);
aH1z = mx.*(Hz.*mx-mz.*Hx) - my.*(Hy.*mz-my.*Hz);
aH1.data = [aH1x aH1y aH1z];

% calculating the norm of the projecttions
% norm_aH1 represents the norm of the projections
norm_aH1 = [];
norm_aH1.data = [sqrt(aH1x.*aH1x + aH1y.*aH1y + aH1z.*aH1z)];
% calcualting normalized projections
% aH1N represents the normalized projections
aH1N = [];
aH1N.data = [aH1x./(norm_aH1.data) aH1y./(norm_aH1.data) aH1z./(norm_aH1.data)];

% S represents the shoulder bones (line segment joining both the shoulders
% [9 15] is the set of the markers which represenst the above ie. 'S'

S = mcgetmarker(d, [24 29]);
Sx = S.data(:,4) - S.data(:,1);
Sy = S.data(:,5) - S.data(:,2);
Sz = S.data(:,6) - S.data(:,3);

% calculating the projections
% aS1 is the projection of the HIP bone on to the plane defined by m
aS1 = [];
aS1x = my.*(Sx.*my-mx.*Sy) - mz.*(Sz.*mx-mz.*Sx);
aS1y = mz.*(Sy.*mz-my.*Sz) - mx.*(Sx.*my-mx.*Sy);
aS1z = mx.*(Sz.*mx-mz.*Sx) - my.*(Sy.*mz-my.*Sz);
aS1.data = [aS1x aS1y aS1z];

% calculating the norm of the projecttions
% norm_aS1 represents the norm of the projections
norm_aS1 = [];
norm_aS1.data = [sqrt(aS1x.*aS1x + aS1y.*aS1y + aS1z.*aS1z)];
% calcualting normalized projections
% aS1N represents the normalized projections
aS1N = [];
aS1N.data = [aS1x./(norm_aS1.data) aS1y./(norm_aS1.data) aS1z./(norm_aS1.data)];

% calculating the angle between trunk twist angle using normalized projections
% at represents the trunk side bending angle
at1 = [];
at1.data = [radtodeg(acos((aH1N.data(:,1)).*(aS1N.data(:,1)) + (aH1N.data(:,2)).*(aS1N.data(:,2)) + (aH1N.data(:,3)).*(aS1N.data(:,3))))];

%% Trunk Score Calculations (Trunk Score with adjustment 1: Trunk Twisting Consideration)
% Trunk twisting angle thresold value has to be determined ( currently taken as 2
% degree)
n = size(at1.data);
At2 = [];
for i = 1:n;
    theta = at1.data;
    if theta(i,1) < 2;
        At2.data(i,1) = At1.data(i,1) + 0;
    elseif theta(i,1) >= 2;
        At2.data(i,1) = At1.data(i,1) + 1;
    end
end


%% ================================================ Adjustment 2: If trunk is side bending ========================================================

% Defining the plane using both the shoulders and pelvis joint
% [1 9 15] is the set of markers which define the required plane
% n1 and n2 is the matrix containing the locations of the markers 1 & 9
n1 = mcgetmarker(d, [1 9]);
n1x = n1.data(:,4) - n1.data(:,1);
n1y = n1.data(:,5) - n1.data(:,2);
n1z = n1.data(:,6) - n1.data(:,3);

n2 = mcgetmarker(d, [1 15]);
n2x = n2.data(:,4) - n2.data(:,1);
n2y = n2.data(:,5) - n2.data(:,2);
n2z = n2.data(:,6) - n2.data(:,3);

% n is the normal to the plane defined by the cross product of the vectors
% n1 & n2
n = [];
nx = n1y.*n2z - n2y.*n1z;
ny = n1z.*n2x - n2z.*n1x;
nz = n1x.*n2y - n2x.*n1y;
n.data = [nx ny nz];

%% Trunk side bending Angle Calculations 

% T1 represents the lower trunk bone (ie bone near the hip) as defined
% above
% [2 3] is the set of the markers which defines the lower trunk bone
T1 = mcgetmarker(d, [2 3]);
T1x = T1.data(:,4) - T1.data(:,1);
T1y = T1.data(:,5) - T1.data(:,2);
T1z = T1.data(:,6) - T1.data(:,3);

% calculating the projections
% bT1 is the projection of the lower trunk bone on to the plane defined by n
bT1 = [];
bT1x = ny.*(T1x.*ny-nx.*T1y) - nz.*(T1z.*nx-nz.*T1x);
bT1y = nz.*(T1y.*nz-ny.*T1z) - nx.*(T1x.*ny-nx.*T1y);
bT1z = nx.*(T1z.*nx-nz.*T1x) - ny.*(T1y.*nz-ny.*T1z);
bT1.data = [bT1x bT1y bT1z];
% calculating the norm of the projecttions
% norm_bT1 represents the norm of the projections
norm_bT1 = [];
norm_bT1.data = [sqrt(bT1x.*bT1x + bT1y.*bT1y + bT1z.*bT1z)];
% calcualting normalized projections
% bT1N represents the normalized projections
bT1N = [];
bT1N.data = [bT1x./(norm_bT1.data) bT1y./(norm_bT1.data) bT1z./(norm_bT1.data)];

% T2 represents the trunk bone (upper to the hip)
% [3 7] is the set of the markers which defines the trunk bone (upper to
% the hip
T2 = mcgetmarker(d, [3 7]);
T2x = T2.data(:,4) - T2.data(:,1);
T2y = T2.data(:,5) - T2.data(:,2);
T2z = T2.data(:,6) - T2.data(:,3);

% calculating the projections
% bT2 is the projection of the trunk bone (upper) on to the plane defined by n
bT2 = [];
bT2x = ny.*(T2x.*ny-nx.*T2y) - nz.*(T2z.*nx-nz.*T2x);
bT2y = nz.*(T2y.*nz-ny.*T2z) - nx.*(T2x.*ny-nx.*T2y);
bT2z = nx.*(T2z.*nx-nz.*T2x) - ny.*(T2y.*nz-ny.*T2z);
bT2.data = [bT2x bT2y bT2z];

% calculating the norm of the projecttions
% norm_bT2 represents the norm of the projections
norm_bT2 = [];
norm_bT2.data = [sqrt(bT2x.*bT2x + bT2y.*bT2y + bT2z.*bT2z)];
% calcualting normalized projections
% bT2N represents the normalized projections
bT2N = [];
bT2N.data = [bT2x./(norm_bT2.data) bT2y./(norm_bT2.data) bT2z./(norm_bT2.data)];

% calculating the angle between trunk side bending angle using normalized projections
% at represents the trunk side bending angle
at2 = [];
at2.data = [radtodeg(acos((bT1N.data(:,1)).*(bT2N.data(:,1)) + (bT1N.data(:,2)).*(bT2N.data(:,2)) + (bT1N.data(:,3)).*(bT2N.data(:,3))))];

%% Trunk Score Calculations (Final Trunk Score with adjustment 2: Trunk side bending)
% Thresold value of the trunk side bending angle is to be determined (currently taken as 10 degrees) 
n = size(at2.data);
At = [];
for i = 1:n;
    theta = at2.data;
    if theta(i,1) < 10;
        At.data(i,1) = At2.data(i,1) + 0;
    elseif theta(i,1) >= 10;
        At.data(i,1) = At2.data(i,1) + 1;
    end
end


%% Plotting the Trunk Score wrt Frame Number
m = size(At.data);
x = 1:m;
y = At.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Trunk Score vs Frame Number')
xlabel('Frame Number')
ylabel('Trunk Score')








