function REBAScore = REBASCORE()
d = mcread;

%%================================================================================================================
%%================================================================================================================
%% TRUNK SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

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
% m = size(At.data);
% x = 1:m;
% y = At.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Trunk Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Trunk Score')


%%================================================================================================================
%%================================================================================================================
%% NECK SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% An is the neck score
% d is the mocap data structure
% bn is notmal to the plane at shoulders (n for neck)
% [9 15] is the pair of the markers which defines normal to the plane(ie bn)

bn = mcgetmarker(d, [9 15]);
bnx = bn.data(:,4) - bn.data(:,1);
bny = bn.data(:,5) - bn.data(:,2);
bnz = bn.data(:,6) - bn.data(:,3);

%% Neck Angle Calculations wrt spine (trunk)
% N1 represents the spine (trunk bone) 
% [2 7] is the set of the markers which defines the spine (upper trunk bone)
N1 = mcgetmarker(d, [6 7]);
N1x = N1.data(:,4) - N1.data(:,1);
N1y = N1.data(:,5) - N1.data(:,2);
N1z = N1.data(:,6) - N1.data(:,3);

% calculating the projections
% aN1 is the projection of the spine (trunk bone) on to the plane defined
% by bn
aN1 = [];
aN1x = bny.*(N1x.*bny-bnx.*N1y) - bnz.*(N1z.*bnx-bnz.*N1x);
aN1y = bnz.*(N1y.*bnz-bny.*N1z) - bnx.*(N1x.*bny-bnx.*N1y);
aN1z = bnx.*(N1z.*bnx-bnz.*N1x) - bny.*(N1y.*bnz-bny.*N1z);
aN1.data = [aN1x aN1y aN1z];

% calculating the norm of the projecttions
% norm_aN1 represents the norm of the projections on the plane defined by
% bn
norm_aN1 = [];
norm_aN1.data = [sqrt(aN1x.*aN1x + aN1y.*aN1y + aN1z.*aN1z)];

% calcualting normalized projections
% aN1N represents the normalized projections
aN1N = [];
aN1N.data = [aN1x./(norm_aN1.data) aN1y./(norm_aN1.data) aN1z./(norm_aN1.data)];

% N2 represents the neck bone 
% [7 21] is the set of the markers which defines the ncek bone 
N2 = mcgetmarker(d, [7 21]);
N2x = N2.data(:,4) - N2.data(:,1);
N2y = N2.data(:,5) - N2.data(:,2);
N2z = N2.data(:,6) - N2.data(:,3);

% calculating the projections
% aN2 is the projection of the neck bone on to the plane defined by bn
aN2 = [];
aN2x = bny.*(N2x.*bny-bnx.*N2y) - bnz.*(N2z.*bnx-bnz.*N2x);
aN2y = bnz.*(N2y.*bnz-bny.*N2z) - bnx.*(N2x.*bny-bnx.*N2y);
aN2z = bnx.*(N2z.*bnx-bnz.*N2x) - bny.*(N2y.*bnz-bny.*N2z);
aN2.data = [aN2x aN2y aN2z];

% calculating the norm of the projecttions
% norm_aN2 represents the norm of the projections
norm_aN2 = [];
norm_aN2.data = [sqrt(aN2x.*aN2x + aN2y.*aN2y + aN2z.*aN2z)];

% calcualting normalized projections
% aN2N represents the normalized projections
aN2N = [];
aN2N.data = [aN2x./(norm_aN2.data) aN2y./(norm_aN2.data) aN2z./(norm_aN2.data)];

% calculating the angle between trunk and neck using normalized projections
% AN represents the angle between trunk and neck 
AN = [];
AN.data = [radtodeg(acos((aN1N.data(:,1)).*(aN2N.data(:,1)) + (aN1N.data(:,2)).*(aN2N.data(:,2)) + (aN1N.data(:,3)).*(aN2N.data(:,3))))];

%% Neck Score Calculations
n = size(AN.data);
An1 = [];

for i = 1:n;
    theta = AN.data;
    if theta(i,1) <= 20;
        An1.data(i,1) = 1;
    elseif theta(i,1) < 0;
        An1.data(i,1) = 2;
    elseif theta(i,1) > 20;
        An1.data(i,1) = 2;
    end
end

%% ============================================ Adjustment: If neck is side bending =======================================================

% Defining the plane using both the shoulders and pelvis
% [1 9 15] is the set of markers which define the required plane
% n is the matrix containing the locations of the markers 1 & 9
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

% Calculating the projections 

%% N1 represents the spine (trunk bone) 
% [2 7] is the set of the markers which defines the spine (trunk bone) as
% defined above as well
N1 = mcgetmarker(d, [6 7]);
N1x = N1.data(:,4) - N1.data(:,1);
N1y = N1.data(:,5) - N1.data(:,2);
N1z = N1.data(:,6) - N1.data(:,3);

% calculating the projections
% an1 is the projection of the spine (trunk bone) on to the plane defined
% by n
an1 = [];
an1x = ny.*(N1x.*ny-nx.*N1y) - nz.*(N1z.*nx-nz.*N1x);
an1y = nz.*(N1y.*nz-ny.*N1z) - nx.*(N1x.*ny-nx.*N1y);
an1z = nx.*(N1z.*nx-nz.*N1x) - ny.*(N1y.*nz-ny.*N1z);
an1.data = [an1x an1y an1z];

