function ScoreB = mcScoreB()

Bu = mcupperhandscore;
Bl = mclowerhandscore;
Bw = mcwristscore;

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% d is mocap data structure
% n is number of frames
% Bl is matrix containing lower arm Scores
% Bw is matrix containing wrist Scores
% Bu is matrix containing upper arm Scores
% B is risk Score from table B

%% Calculations for Table B

B = [];
n = size(Bl.data);
BU  =Bu.data;
BL = Bl.data;
BW = Bw.data;

for j = 1:n;
    if BL(j,1) == 1;
        if BW(j,1) == 1;
            if BU(j,1) == 1;
                B.data(j,1)  = 1;
            elseif BU(j,1) == 2;
                B.data(j,1) = 1;
            elseif BU(j,1) == 3;
                B.data(j,1) = 3;
            elseif BU(j,1) == 4;
                B.data(j,1) = 4;
            elseif BU(j,1) == 5;
                B.data(j,1) = 6;
            elseif BU(j,1) == 6;
                B.data(j,1) = 7;
            end   
        elseif BW(j,1) == 2;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 2;
            elseif BU(j,1) == 3;
                B.data(j,1) = 4;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 7;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end    
        elseif BW(j,1) == 3;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 3;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end    
        end  
    elseif BL(j,1) == 2;
        if BW(j,1) == 1;
            if BU(j,1) == 1;
                B.data(j,1)  = 1;
            elseif BU(j,1) == 2;
                B.data(j,1) = 2;
            elseif BU(j,1) == 3;
                B.data(j,1) = 4;
            elseif BU(j,1) == 4;
                B.data(j,1) = 5;
            elseif BU(j,1) == 5;
                B.data(j,1) = 7;
            elseif BU(j,1) == 6;
                B.data(j,1) = 8;
            end   
        elseif BW(j,1) == 2;
            if BU(j,1) == 1;
                B.data(j,1)  = 2;
            elseif BU(j,1) == 2;
                B.data(j,1) = 3;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 6;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 9;
            end    
        elseif BW(j,1) == 3;
            if BU(j,1) == 1;
                B.data(j,1)  = 3;
            elseif BU(j,1) == 2;
                B.data(j,1) = 4;
            elseif BU(j,1) == 3;
                B.data(j,1) = 5;
            elseif BU(j,1) == 4;
                B.data(j,1) = 7;
            elseif BU(j,1) == 5;
                B.data(j,1) = 8;
            elseif BU(j,1) == 6;
                B.data(j,1) = 9;
            end    
        end    
    end
end


%% Adding Coupling score and Calculations of Score B

disp('  ============================================= Enter Coupling Score ============================================')
disp( 'For well fitting handle nd mid range power grip: Coupling Score = 0')
disp( 'For acceptable but not ideal hand hold grip: Coupling Score = 1')
disp( 'For hand hold not acceptable but possible: Coupling Score = 2')
disp( 'For no handles, awkward, unsafe with any body part: Coupling Score = 3')

Coupling_Score = input('Enter Coupling Score = ');
ScoreB = [];
m = size(B.data);
for k = 1:m;
    if Coupling_Score == 0;
        ScoreB.data(k,1) = B.data(k,1) + 0;
    elseif Coupling_Score == 1;
        ScoreB.data(k,1) = B.data(k,1) + 1;
    elseif Coupling_Score == 2;
        ScoreB.data(k,1) = B.data(k,1) + 2;
    elseif Coupling_Score == 3;
        ScoreB.data(k,1) = B.data(k,1) + 3;
    end 
end
                       
%% Plotting the ScoreB wrt Frame Number
m = size(ScoreB.data);
x = 1:m;
y = ScoreB.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of ScoreB vs Frame Number')
xlabel('Frame Number')
ylabel('ScoreB')  



