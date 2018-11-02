function RebaScore = mcRebaScore()

ScoreA = mcScoreA;
ScoreB = mcScoreB;

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% RebaScore is the matrix containg final REBA Socres
% ScoreA represents group A score
% ScoreB represents group B score
% d is mocap data structure
% n is number of frames

%% Calculations for Table C

C = [];
n = size(ScoreA.data);
SA = ScoreA.data;
SB = ScoreB.data;

for j = 1:n;
    if SB(j,1) == 1;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 1;
        elseif SA(j,1) == 3;
            C.data(j,1) = 2;
        elseif SA(j,1) == 4;
            C.data(j,1) = 3;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 2;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 2;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 3;
        if SA(j,1) == 1;
            C.data(j,1) = 1;
        elseif SA(j,1) == 2;
            C.data(j,1) = 2;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 4;
        elseif SA(j,1) == 6;
            C.data(j,1) = 6;
        elseif SA(j,1) == 7;
            C.data(j,1) = 7;
        elseif SA(j,1) == 8;
            C.data(j,1) = 8;
        elseif SA(j,1) == 9;
            C.data(j,1) = 9;
        elseif SA(j,1) == 10;
            C.data(j,1) = 10;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 4;
        if SA(j,1) == 1;
            C.data(j,1) = 2;
        elseif SA(j,1) == 2;
            C.data(j,1) = 3;
        elseif SA(j,1) == 3;
            C.data(j,1) = 3;
        elseif SA(j,1) == 4;
            C.data(j,1) = 4;
        elseif SA(j,1) == 5;
            C.data(j,1) = 5;
        elseif SA(j,1) == 6;
            C.data(j,1) = 7;
        elseif SA(j,1) == 7;
            C.data(j,1) = 8;
        elseif SA(j,1) == 8;
            C.data(j,1) = 9;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 11;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 5;
        if SA(j,1) == 1;
            C.data(j,1) = 3;
        elseif SA(j,1) == 2;
            C.data(j,1) = 4;
        elseif SA(j,1) == 3;
            C.data(j,1) = 4;
        elseif SA(j,1) == 4;
            C.data(j,1) = 5;
        elseif SA(j,1) == 5;
            C.data(j,1) = 6;
        elseif SA(j,1) == 6;
            C.data(j,1) = 8;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 6;
        if SA(j,1) == 1;
            C.data(j,1) = 3;
        elseif SA(j,1) == 2;
            C.data(j,1) = 4;
        elseif SA(j,1) == 3;
            C.data(j,1) = 5;
        elseif SA(j,1) == 4;
            C.data(j,1) = 6;
        elseif SA(j,1) == 5;
            C.data(j,1) = 7;
        elseif SA(j,1) == 6;
            C.data(j,1) = 8;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 10;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 7;
        if SA(j,1) == 1;
            C.data(j,1) = 4;
        elseif SA(j,1) == 2;
            C.data(j,1) = 5;
        elseif SA(j,1) == 3;
            C.data(j,1) = 6;
        elseif SA(j,1) == 4;
            C.data(j,1) = 7;
        elseif SA(j,1) == 5;
            C.data(j,1) = 8;
        elseif SA(j,1) == 6;
            C.data(j,1) = 9;
        elseif SA(j,1) == 7;
            C.data(j,1) = 9;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 11;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 8;
        if SA(j,1) == 1;
            C.data(j,1) = 5;
        elseif SA(j,1) == 2;
            C.data(j,1) = 6;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 8;
        elseif SA(j,1) == 5;
            C.data(j,1) = 8;
        elseif SA(j,1) == 6;
            C.data(j,1) = 9;
        elseif SA(j,1) == 7;
            C.data(j,1) = 10;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 9;
        if SA(j,1) == 1;
            C.data(j,1) = 6;
        elseif SA(j,1) == 2;
            C.data(j,1) = 6;
        elseif SA(j,1) == 3;
            C.data(j,1) = 7;
        elseif SA(j,1) == 4;
            C.data(j,1) = 8;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 10;
        elseif SA(j,1) == 8;
            C.data(j,1) = 10;
        elseif SA(j,1) == 9;
            C.data(j,1) = 11;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 10;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 7;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 11;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 7;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    elseif SB(j,1) == 12;
        if SA(j,1) == 1;
            C.data(j,1) = 7;
        elseif SA(j,1) == 2;
            C.data(j,1) = 8;
        elseif SA(j,1) == 3;
            C.data(j,1) = 8;
        elseif SA(j,1) == 4;
            C.data(j,1) = 9;
        elseif SA(j,1) == 5;
            C.data(j,1) = 9;
        elseif SA(j,1) == 6;
            C.data(j,1) = 10;
        elseif SA(j,1) == 7;
            C.data(j,1) = 11;
        elseif SA(j,1) == 8;
            C.data(j,1) = 11;
        elseif SA(j,1) == 9;
            C.data(j,1) = 12;
        elseif SA(j,1) == 10;
            C.data(j,1) = 12;
        elseif SA(j,1) == 11;
            C.data(j,1) = 12;
        elseif SA(j,1) == 12;
            C.data(j,1) = 12;
        end
    end
end    


%% Adding Activity score and Calculating the Final REBA Score

disp('  ======================================== Enter Activity Score =====================================')
disp( 'Final Activity score = (Activity Score a + Activity Score b + Acivity Score c)')  
disp( 'For one of more body parts are held for longer than 1 minute: Activity Score a = 1')
disp( 'For repeated small range actions (more than 4x per minute): Activity Score b = 1')
disp( 'For actions causing rapid arge range changes in posture or unstable base: Activity Score c = 1')
disp( 'If any of above a, b, c activity is NOT happening then add 0 for that Activity Score')

Activity_Score = input('Enter Final Activity Score = ');
RebaScore = [];
m = size(C.data);
for k = 1:m;
    if Activity_Score == 0;
        RebaScore.data(k,1) = C.data(k,1) + 0;
    elseif Activity_Score == 1;
        RebaScore.data(k,1) = C.data(k,1) + 1;
    elseif Activity_Score == 2;
        RebaScore.data(k,1) = C.data(k,1) + 2;
    elseif Activity_Score == 3;
        RebaScore.data(k,1) = C.data(k,1) + 3;
    end 
end


%% Plotting the REBA Score wrt Frame Number

x = 1:m;
y = RebaScore.data;
figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of REBA Score vs Frame Number')
xlabel('Frame Number')
ylabel('REBA Score')