% calculating the norm of the projecttions
% norm_an1 represents the norm of the projections
norm_an1 = [];
norm_an1.data = [sqrt(an1x.*an1x + an1y.*an1y + an1z.*an1z)];

% calcualting normalized projections
% an1n represents the normalized projections of spine (trunk bone) 
an1n = [];
an1n.data = [an1x./(norm_an1.data) an1y./(norm_an1.data) an1z./(norm_an1.data)];

%% N2 represents the neck bone 
% [7 20] is the set of the markers which defines the neck bone 
N2 = mcgetmarker(d, [7 20]);
N2x = N2.data(:,4) - N2.data(:,1);
N2y = N2.data(:,5) - N2.data(:,2);
N2z = N2.data(:,6) - N2.data(:,3);

% calculating the projections
% an2 is the projection of the neck bone on to the plane defined by n
an2 = [];
an2x = ny.*(N2x.*ny-nx.*N2y) - nz.*(N2z.*nx-nz.*N2x);
an2y = nz.*(N2y.*nz-ny.*N2z) - nx.*(N2x.*ny-nx.*N2y);
an2z = nx.*(N2z.*nx-nz.*N2x) - ny.*(N2y.*nz-ny.*N2z);
an2.data = [an2x an2y an2z];

% calculating the norm of the projecttions
% norm_an2 represents the norm of the projections of neck bone on plane
% defined by n
norm_an2 = [];
norm_an2.data = [sqrt(an2x.*an2x + an2y.*an2y + an2z.*an2z)];

% calcualting normalized projections
% an2n represents the normalized projections
an2n = [];
an2n.data = [an2x./(norm_an2.data) an2y./(norm_an2.data) an2z./(norm_an2.data)];

%% calculating the angle between trunk and neck using normalized projections
% an represents the angle between trunk and neck (hip angle)
an = [];
an.data = [radtodeg(acos((an1n.data(:,1)).*(an2n.data(:,1)) + (an1n.data(:,2)).*(an2n.data(:,2)) + (an1n.data(:,3)).*(an2n.data(:,3))))];

%% Final Neck Score Calculations (with adjustments of neck side bending)
% Threshold value of the side bending is to be included (currently taken as
% 5 degrees)
n = size(an.data);
An = [];

for i = 1:n;
    theta = an.data;
    if theta(i,1) <= 5;
        An.data(i,1) = An1.data(i,1) + 0;
    elseif theta(i,1) > 5;
        An.data(i,1) = An1.data(i,1) + 1;
    end
end

%% Plotting the Neck Score wrt Frame Number
% m = size(An.data);
% x = 1:m;
% y = An.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Neck Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Neck Score')



%%================================================================================================================
%%================================================================================================================
%% LEG SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

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
% m = size(Al.data);
% x = 1:m;
% y = Al.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Leg Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Leg Score')


%%================================================================================================================
%%================================================================================================================
%% TABLE A SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% d is mocap data structure
% n is number of frames
% An is matrix containing neck Scores
% Al is matrix containing leg Scores
% At is matrix containing trunk Scores
% A is risk Score from table A

%% Calulations for Table A

A = [];
n = size(An.data);
AN = An.data;
AL = Al.data;
AT = At.data;

for j = 1:n;
    if AN(j,1) == 1;
        if AL(j,1) == 1;
            if AT(j,1) == 1;
                A.data(j,1) = 1;
            elseif AT(j,1) == 2;
                A.data(j,1) = 2;
            elseif AT(j,1) == 3;
                A.data(j,1) = 2;
            elseif AT(j,1) == 4;
                A.data(j,1) = 3;
            elseif AT(j,1) ==5;
                A.data(j,1) = 4;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 2;
            elseif AT(j,1) == 2;
                A.data(j,1) = 3;
            elseif AT(j,1)== 3;
                A.data(j,1) = 4;
            elseif AT(j,1)== 4;
                A.data(j,1) = 5;
            elseif AT(j,1)== 5;
                A.data(j,1) = 6;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1)== 3;
                A.data(j,1) = 5;
            elseif AT(j,1)== 4;
                A.data(j,1) = 6;
            elseif AT(j,1)== 5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 4;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        end
    elseif AN(j,1) == 2;
        if AL(j,1) == 1;
            if AT(j,1) == 1;
                A.data(j,1) = 1;
            elseif AT(j,1) == 2;
                A.data(j,1) = 3;
            elseif AT(j,1) == 3;
                A.data(j,1) = 4;
            elseif AT(j,1) == 4;
                A.data(j,1) = 5;
            elseif AT(j,1) ==5;
                A.data(j,1) = 6;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 2;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1)== 3;
                A.data(j,1) = 5;
            elseif AT(j,1)== 4;
                A.data(j,1) = 6;
            elseif AT(j,1)== 5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 4;
            elseif AT(j,1) == 2;
                A.data(j,1) = 6;
            elseif AT(j,1)== 3;
                A.data(j,1) = 7;
            elseif AT(j,1)== 4;
                A.data(j,1) = 8;
            elseif AT(j,1)== 5;
                A.data(j,1) = 9;
            end
        end
    elseif AN(j,1) == 3;
        if AL(j,1) == 1;
            if AL(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1) == 3;
                A.data(j,1) = 5;
            elseif AT(j,1) == 4;
                A.data(j,1) = 6;
            elseif AT(j,1) ==5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 5;
            elseif AT(j,1) == 2;
                A.data(j,1) = 6;
            elseif AT(j,1)== 3;
                A.data(j,1) = 7;
            elseif AT(j,1)== 4;
                A.data(j,1) = 8;
            elseif AT(j,1)== 5;
                A.data(j,1) = 9;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 6;
            elseif AT(j,1) == 2;
                A.data(j,1) = 7;
            elseif AT(j,1)== 3;
                A.data(j,1) = 8;
            elseif AT(j,1)== 4;
                A.data(j,1) = 9;
            elseif AT(j,1)== 5;   
                A.data(j,1) = 9;
            end
        end
    end    
