function finalangle = projectedAngle(vec1,vec2,normalVec)
% function for calculating the angle between two vectors in a plane defined
% by its normal. Used for joint angle calculations in the REBA method. All
% three vectors should be in the format [x ;y ;z]

% find unit vector of each vector projected into the relevant plane
proj1 = cross(normalVec,cross(vec1,normalVec));
proj2 = cross(normalVec,cross(vec2,normalVec));

finalangle = acosd(dot(proj1,proj2)/(norm(proj1)*norm(proj2)));

end