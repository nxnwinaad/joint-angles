function An = mcneckscore()
d = mcread;

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
m = size(An.data);
x = 1:m;
y = An.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Neck Score vs Frame Number')
xlabel('Frame Number')
ylabel('Neck Score')