end                


%% Adding Force/Load score & Calculations of Score a

disp(' =========================================== Enter Load/Force Involved ============================================ ')
disp(' For example if Load/Force Involved is 14 lbs, then enter 14 as input' )
Load = input('Enter Load/Force involved in object manipulation (in lbs) = ');
Scorea = [];
m = size(A.data);
for k = 1:m;
    if Load < 11;
        Scorea.data(k,1) = A.data(k,1) + 0;
    elseif 11 <= Load && Load < 22;
        Scorea.data(k,1) = A.data(k,1) + 1;
    elseif Load >= 22;
        Scorea.data(k,1) = A.data(k,1) + 2;
    end 
end


%% Adding Force_Load adjustment

disp(' ============================================ Enter Load/Force Adjustment ========================================= ')
disp(' If shock or rapid built up of force is involved during object manipulation then: Load_Force_Adjustment = 1 ')
disp(' If above is NOT the case then: Load_Force_Adjustment = 0 ')
Load_Force_Adjusment = input('Enter Load_Force_Adjustment = ');

ScoreA = [];
m = size(Scorea.data);
for k = 1:m;
    if Load_Force_Adjusment == 0;
        ScoreA.data(k,1) = Scorea.data(k,1) + 0;
    elseif Load_Force_Adjusment == 1;
        ScoreA.data(k,1) = Scorea.data(k,1) + 1;
    end 
end


%% Plotting the ScoreA Score wrt Frame Number
% m = size(ScoreA.data);
% x = 1:m;
% y = ScoreA.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of ScoreA vs Frame Number')
% xlabel('Frame Number')
% ylabel('ScoreA')



%%================================================================================================================
%%================================================================================================================
%% UPPER ARM SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% Bu is the upper hand score
% d is the input mocap data structure
% bu is notmal to the plane at shoulders (u for upper hand)
% [9 15] is the pair of the markers which defines normal to the plane(ie b)

bu = mcgetmarker(d, [9 15]);
bux = bu.data(:,4) - bu.data(:,1);
buy = bu.data(:,5) - bu.data(:,2);
buz = bu.data(:,6) - bu.data(:,3);

%% Upper hand Angle Calculations wrt spine (trunk)

% H1 represents the trunk bone 
% [2 7] is the set of the markers which defines the trunk bone
H1 = mcgetmarker(d, [2 7]);
H1x = H1.data(:,4) - H1.data(:,1);
H1y = H1.data(:,5) - H1.data(:,2);
H1z = H1.data(:,6) - H1.data(:,3);

% calculating the projections
% aH1 is the projection of the trunk bone on to the plane defined by b
aH1 = [];
aH1x = buy.*(H1x.*buy-bux.*H1y) - buz.*(H1z.*bux-buz.*H1x);
aH1y = buz.*(H1y.*buz-buy.*H1z) - bux.*(H1x.*buy-bux.*H1y);
aH1z = bux.*(H1z.*bux-buz.*H1x) - buy.*(H1y.*buz-buy.*H1z);
aH1.data = [aH1x aH1y aH1z];
% calculating the norm of the projecttions
% norm_aH1 represents the norm of the projections
norm_aH1 = [];
norm_aH1.data = [sqrt(aH1x.*aH1x + aH1y.*aH1y + aH1z.*aH1z)];
% calcualting normalized projections
% aH1N represents the normalized projections
aH1N = [];
aH1N.data = [aH1x./(norm_aH1.data) aH1y./(norm_aH1.data) aH1z./(norm_aH1.data)];


% H2 represents the upper hand bone
% [9 10] is the set of the markers which defines the upper hand bone
H2 = mcgetmarker(d, [9 10]);
H2x = H2.data(:,4) - H2.data(:,1);
H2y = H2.data(:,5) - H2.data(:,2);
H2z = H2.data(:,6) - H2.data(:,3);

% calculating the projections
% aH2 is the projection of the upper hand bone on to the plane defined by b
aH2 = [];
aH2x = buy.*(H2x.*buy-bux.*H2y) - buz.*(H2z.*bux-buz.*H2x);
aH2y = buz.*(H2y.*buz-buy.*H2z) - bux.*(H2x.*buy-bux.*H2y);
aH2z = bux.*(H2z.*bux-buz.*H2x) - buy.*(H2y.*buz-buy.*H2z);
aH2.data = [aH2x aH2y aH2z];

