%% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN

% Displays Ergonomic Risk Assessment Results 
% Displays the Video of the object manipulation - Reads .avi and .mp4 files
% Displays current REBA Score with respect to frame number - Reads .bvh file
% Displays Skeleton animation - Reads .bvh file

%% Cleaning Window actions
clc;     % Clear the command window.
close all;   % Close all figures (except those of imtool.)
imtool close all;   % Close all imtool figures.
clear;   % Erase all existing variables.
workspace;   % Make sure the workspace panel is showing.
fontSize = 14;   % Specify fontsize

%% Read data files
REBAScore = REBASCORE;
y1 = REBAScore.data;
m = size(REBAScore.data);
x1 = 1:m;

% fileName = input('Enter File Name With Extension .bvh = ');
% Read the .bvh file path for skeleton animation
fileName = mcfilepath;
[skel, channels, frameLength] = bvhReadFile(fileName);

% FileName = input('Enter File Name With Extension .avi = ');
% Read the .avi file path for video display 
FileName = mcavifilepath();
videoObject = VideoReader(FileName);

% Get the Start Frame number and End Frame number information for the video file from the
% data source (i.e. from the TUM Kitchen web)
StartFrame = input('Enter Start Frame Number = ');
EndFrame = input('Enter End Frame Number = ');
% n is the number of frames for which data is in the .bvh file because video
% files have more number of frames than the .bvh files
n = (EndFrame - StartFrame + 1);

% Determine how many frames there are.
numberOfFrames = videoObject.NumberOfFrames;
vidHeight = videoObject.Height;
vidWidth = videoObject.Width;
 
% SKELPLAYDATA Play skel motion capture data.
% DESC plays channels from a motion capture skeleton and channels.
% ARG skel : the skeleton for the motion.
% ARG channels : the channels for the motion.
% ARG frameLength : the framelength for the motion.
% SEEALSO : bvhPlayData, acclaimPlayData
% MOCAP

if nargin < 3
  frameLength = 1/120;
end
clf

%% Get the limits of the skeleton motion.
x2lim = get(gca, 'xlim');
minY1 = x2lim(1);
maxY1 = x2lim(2);
y2lim = get(gca, 'ylim');
minY3 = y2lim(1);
maxY3 = y2lim(2);
z2lim = get(gca, 'zlim');
minY2 = z2lim(1);
maxY2 = z2lim(2);
for k = 1:n;
    Y = skel2xyz(skel, channels(k, :));
    minY1 = min([Y(:, 1); minY1]);
    minY2 = min([Y(:, 2); minY2]);
    minY3 = min([Y(:, 3); minY3]);
    maxY1 = max([Y(:, 1); maxY1]);
    maxY2 = max([Y(:, 2); maxY2]);
    maxY3 = max([Y(:, 3); maxY3]);
end

% SubPlot the REBA Score (handles only)
subplot(11,2,[15 16 17 18 19 20 21 22]);    
grid on;
curve1 = animatedline('LineWidth', 1, 'Color', 'r');
xlabel('Frame Number')
ylabel('REBA Score') 

%% Play the Final REBA Score, Video and Skeleton animation simultaniuosly 
hold on;
pause(10);

for j = 1:n;
                      
    % Play the skeleton Video 
    sub3 = subplot(11,2,[2 4 6 8 10 12]);    
    handle = skelVisualise(channels(1, :), skel);
    skelModify(handle, channels(j, :), skel);
    view([-0.6 -2.7 -2]) %view([-0.7 -2.8 -1.8])
    hold off;
    axis([minY1 maxY1 minY3 maxY3 minY2 maxY2]);    
    caption = sprintf('Frame %4d of %d', j, n); 
    title(caption, 'FontSize', fontSize);
    %pause(frameLength/1.5) 
    
    % Display video - Extract the frame from the movie structure.
    thisFrame = read(videoObject, (StartFrame + j -1) );  
    % Display it
    hImage = subplot(11,2,[1 3 5 7 9 11]);     
    image(thisFrame);
    caption = sprintf('Frame %4d of %d', j, n); 
    title(caption, 'FontSize', fontSize);
    % Force it to refresh the window.
    drawnow  
    
    % Plot the REBA Score levels.
    addpoints(curve1, x1(j), y1(j));
    hold on;
    drawnow;
    subplot(11,2,[15 16 17 18 19 20 21 22]); 
    axis([0 m(1,1)+75 0 15]);
    caption = sprintf('Current REBA Score = %d', y1(j));
    title(caption, 'FontSize', fontSize);
    head = scatter(x1(j), y1(j), '*','b');
    hold on;
    pause(0.001);
    delete(head)   
end


%% THE END  - Shashi Mohan Singh | 2018 | University of Washington | IITGN 





