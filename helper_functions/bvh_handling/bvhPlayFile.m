function bvhPlayFile(fileName)

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% bvhPlayFile Play motion capture data from a bvh file format
% DESC plays motion capture data by reading in a bvh file from disk.
% ARG fileName : the name of the file to read in, in bvh format.
% SEEALSO : acclaimPlayFile, bvhReadFile, skelPlayData
% MOCAP data

[skel, channels, frameLength] = bvhReadFile(fileName);
skelPlayData(skel, channels, frameLength);