% calculating the norm of the projecttions
% norm_aH2 represents the norm of the projections
norm_aH2 = [];
norm_aH2.data = [sqrt(aH2x.*aH2x + aH2y.*aH2y + aH2z.*aH2z)];
% calcualting normalized projections
% aH2N represents the normalized projections
aH2N = [];
aH2N.data = [aH2x./(norm_aH2.data) aH2y./(norm_aH2.data) aH2z./(norm_aH2.data)];

% calculating the angle between trunk and upper hand bone using normalized projections
% BH represents the angle between trunk and upper hand
BH = [];
BH.data = [180-radtodeg(acos((aH1N.data(:,1)).*(aH2N.data(:,1)) + (aH1N.data(:,2)).*(aH2N.data(:,2)) + (aH1N.data(:,3)).*(aH2N.data(:,3))))];

%% Upper Hand Score Calculations
n = size(BH.data);
Bu1 = [];
theta = BH.data;
for i = 1:n;
    if theta(i,1) <= 20;
        Bu1.data(i,1) = 1;
    elseif 20 < theta(i,1) && theta(i,1) <= 45;
        Bu1.data(i,1) = 2;
    elseif 45 < theta(i,1) && theta(i,1) <= 90;
        Bu1.data(i,1) = 3;
    elseif 90 < theta(i,1) && theta(i,1) <= 180;
        Bu1.data(i,1) = 4;
    end
end

%% =========================================== Adjustment 1: If shoulder is raised: +1 ========================================================
% Can not be extracted from the available data


%% =========================================== Adjustment 2: If arm is abducted: +1 ===========================================================

% Defining the plane using both the shoulders and pelvis joint
% [1 9 15] is the set of markers which define the required plane
% n is the matrix containing the locations of the markers 1 & 9
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

%% Upper hand Angle Abduction Calculations wrt spine (trunk)

% H1 represents the trunk bone as defined above
% [2 7] is the set of the markers which defines the trunk bone
% calculating the projections on plane defined by normal n
% bH1 is the projection of the trunk bone on to the plane defined by n
bH1 = [];
bH1x = ny.*(H1x.*ny-nx.*H1y) - nz.*(H1z.*nx-nz.*H1x);
bH1y = nz.*(H1y.*nz-ny.*H1z) - nx.*(H1x.*ny-nx.*H1y);
bH1z = nx.*(H1z.*nx-nz.*H1x) - ny.*(H1y.*nz-ny.*H1z);
bH1.data = [bH1x bH1y bH1z];

% calculating the norm of the projecttions
% norm_bH1 represents the norm of the projections
norm_bH1 = [];
norm_bH1.data = [sqrt(bH1x.*bH1x + bH1y.*bH1y + bH1z.*bH1z)];
% calcualting normalized projections
% bH1N represents the normalized projections
bH1N = [];
bH1N.data = [bH1x./(norm_bH1.data) bH1y./(norm_bH1.data) bH1z./(norm_bH1.data)];


% H2 represents the upper hand bone as defined above
% [9 10] is the set of the markers which defines the upper hand bone
% calculating the projections
% bH2 is the projection of the upper hand bone on to the plane defined by n
bH2 = [];
bH2x = ny.*(H2x.*ny-nx.*H2y) - nz.*(H2z.*nx-nz.*H2x);
bH2y = nz.*(H2y.*nz-ny.*H2z) - nx.*(H2x.*ny-nx.*H2y);
bH2z = nx.*(H2z.*nx-nz.*H2x) - ny.*(H2y.*nz-ny.*H2z);
bH2.data = [bH2x bH2y bH2z];

% calculating the norm of the projecttions
% norm_bH2 represents the norm of the projections on the plane defined by n
norm_bH2 = [];
norm_bH2.data = [sqrt(bH2x.*bH2x + bH2y.*bH2y + bH2z.*bH2z)];
% calcualting normalized projections
% bH2N represents the normalized projections
bH2N = [];
bH2N.data = [bH2x./(norm_bH2.data) bH2y./(norm_bH2.data) bH2z./(norm_bH2.data)];

% calculating the angle between trunk and upper hand bone using normalized projections
% bh represents the angle between trunk and upper hand on plane defined by
% n
bh = [];
bh.data = [180-radtodeg(acos((bH1N.data(:,1)).*(bH2N.data(:,1)) + (bH1N.data(:,2)).*(bH2N.data(:,2)) + (bH1N.data(:,3)).*(bH2N.data(:,3))))];


%% Upper Hand Score Calculations (With Adjustment: If upper arm is abducted)
% Threshold angle is to be determined (currently take as 20 degrees)
n = size(bh.data);
Bu2 = [];
thetabh = bh.data;
for i = 1:n;
    if thetabh(i,1) < 20;
        Bu2.data(i,1) = Bu1.data(i,1) + 0;
    elseif thetabh(i,1) >= 20;
        Bu2.data(i,1) = Bu1.data(i,1) + 1;
    end
end


%% =================================== Adjustment 3: If arm is supported or the person is leaning: -1 ================================

