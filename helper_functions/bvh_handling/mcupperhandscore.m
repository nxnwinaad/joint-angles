function Bu = mcupperhandscore()
d = mcread;

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
m = size(Bu.data);
x = 1:m;
y = Bu.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Upper Arm Score vs Frame Number')
xlabel('Frame Number')
ylabel('Upper Arm Score')






