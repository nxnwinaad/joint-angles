function xyz = skel2xyz(skel, channels)

% BY - Shashi Mohan Singh (edited)| 2018 | University of Washington | IITGN
% SKEL2XYZ Compute XYZ values given skeleton structure and channels.
% FORMAT
% DESC Computes X, Y, Z coordinates given a BVH or acclaim skeleton
% structure and an associated set of channels.
% ARG skel : a skeleton for the bvh file.
% ARG channels : the channels for the bvh file.
% RETURN xyz : the point cloud positions for the skeleton.
% SEEALSO : acclaim2xyz, bvh2xyz

fname = str2func([skel.type '2xyz']);
xyz = fname(skel, channels);