disp( ' ============================= Adjustment: If upper arm/hand is supported or the person is leaning ================================= ' );
disp( ' If upper arm is supported or the person is leaning: Enter Adjustment_Score = -1 ');
disp( ' Else: Enter Adjustment_Score = 0 ' );
Adjustment_Score = input('Enter Adjustment_Score = ');
Bu = [];
for i = 1:n;
    Bu.data(i,1) = Bu2.data(i,1) + Adjustment_Score;
end


%% Plotting the Upper Arm Score wrt Frame Number
% m = size(Bu.data);
% x = 1:m;
% y = Bu.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Upper Arm Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Upper Arm Score')



%%================================================================================================================
%%================================================================================================================
%% LOWER ARM SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================


% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% Bl is the lower hand score
% d is the input mocap data structure
% bu is notmal to the plane at shoulders (u for upper hand)
% [9 15] is the pair of the markers which defines normal to the plane(ie b)

bu = mcgetmarker(d, [9 15]);
bux = bu.data(:,4) - bu.data(:,1);
buy = bu.data(:,5) - bu.data(:,2);
buz = bu.data(:,6) - bu.data(:,3);

%% Lower hand Angle Calculations wrt Upper hand

% h1 represents the trunk bone 
% [10 11] is the set of the markers which defines the lower hand bone
h1 = mcgetmarker(d, [10 11]);
h1x = h1.data(:,4) - h1.data(:,1);
h1y = h1.data(:,5) - h1.data(:,2);
h1z = h1.data(:,6) - h1.data(:,3);

% calculating the projections
% ah1 is the projection of the lower hand bone on to the plane defined by b
ah1 = [];
ah1x = buy.*(h1x.*buy-bux.*h1y) - buz.*(h1z.*bux-buz.*h1x);
ah1y = buz.*(h1y.*buz-buy.*h1z) - bux.*(h1x.*buy-bux.*h1y);
ah1z = bux.*(h1z.*bux-buz.*h1x) - buy.*(h1y.*buz-buy.*h1z);
ah1.data = [ah1x ah1y ah1z];

% calculating the norm of the projecttions
% norm_ah1 represents the norm of the projections
norm_ah1 = [];
norm_ah1.data = [sqrt(ah1x.*ah1x + ah1y.*ah1y + ah1z.*ah1z)];
% calcualting normalized projections
% ah1N represents the normalized projections
ah1N = [];
ah1N.data = [ah1x./(norm_ah1.data) ah1y./(norm_ah1.data) ah1z./(norm_ah1.data)];


% h2 represents the upper hand bone
% [9 10] is the set of the markers which defines the upper hand bone
h2 = mcgetmarker(d, [9 10]);
h2x = h2.data(:,4) - h2.data(:,1);
h2y = h2.data(:,5) - h2.data(:,2);
h2z = h2.data(:,6) - h2.data(:,3);

% calculating the projections
% ah2 is the projection of the upper hand bone on to the plane defined by b
ah2 = [];
ah2x = buy.*(h2x.*buy-bux.*h2y) - buz.*(h2z.*bux-buz.*h2x);
ah2y = buz.*(h2y.*buz-buy.*h2z) - bux.*(h2x.*buy-bux.*h2y);
ah2z = bux.*(h2z.*bux-buz.*h2x) - buy.*(h2y.*buz-buy.*h2z);
ah2.data = [ah2x ah2y ah2z];

% calculating the norm of the projecttions
% norm_ah2 represents the norm of the projections
norm_ah2 = [];
norm_ah2.data = [sqrt(ah2x.*ah2x + ah2y.*ah2y + ah2z.*ah2z)];
% calcualting normalized projections
% ah2N represents the normalized projections
ah2N = [];
ah2N.data = [ah2x./(norm_ah2.data) ah2y./(norm_ah2.data) ah2z./(norm_ah2.data)];

% calculating the angle between trunk and upper hand bone using normalized projections
% Bh represents the angle between lower and upper hand
Bh = [];
Bh.data = [radtodeg(acos((ah1N.data(:,1)).*(ah2N.data(:,1)) + (ah1N.data(:,2)).*(ah2N.data(:,2)) + (ah1N.data(:,3)).*(ah2N.data(:,3))))];

%% Upper Hand Score Calculations
n = size(Bh.data);
Bl = [];
for i = 1:n;
    theta = Bh.data;
    if theta(i,1) < 60;
        Bl.data(i,1) = 2;
    elseif 60 <= theta(i,1) && theta(i,1)<= 100;
        Bl.data(i,1) = 1;
    elseif 100 < theta(i,1) && theta(i,1) <= 180;
        Bl.data(i,1) = 2;
    end
end

%% Plotting the Lower Arm Score wrt Frame Number
% m = size(Bl.data);
% x = 1:m;
% y = Bl.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Lower Arm Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Lower Arm Score')



%%================================================================================================================
%%================================================================================================================
%% WRIST SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% Bw is the wrist score
% d is the input mocap data structure

%% Defining normal to the plane
% bw is the plane defined by the normal as the cross product of lower hand
% and wrist bones

bw1 = mcgetmarker(d, [10 11]);
bw1x = bw1.data(:,4) - bw1.data(:,1);
bw1y = bw1.data(:,5) - bw1.data(:,2);
bw1z = bw1.data(:,6) - bw1.data(:,3);

