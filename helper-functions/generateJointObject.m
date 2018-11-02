function jo = generateJointObject(position,type)

if strcmp(type,'kinect')
    for ii = 1:size(position,3)
        jo(ii).SpineBase     = position(:,1,ii);
        jo(ii).SpineMid      = position(:,2,ii);
        jo(ii).Neck          = position(:,3,ii);
        jo(ii).Head          = position(:,4,ii);
        jo(ii).ShoulderLeft  = position(:,5,ii);
        jo(ii).ElbowLeft     = position(:,6,ii);
        jo(ii).WristLeft     = position(:,7,ii);
        jo(ii).HandLeft      = position(:,8,ii);
        jo(ii).ShoulderRight = position(:,9,ii);
        jo(ii).ElbowRight    = position(:,10,ii);
        jo(ii).WristRight	 = position(:,11,ii);
        jo(ii).HandRight     = position(:,12,ii);
        jo(ii).HipLeft       = position(:,13,ii);
        jo(ii).KneeLeft      = position(:,14,ii);
        jo(ii).AnkleLeft     = position(:,15,ii);
        jo(ii).FootLeft      = position(:,16,ii);
        jo(ii).HipRight      = position(:,17,ii);
        jo(ii).KneeRight     = position(:,18,ii);
        jo(ii).AnkleRight	 = position(:,19,ii);
        jo(ii).FootRight     = position(:,20,ii);
        jo(ii).SpineShoulder = position(:,21,ii);
        jo(ii).HandTipLeft   = position(:,22,ii);
        jo(ii).ThumbLeft     = position(:,23,ii);
        jo(ii).HandTipRight  = position(:,24,ii);
        jo(ii).ThumbRight	 = position(:,25,ii);
        
        % special: normal vector of plane facing outwards
        jo(ii).ChestNormal = cross(jo(ii).ShoulderRight-jo(ii).SpineMid,jo(ii).ShoulderLeft - jo(ii).SpineMid);
        % uses cross product of the two shoulder-midspine vecs to define a plane
    end
    
    
elseif strcmp(type,'TUMKitchen')
    for ii = 1:size(position,1)
        jo(ii).SpineBase     = position(ii,:,1);
        jo(ii).SpineMid      = position(ii,:,5);
        jo(ii).Neck          = position(ii,:,8);
        jo(ii).Head          = position(ii,:,21);
        jo(ii).ShoulderLeft  = position(ii,:,15);
        jo(ii).ElbowLeft     = position(ii,:,16);
        jo(ii).WristLeft     = position(ii,:,17);
        jo(ii).HandLeft      = position(ii,:,18);
        jo(ii).ShoulderRight = position(ii,:,9);
        jo(ii).ElbowRight    = position(ii,:,10);
        jo(ii).WristRight	 = position(ii,:,11);
        jo(ii).HandRight     = position(ii,:,12);
        jo(ii).HipLeft       = position(ii,:,29);
        jo(ii).KneeLeft      = position(ii,:,30);
        jo(ii).AnkleLeft     = position(ii,:,31);
        jo(ii).FootLeft      = position(ii,:,33);
        jo(ii).HipRight      = position(ii,:,24);
        jo(ii).KneeRight     = position(ii,:,25);
        jo(ii).AnkleRight	 = position(ii,:,26);
        jo(ii).FootRight     = position(ii,:,28);
        jo(ii).SpineShoulder = position(ii,:,7);
        jo(ii).HandTipLeft   = position(ii,:,19);
        jo(ii).ThumbLeft     = position(ii,:,18);
        jo(ii).HandTipRight  = position(ii,:,13);
        jo(ii).ThumbRight	 = position(ii,:,12);
        
        % special: normal vector of plane facing outwards
        jo(ii).ChestNormal = cross(jo(ii).ShoulderRight-jo(ii).SpineMid,jo(ii).ShoulderLeft - jo(ii).SpineMid);
        % uses cross product of the two shoulder-midspine vecs to define a plane
    end
else
    disp('Something has gone wrong with your joints!');
end


end