function mn = mcgetmarkername(d)     

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% d = mcread('poses.bvh');
% Returns the names of the markers.

% syntax
% mn = mcgetmarkernames(d);

% input parameters
% d: MoCap data structure

% output
% mn: cell structure containing marker names

mn = [];
if isfield(d,'type') && (strcmp(d.type, 'MoCap data') || strcmp(d.type, 'norm data'))
    mn = d.markerName;
%    for k=1:d.nMarkers
%        fprintf([num2str(k) '\t' char(d.markerName{k}) '\n'])
%    end
else
    disp([10, 'The first input argument should be a variable with MoCap or norm data structure.', 10]);
end

