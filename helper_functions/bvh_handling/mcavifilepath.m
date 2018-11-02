function FileName = mcavifilepath(fn)

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% Reads the .avi file for video display in the Final Results  
% Also see FinalResults.m

FileName = [];
if nargin==0
    [file,path] = uigetfile({'*.mp4;*.avi', '.mp4 and .avi files'}, 'Pick a .mp4, or .avi file');
    fn = [path file];
end
    
if ~ischar(fn)   % Check if input is given as string - (does not work if file ending is given)
    disp([10, 'Please enter file name as string!',10]);
    [y,fs] = audioread('mcsound.wav');
    sound(y,fs);
    return
end

if fn ~= 0
    if exist(fn,'file') == 2      % Check if file exists 
        postfix = fn((end-3):end);
        if strcmp(postfix, '.avi')
            FileName = [path file];  
        elseif strcmp(postfix, '.avi')
            FileName = [path file];
        else
            disp([10, 'This file format is not supported!',10]);
            [y,fs] = audioread('mcsound.wav');
            sound(y,fs);
        end
    else
        disp([10, 'File not found!',10]); 
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
    end
end


