% Rose Hendrix
% test thinger to log and record body position and 
%
% Juan R. Terven, jrterven@hotmail.com
% Diana M. Cordova, diana_mce@hotmail.com
% 
% Citation:
% Terven Juan. Cordova-Esparza Diana, "Kin2. A Kinect 2 Toolbox for MATLAB", Science of
% Computer Programming, 2016. DOI: http://dx.doi.org/10.1016/j.scico.2016.05.009
%
% https://github.com/jrterven/Kin2, 2016.

addpath('Mex');
clearvars; close all

k2 = Kin2('color','body');

trialnum = 19;
filename = ['data/bodyandRGB_trial' num2str(trialnum) '.mat'];

% images sizes
d_width = 512; d_height = 424; outOfRange = 4000;
c_width = 1920; c_height = 1080;

% Color image is to big, let's scale it down
COL_SCALE = 0.3;

% Create matrices for the images
% depth = zeros(d_height,d_width,'uint16');
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');

% color stream figure
c.h = figure;
c.ax = axes;
c.im = imshow(color,[]);
title('Color Source (press q to exit)');
set(gcf,'keypress','k=get(gcf,''currentchar'');'); % listen keypress
%hold on

% Loop until pressing 'q' on any figure
k=[];
disp('Press q on any figure to exit')

% logging architecture & preallocation
maxframe = 10000;

bodytimelogger = zeros(1,maxframe);
bodylogger = zeros(3,25,maxframe);
bodyframe = 0;

videotimelogger = zeros(1,maxframe);
videologger = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,maxframe,'uint8');
videoframe = 0;

tic;

while true
    % Get frames from Kinect and save them on underlying buffer
    validData = k2.updateData;
    
    % Before processing the data, we need to make sure that a valid
    % frame was acquired.
    if validData
        % Copy data to Matlab matrices
        timesnap = toc;
        videoframe = videoframe + 1;
        
        color = k2.getColor;
        color = imresize(color,COL_SCALE);
        color = cast(color,'uint8');
        % preallocate the video and time logger arrays
        videotimelogger(videoframe) = timesnap;
        videologger(:,:,:,videoframe) = color;
        
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');
        numBodies = size(bodies,2);
        if numBodies > 0
            % Save the first body positions to the bodylogger
            bodyframe = bodyframe + 1;
            bodytimelogger(bodyframe) = timesnap;
            bodylogger(:,:,bodyframe) = bodies(1).Position;
        end

    end
    
    % If user presses 'q', exit loop
    if ~isempty(k)
        if strcmp(k,'q'); break; end
    end
    
    pause(0.03)
end

% Close kinect object
k2.delete;
rmpath('Mex');
close all;

% truncate the files to just the relevant part of preallocated matrix
bodytimelogger = bodytimelogger(1:bodyframe);
bodylogger = bodylogger(:,:,1:bodyframe);
videotimelogger = videotimelogger(1:videoframe);
videologger = videologger(:,:,:,1:videoframe);

% save to proper file
save(filename,'-v7.3','bodytimelogger','bodylogger','videologger','videotimelogger')

