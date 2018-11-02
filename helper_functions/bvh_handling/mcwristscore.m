function Bw = mcwristscore()
d = mcread;

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
m = size(Bw.data);
x = 1:m;
y = Bw.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Wrist Score vs Frame Number')
xlabel('Frame Number')
ylabel('Wrist Score')