bw2 = mcgetmarker(d, [11 12]);
bw2x = bw2.data(:,4) - bw2.data(:,1);
bw2y = bw2.data(:,5) - bw2.data(:,2);
bw2z = bw2.data(:,6) - bw2.data(:,3);

bw = [];
bwx = bw1y.*bw2z - bw2y.*bw1z;
bwy = bw1z.*bw2x - bw2z.*bw1x;
bwz = bw1x.*bw2z - bw2x.*bw1y;
bw.data = [bwx bwy bwz];

%% Wrist angle calculations wrt lower hand

% h1 represents the lower hand bone 
% [10 11] is the set of the markers which defines the lower hand bone
h1 = mcgetmarker(d, [10 11]);
h1x = h1.data(:,4) - h1.data(:,1);
h1y = h1.data(:,5) - h1.data(:,2);
h1z = h1.data(:,6) - h1.data(:,3);

% calculating the projections
% wh1 is the projection of the lower hand bone on to the plane defined by
% bw
wh1 = [];
wh1x = bwy.*(h1x.*bwy-bwx.*h1y) - bwz.*(h1z.*bwx-bwz.*h1x);
wh1y = bwz.*(h1y.*bwz-bwy.*h1z) - bwx.*(h1x.*bwy-bwx.*h1y);
wh1z = bwx.*(h1z.*bwx-bwz.*h1x) - bwy.*(h1y.*bwz-bwy.*h1z);
wh1.data = [wh1x wh1y wh1z];

% calculating the norm of the projecttions
% norm_ah1 represents the norm of the projections
norm_wh1 = [];
norm_wh1.data = [sqrt(wh1x.*wh1x + wh1y.*wh1y + wh1z.*wh1z)];

% calcualting normalized projections
% ah1N represents the normalized projections
wh1N = [];
wh1N.data = [wh1x./(norm_wh1.data) wh1y./(norm_wh1.data) wh1z./(norm_wh1.data)];

% w2 represents the wrist bone
% [11 12] is the set of the markers which defines the wrist bone
w2 = mcgetmarker(d, [11 12]);
w2x = w2.data(:,4) - w2.data(:,1);
w2y = w2.data(:,5) - w2.data(:,2);
w2z = w2.data(:,6) - w2.data(:,3);

% calculating the projections
% bw2 is the projection of the wrist bone on to the plane defined by bw
bw2 = [];
bw2x = bwy.*(w2x.*bwy-bwx.*w2y) - bwz.*(w2z.*bwx-bwz.*w2x);
bw2y = bwz.*(w2y.*bwz-bwy.*w2z) - bwx.*(w2x.*bwy-bwx.*w2y);
bw2z = bwx.*(w2z.*bwx-bwz.*w2x) - bwy.*(w2y.*bwz-bwy.*w2z);
bw2.data = [bw2x bw2y bw2z];

% calculating the norm of the projecttions
% norm_bw2 represents the norm of the projections
norm_bw2 = [];
norm_bw2.data = [sqrt(bw2x.*bw2x + bw2y.*bw2y + bw2z.*bw2z)];

% calcualting normalized projections
% bw2N represents the normalized projections
bw2N = [];
bw2N.data = [bw2x./(norm_bw2.data) bw2y./(norm_bw2.data) bw2z./(norm_bw2.data)];

% calculating the wrist bent angle using normalized projections
% BW represents the bent angle of wrist 
BW1 = [];
BW1.data = [radtodeg(acos((wh1N.data(:,1)).*(bw2N.data(:,1)) + (wh1N.data(:,2)).*(bw2N.data(:,2)) + (wh1N.data(:,3)).*(bw2N.data(:,3))))];

%% Wrist Score Calculations
n = size(BW1.data);
Bw1 = [];
for i = 1:n;
    theta = BW1.data;
    if theta(i,1) < 15;
        Bw1.data(i,1) = 1;
    elseif theta(i,1) >= 15;
        Bw1.data(i,1) = 2;
    end
end

%% Adjustment: If wrist is bent from midline or twisted: +1 ===============================================================================

% defining normal to the plane
% bu is notmal to the plane at shoulders (u for upper hand)
% [9 15] is the pair of the markers which defines normal to the plane(ie bu)
bu = mcgetmarker(d, [9 15]);
bux = bu.data(:,4) - bu.data(:,1);
buy = bu.data(:,5) - bu.data(:,2);
buz = bu.data(:,6) - bu.data(:,3);

%% Wrist bent Angle Calculations 

% h1 represents the lower hand bone 
% [10 11] is the set of the markers which defines the lower hand bone
h1 = mcgetmarker(d, [10 11]);
h1x = h1.data(:,4) - h1.data(:,1);
h1y = h1.data(:,5) - h1.data(:,2);
h1z = h1.data(:,6) - h1.data(:,3);

% calculating the projections
% ah1 is the projection of the lower hand bone on to the plane defined by b
ah1 = [];
ah1x = buy.*(h1x.*buy-bux.*h1y) - buz.*(h1z.*bux-buz.*h1x);
ah1y = buz.*(h1y.*buz-buy.*h1z) - bux.*(h1x.*buy-bux.*h1y);
ah1z = bux.*(h1z.*bux-buz.*h1x) - buy.*(h1y.*buz-buy.*h1z);
ah1.data = [ah1x ah1y ah1z];

