function acclaimPlayFile(fileNameAsf, fileNameAmc, frameLength)

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% ACCLAIMPLAYFILE Play motion capture data from a asf and amc file.
% FORMAT
% DESC plays motion capture data by reading in a asf and amc files from disk.
% ARG fileNameAsf : the name of the ASF file to read in.
% ARG fileNameAmc : the name of the AMC file to read in.
% ARG frameLength : the length of the frames.
% SEEALSO : acclaimPlayFile, bvhReadFile, skelPlayData
% MOCAP

skel = acclaimReadSkel(fileNameAsf);
[channels, skel] = acclaimLoadChannels(fileNameAmc, skel);
skelPlayData(skel, channels, frameLength);
