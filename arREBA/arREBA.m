function REBAscore = arREBA(jo,modifications)
% position is a snapshot of skeleton position, of appropriate dimensions
% modifications is a vector of the mods to REBA that are necessary (ex:
% handles, weight, repetition, etc.

% note: /data/*0 is the validation run with many different arm positions

zeroThresh = 2; % general threshold for "zero" cutoff as human percieves it
binaryThresh = 10; % temp value, determine this experimentally
abductThresh = 10; % also a temp value, determine from validation set
maxTrunkThresh = 85; % more than this and the person will fall, something's wrong

coupling = modifications(1); % assume handles
loading = modifications(2);
shock = modifications(3);
activityscore = modifications(4);

[A,B,C] = generateREBAtables();

% MAJOR ASSUMPTIONS: 
% 1. Standing
% 2. Bilateral weight-bearing

% REMIANING UNKNOWNS
% 1. Shoulder raised
% 2. Weight of object (loading)
% 3. Neck twist
% 4. Stability of posture
% 5. Shock
% 6. Handles (coupling score)


%% Trunk Score
% main: trunk bending
hipVec = jo.HipRight - jo.HipLeft;
femurVec = jo.AnkleRight - jo.HipRight; % assume standing, so hips must be approx above ankles
trunkVec = jo.SpineBase - jo.SpineMid;
trunkBend = projectedAngle(trunkVec,femurVec,hipVec);

if (trunkBend) < zeroThresh && trunkBend > -1*zeroThresh
    score.trunk = 1;
elseif (trunkBend > zeroThresh && trunkBend < 20) || (trunkBend < -1*zeroThresh)
    score.trunk = 2;
elseif trunkBend > 20 && trunkBend < 60
    score.trunk = 3;
elseif trunkBend > 60 && trunkBend < maxTrunkThresh
    score.trunk = 4;
else
    score.trunk = 1; % something's gone wrong, ignore the trunk value
end

% adjustment 1: trunk twisting y/n
shoulderVec = jo.ShoulderRight - jo.ShoulderLeft;
trunkTwist = projectedAngle(hipVec,shoulderVec,trunkVec);

if trunkTwist > binaryThresh
    score.trunk = score.trunk + 1;
end

% adjustment 2: side bending y/n
% use modifications vector for this, for now set to zero
% correction: use projection into the chest plane for this
trunkSideBend = 0;
if trunkSideBend > binaryThresh
    score.trunk = score.trunk + 1;
end

%% Neck Score
% main 1: neck bending forward (in plane defined by shoulders)
upperBackVec = jo.SpineMid - jo.SpineShoulder;
neckVec = jo.SpineShoulder - jo.Head;
neckBend = projectedAngle(upperBackVec,neckVec,shoulderVec);

if neckBend >= 0 && neckBend >= 20
    score.neck = 1;
elseif neckBend < 20 || neckBend < (0-zeroThresh)
    score.neck = 2;
end

% main 2: neck bending side
neckBendSide = projectedAngle(upperBackVec,neckVec,jo.ChestNormal);
if(neckBendSide > binaryThresh)
    score.neck = score.neck + 1;
end

% main 3: neck twist
% not accessible with available data, see score modifications vector TK
neckTwist = 0;
if(neckTwist > binaryThresh)
    score.neck = score.neck + 1;
end

 

%% Leg Score - Left (nb: modified, bending is in plane of ankle not hip)
femurVecLeft = jo.HipLeft - jo.KneeLeft;
shinVecLeft = jo.KneeLeft - jo.AnkleLeft;
anklePlaneLeft = cross(jo.AnkleLeft - jo.FootLeft,shinVecLeft);
kneeBendLeft = projectedAngle(femurVecLeft,shinVecLeft,anklePlaneLeft);

if kneeBendLeft <= 30
    legModLeft = 0;
elseif kneeBendLeft > 30 && kneeBendLeft <= 60
    legModLeft = 1;
elseif kneeBendLeft > 60
    legModLeft = 2;
end

%% Leg Score - Right
femurVecRight = jo.HipRight - jo.KneeRight;
shinVecRight = jo.KneeRight - jo.AnkleRight;
anklePlaneRight = cross(jo.AnkleRight - jo.FootRight,shinVecRight);
kneeBendRight = projectedAngle(femurVecRight,shinVecRight,anklePlaneRight);

if kneeBendRight <= 30
    legModRight = 0;
elseif kneeBendRight > 30 && kneeBendRight <= 60
    legModRight = 1;
elseif kneeBendRight > 60
    legModRight = 2;
end
%% Overall Leg Score: pick the highest for conservative assumptions
% assumption: always bilateral weight bearing
score.leg = 1;

% modify with worst leg
score.leg = score.leg + max(legModRight,legModLeft);

tableAscore = A(score.trunk, score.leg, score.neck);
tableAscore = tableAscore + loading + shock;

%% Arm - Left (note, this needs more work to extract the fully-raised-arms case)
bicepVecLeft = jo.ShoulderLeft - jo.ElbowLeft;
% generate an if-case using atan2 to determine if in upper right quadrant?
shoulderRotateLeft = projectedAngle(-1*bicepVecLeft,upperBackVec,shoulderVec); % check this for negatives
shoulderAbductLeft = projectedAngle(-1*bicepVecLeft,upperBackVec,jo.ChestNormal);
if abs(shoulderRotateLeft) <= 20
    shouldLeft = 1;
elseif shoulderRotateLeft < -20 || (shoulderRotateLeft > 20 && shoulderRotateLeft <= 45)
    shouldLeft = 2;
elseif (shoulderRotateLeft > 45 && shoulderRotateLeft <= 90)
    shouldLeft = 3;
else
    shouldLeft = 4;
end

if shoulderAbductLeft > abductThresh
    shouldLeft = shouldLeft + 1;
end

% elbow
forearmVecLeft = jo.ElbowLeft - jo.WristLeft;
elbowPlaneLeft = cross(bicepVecLeft,forearmVecLeft);
elbowBendLeft = projectedAngle(bicepVecLeft,forearmVecLeft,elbowPlaneLeft);
if elbowBendLeft < 100 && elbowBendLeft > 60
    lowArmLeft = 1;
else
    lowArmLeft = 2;
end

% wrist
handVecLeft = jo.WristLeft - jo.HandTipLeft;
wristBendLeft = projectedAngle(forearmVecLeft,-1*handVecLeft,elbowPlaneLeft);
wristTwistLeft = acosd(dot(forearmVecLeft,handVecLeft)) - wristBendLeft; % measures overall deviation?
if abs(wristBendLeft) < 15
    wristLeft = 1;
else
    wristLeft = 2;
end
if abs(wristTwistLeft) > binaryThresh
    wristLeft = wristLeft + 1;
end

% total 
armScoreLeft = B(shouldLeft, wristLeft, lowArmLeft);

%% Arm - Right
bicepVecRight = jo.ShoulderRight - jo.ElbowRight;
shoulderRotateRight = projectedAngle(-1*bicepVecRight,upperBackVec,shoulderVec);
shoulderAbductRight = projectedAngle(bicepVecRight,upperBackVec,jo.ChestNormal);
if abs(shoulderRotateRight) <= 20
    shouldRight = 1;
elseif shoulderRotateRight < -20 || (shoulderRotateRight > 20 && shoulderRotateRight <= 45)
    shouldRight = 2;
elseif (shoulderRotateRight > 45 && shoulderRotateRight < 90)
    shouldRight = 3;
else
    shouldRight = 4;
end

if shoulderAbductRight > abductThresh
    shouldRight = shouldRight + 1;
end

% elbow
forearmVecRight = jo.ElbowRight - jo.WristRight;
elbowPlaneRight = cross(bicepVecRight,forearmVecRight);
elbowBendRight = projectedAngle(bicepVecRight,forearmVecRight,elbowPlaneRight);
if elbowBendRight < 100 && elbowBendRight > 60
    lowArmRight = 1;
else
    lowArmRight = 2;
end

% wrist
handVecRight = jo.WristRight - jo.HandTipRight;
wristBendRight = projectedAngle(forearmVecRight,-1*handVecRight,elbowPlaneRight);
wristTwistRight = acosd(dot(forearmVecRight,handVecRight))  - wristBendRight;
if abs(wristBendRight) < 15
    wristRight = 1;
else
    wristRight = 2;
end
if abs(wristTwistRight) > binaryThresh
    wristRight = wristRight + 1;
end

% total
armScoreRight = B(shouldRight, wristRight, lowArmRight);

%% Total arREBA score
% pick arm
tableBscore = max(armScoreLeft,armScoreRight);
% add coupling
tableBscore = tableBscore + coupling;

tableCscore = C(tableAscore,tableBscore);

REBAscore = tableCscore + activityscore;

end