% calculating the norm of the projecttions
% norm_ah1 represents the norm of the projections
norm_ah1 = [];
norm_ah1.data = [sqrt(ah1x.*ah1x + ah1y.*ah1y + ah1z.*ah1z)];

% calcualting normalized projections
% ah1N represents the normalized projections
ah1N = [];
ah1N.data = [ah1x./(norm_ah1.data) ah1y./(norm_ah1.data) ah1z./(norm_ah1.data)];


% w2 represents the wrist bone
% [11 12] is the set of the markers which defines the wrist bone
w2 = mcgetmarker(d, [11 12]);
w2x = w2.data(:,4) - w2.data(:,1);
w2y = w2.data(:,5) - w2.data(:,2);
w2z = w2.data(:,6) - w2.data(:,3);

% calculating the projections
% aw2 is the projection of the wrist bone on to the plane defined by b
aw2 = [];
aw2x = buy.*(w2x.*buy-bux.*w2y) - buz.*(w2z.*bux-buz.*w2x);
aw2y = buz.*(w2y.*buz-buy.*w2z) - bux.*(w2x.*buy-bux.*w2y);
aw2z = bux.*(w2z.*bux-buz.*w2x) - buy.*(w2y.*buz-buy.*w2z);
aw2.data = [aw2x aw2y aw2z];

% calculating the norm of the projecttions
% norm_aw2 represents the norm of the projections
norm_aw2 = [];
norm_aw2.data = [sqrt(aw2x.*aw2x + aw2y.*aw2y + aw2z.*aw2z)];

% calcualting normalized projections
% aw2N represents the normalized projections
aw2N = [];
aw2N.data = [aw2x./(norm_aw2.data) aw2y./(norm_aw2.data) aw2z./(norm_aw2.data)];

% calculating the wrist bent angle using normalized projections
% BW represents the bent angle of wrist 
BW = [];
BW.data = [radtodeg(acos((ah1N.data(:,1)).*(aw2N.data(:,1)) + (ah1N.data(:,2)).*(aw2N.data(:,2)) + (ah1N.data(:,3)).*(aw2N.data(:,3))))];

%% Wrist bent (with adjustment) Score Calculations = Final Wrist Score
% Threshold wrist bent angle has to be deteemined (currently taken as 1
% degree)
n = size(BW.data);
Bw = [];
for i = 1:n;
    theta = BW.data;
    if theta(i,1) < 1;
        Bw.data(i,1) = Bw1.data(i,1) + 0;
    elseif theta(i,1) >= 1;
        Bw.data(i,1) = Bw1.data(i,1) + 1;
    end
end

%% Plotting the Wrist Score wrt Frame Number
% m = size(Bw.data);
% x = 1:m;
% y = Bw.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of Wrist Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('Wrist Score')


%%================================================================================================================
%%================================================================================================================
%% TABLE B SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================
% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% d is mocap data structure
% n is number of frames
% Bl is matrix containing lower arm Scores
% Bw is matrix containing wrist Scores
% Bu is matrix containing upper arm Scores
% B is risk Score from table B

%% Calculations for Table B

B = [];
n = size(Bl.data);
BU  =Bu.data;
BL = Bl.data;
BW = Bw.data;

for j = 1:n;
    if BL(j,1) == 1;
        if BW(j,1) == 1;
            if BU(j,1) == 1;
                B.data(j,1)  = 1;
            elseif BU(j,1) == 2;
                B.data(j,1) = 1;
            elseif BU(j,1) == 3;
                B.data(j,1) = 3;
            elseif BU(j,1) == 4;
                B.data(j,1) = 4;
            elseif BU(j,1) == 5;
                B.data(j,1) = 6;
            elseif BU(j,1) == 6;
                B.data(j,1) = 7;
            end   
        elseif BW(j,1) == 2;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 2;
            elseif BU(j,1) == 3;
                B.data(j,1) = 4;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 7;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end    
        elseif BW(j,1) == 3;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 3;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end    
        end  
    elseif BL(j,1) == 2;
        if BW(j,1) == 1;
            if BU(j,1) == 1;
                B.data(j,1)  = 1;
            elseif BU(j,1) == 2;
                B.data(j,1) = 2;
            elseif BU(j,1) == 3;
                B.data(j,1) = 4;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 7;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end   
        elseif BW(j,1) == 2;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 3;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 6;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 9;
            end    
        elseif BW(j,1) == 3;
            if BU(j,1) == 1;
                B.data(j,1)  = 3;
            elseif BU(j,1) == 2;
                B.data(j,1) = 4;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 7;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 9;
            end    
        end    
    end
end


%% Adding Coupling score and Calculations of Score B

disp('  ============================================= Enter Coupling Score ============================================')
disp( 'For well fitting handle nd mid range power grip: Coupling Score = 0')
disp( 'For acceptable but not ideal hand hold grip: Coupling Score = 1')
disp( 'For hand hold not acceptable but possible: Coupling Score = 2')
disp( 'For no handles, awkward, unsafe with any body part: Coupling Score = 3')

