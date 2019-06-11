function joang = jointAnglesOnly(jo)
% position is a snapshot of skeleton position, of appropriate dimensions
% modifications is a vector of the mods to REBA that are necessary (ex:
% handles, weight, repetition, etc.

% note: /data/*0 is the validation run with many different arm positions

% zeroThresh = 2; % general threshold for "zero" cutoff as human percieves it
% binaryThresh = 10; % temp value, determine this experimentally
% abductThresh = 10; % also a temp value, determine from validation set
% maxTrunkThresh = 85; % more than this and the person will fall, something's wrong
% 
% coupling = modifications(1); % assume handles
% loading = modifications(2);
% shock = modifications(3);
% activityscore = modifications(4);

elbowThresh = 30;

%% Trunk Score
% main: trunk bending
hipVec = jo.HipRight - jo.HipLeft;
femurVec = jo.AnkleRight - jo.HipRight; % assume standing, so hips must be approx above ankles
trunkVec = jo.SpineBase - jo.SpineMid;
joang.trunkBend = projectedAngle(trunkVec,femurVec,hipVec);

% adjustment 1: trunk twisting y/n
shoulderVec = jo.ShoulderRight - jo.ShoulderLeft;
joang.trunkTwist = projectedAngle(hipVec,shoulderVec,trunkVec);

% adjustment 2: side bending y/n
joang.trunkSideBend = 0;

%% Neck Score
% main 1: neck bending forward (in plane defined by shoulders)
upperBackVec = jo.SpineMid - jo.SpineShoulder;
neckVec = jo.SpineShoulder - jo.Head;
joang.neckBend = projectedAngle(upperBackVec,neckVec,shoulderVec);


% main 2: neck bending side
joang.neckBendSide = projectedAngle(upperBackVec,neckVec,jo.ChestNormal);

%% Leg Score - Left (nb: modified, bending is in plane of ankle not hip)
femurVecLeft = jo.HipLeft - jo.KneeLeft;
shinVecLeft = jo.KneeLeft - jo.AnkleLeft;
anklePlaneLeft = cross(jo.AnkleLeft - jo.FootLeft,shinVecLeft);
joang.kneeBendLeft = projectedAngle(femurVecLeft,shinVecLeft,anklePlaneLeft);

%% Leg Score - Right
femurVecRight = jo.HipRight - jo.KneeRight;
shinVecRight = jo.KneeRight - jo.AnkleRight;
anklePlaneRight = cross(jo.AnkleRight - jo.FootRight,shinVecRight);
joang.kneeBendRight = projectedAngle(femurVecRight,shinVecRight,anklePlaneRight);


%% Arm - Left (note, this needs more work to extract the fully-raised-arms case)
bicepVecLeft = jo.ShoulderLeft - jo.ElbowLeft;
% generate an if-case using atan2 to determine if in upper right quadrant?
joang.shoulderRotateLeft = projectedAngle(-1*bicepVecLeft,upperBackVec,shoulderVec); % check this for negatives
joang.shoulderAbductLeft = projectedAngle(-1*bicepVecLeft,upperBackVec,jo.ChestNormal);

% elbow
forearmVecLeft = jo.ElbowLeft - jo.WristLeft;
elbowPlaneLeft = cross(bicepVecLeft,forearmVecLeft);
joang.elbowBendLeft = projectedAngle(bicepVecLeft,forearmVecLeft,elbowPlaneLeft);

if joang.elbowBendLeft > elbowThresh %  plane is probably extractable)
    joang.shoulderIntRotateLeft = acosd(abs(dot(elbowPlaneLeft,[0 1 0]))/(norm(elbowPlaneLeft)));
else
    joang.shoulderIntRotateLeft = [];
end

joang.shoulderHorizAbductLeft = projectedAngle(bicepVecLeft,shoulderVec,upperBackVec);

%% Arm - Right
bicepVecRight = jo.ShoulderRight - jo.ElbowRight;
joang.shoulderRotateRight = projectedAngle(bicepVecRight,-1*upperBackVec,shoulderVec);
joang.shoulderAbductRight = projectedAngle(bicepVecRight,-1*upperBackVec,jo.ChestNormal);

% elbow
forearmVecRight = jo.ElbowRight - jo.WristRight;
elbowPlaneRight = cross(bicepVecRight,forearmVecRight);
joang.elbowBendRight = projectedAngle(bicepVecRight,forearmVecRight,elbowPlaneRight);

if joang.elbowBendRight > elbowThresh %  plane is probably extractable)
    %joang.shoulderIntRotateRight = acosd(abs(dot(elbowPlaneRight,[0 1 0]))/(norm(elbowPlaneRight)));
    joang.shoulderIntRotateRight = projectedAngle(elbowPlaneRight,[0 0 1],[0 1 0]);
%     if joang.shoulderIntRotateRight < 10
%         joang.shoulderIntRotateRight = [];
%     end
else
    joang.shoulderIntRotateRight = [];
end
joang.shoulderHorizAbductRight = projectedAngle(bicepVecRight,-1*shoulderVec,upperBackVec);

end



