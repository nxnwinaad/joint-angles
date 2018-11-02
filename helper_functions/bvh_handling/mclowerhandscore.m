function Bl = mclowerhandscore()
d = mcread;

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
m = size(Bl.data);
x = 1:m;
y = Bl.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of Lower Arm Score vs Frame Number')
xlabel('Frame Number')
ylabel('Lower Arm Score')