Coupling_Score = input('Enter Coupling Score = ');
ScoreB = [];
m = size(B.data);
for k = 1:m;
    if Coupling_Score == 0;
        ScoreB.data(k,1) = B.data(k,1) + 0;
    elseif Coupling_Score == 1;
        ScoreB.data(k,1) = B.data(k,1) + 1;
    elseif Coupling_Score == 2;
        ScoreB.data(k,1) = B.data(k,1) + 2;
    elseif Coupling_Score == 3;
        ScoreB.data(k,1) = B.data(k,1) + 3;
    end 
end
                       
%% Plotting the ScoreB wrt Frame Number
% m = size(ScoreB.data);
% x = 1:m;
% y = ScoreB.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of ScoreB vs Frame Number')
% xlabel('Frame Number')
% ylabel('ScoreB')  



%%================================================================================================================
%%================================================================================================================
%% FINAL REBA SCORE CALCULATIONS
%%================================================================================================================
%%================================================================================================================


% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% RebaScore is the matrix containg final REBA Socres
% ScoreA represents group A score
% ScoreB represents group B score
% d is mocap data structure
% n is number of frames

%% Calculations for Table C

C = [];
n = size(ScoreA.data);
SA = ScoreA.data;
SB = ScoreB.data;

for j = 1:n;
    if SB(j,1) == 1;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 1;
        elseif SA(j,1) == 3;
            C.data(j,1) = 2;
        elseif SA(j,1) == 4;
            C.data(j,1) = 3;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 2;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 2;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 3;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 2;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 4;
        if SA(j,1) == 1;
            C.data(j,1) = 2;
        elseif SA(j,1) == 2;
            C.data(j,1) = 3;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 5;
        elseif SA(j,1) == 6;
            C.data(j,1) = 7;
        elseif SA(j,1) == 7;
            C.data(j,1) = 8;
        elseif SA(j,1) == 8;
            C.data(j,1) = 9;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 5;
        if SA(j,1) == 1;
            C.data(j,1) = 3;
        elseif SA(j,1) == 2;
            C.data(j,1) = 4;
        elseif SA(j,1) == 3;
            C.data(j,1) = 4;
        elseif SA(j,1) == 4;
            C.data(j,1) = 5;
        elseif SA(j,1) == 5;
            C.data(j,1) = 6;
        elseif SA(j,1) == 6;
            C.data(j,1) = 8;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 6;
        if SA(j,1) == 1;
            C.data(j,1) = 3;
        elseif SA(j,1) == 2;
            C.data(j,1) = 4;
        elseif SA(j,1) == 3;
            C.data(j,1) = 5;
        elseif SA(j,1) == 4;
            C.data(j,1) = 6;
        elseif SA(j,1) == 5;
            C.data(j,1) = 7;
        elseif SA(j,1) == 6;
            C.data(j,1) = 8;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 7;
        if SA(j,1) == 1;
            C.data(j,1) = 4;
        elseif SA(j,1) == 2;
            C.data(j,1) = 5;
        elseif SA(j,1) == 3;
            C.data(j,1) = 6;
        elseif SA(j,1) == 4;
            C.data(j,1) = 7;
        elseif SA(j,1) == 5;
            C.data(j,1) = 8;
        elseif SA(j,1) == 6;
            C.data(j,1) = 9;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 8;
        if SA(j,1) == 1;
            C.data(j,1) = 5;
        elseif SA(j,1) == 2;
            C.data(j,1) = 6;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 8;
        elseif SA(j,1) == 5;
            C.data(j,1) = 8;
        elseif SA(j,1) == 6;
            C.data(j,1) = 9;
        elseif SA(j,1) == 7;
            C.data(j,1) = 10;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 9;
        if SA(j,1) == 1;
            C.data(j,1) = 6;
        elseif SA(j,1) == 2;
            C.data(j,1) = 6;
        elseif SA(j,1) == 3;
            C.data(j,1) = 7;
        elseif SA(j,1) == 4;
            C.data(j,1) = 8;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 10;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 10;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 7;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 11;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 7;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 12;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 8;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    end
end    


%% Adding Activity score and Calculating the Final REBA Score

disp('  ======================================== Enter Activity Score =====================================')
disp( 'Final Activity score = (Activity Score a + Activity Score b + Acivity Score c)')  
disp( 'For one of more body parts are held for longer than 1 minute: Activity Score a = 1')
disp( 'For repeated small range actions (more than 4x per minute): Activity Score b = 1')
disp( 'For actions causing rapid arge range changes in posture or unstable base: Activity Score c = 1')
disp( 'If any of above a, b, c activity is NOT happening then add 0 for that Activity Score')

Activity_Score = input('Enter Final Activity Score = ');
REBAScore = [];
m = size(C.data);
for k = 1:m;
    if Activity_Score == 0;
        REBAScore.data(k,1) = C.data(k,1) + 0;
    elseif Activity_Score == 1;
        REBAScore.data(k,1) = C.data(k,1) + 1;
    elseif Activity_Score == 2;
        REBAScore.data(k,1) = C.data(k,1) + 2;
    elseif Activity_Score == 3;
        REBAScore.data(k,1) = C.data(k,1) + 3;
    end 
end


%% Plotting the REBA Score wrt Frame Number

% x = 1:m;
% y = REBAScore.data;
% figure
% plot(x,y,'r');
% ylim([0 15]);
% title('Plot of REBA Score vs Frame Number')
% xlabel('Frame Number')
% ylabel('REBA Score')




