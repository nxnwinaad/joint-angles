function ScoreA = mcScoreA()

An = mcneckscore;
At = mctrunkscore;
Al = mclegscore;

% BY - Shashi Mohan Singh | 2018 | University of Washington | IITGN
% d is mocap data structure
% n is number of frames
% An is matrix containing neck Scores
% Al is matrix containing leg Scores
% At is matrix containing trunk Scores
% A is risk Score from table A

%% Calulations for Table A

A = [];
n = size(An.data);
AN = An.data;
AL = Al.data;
AT = At.data;

for j = 1:n;
    if AN(j,1) == 1;
        if AL(j,1) == 1;
            if AT(j,1) == 1;
                A.data(j,1) = 1;
            elseif AT(j,1) == 2;
                A.data(j,1) = 2;
            elseif AT(j,1) == 3;
                A.data(j,1) = 2;
            elseif AT(j,1) == 4;
                A.data(j,1) = 3;
            elseif AT(j,1) ==5;
                A.data(j,1) = 4;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 2;
            elseif AT(j,1) == 2;
                A.data(j,1) = 3;
            elseif AT(j,1)== 3;
                A.data(j,1) = 4;
            elseif AT(j,1)== 4;
                A.data(j,1) = 5;
            elseif AT(j,1)== 5;
                A.data(j,1) = 6;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1)== 3;
                A.data(j,1) = 5;
            elseif AT(j,1)== 4;
                A.data(j,1) = 6;
            elseif AT(j,1)== 5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 4;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        end
    elseif AN(j,1) == 2;
        if AL(j,1) == 1;
            if AT(j,1) == 1;
                A.data(j,1) = 1;
            elseif AT(j,1) == 2;
                A.data(j,1) = 3;
            elseif AT(j,1) == 3;
                A.data(j,1) = 4;
            elseif AT(j,1) == 4;
                A.data(j,1) = 5;
            elseif AT(j,1) ==5;
                A.data(j,1) = 6;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 2;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1)== 3;
                A.data(j,1) = 5;
            elseif AT(j,1)== 4;
                A.data(j,1) = 6;
            elseif AT(j,1)== 5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 4;
            elseif AT(j,1) == 2;
                A.data(j,1) = 6;
            elseif AT(j,1)== 3;
                A.data(j,1) = 7;
            elseif AT(j,1)== 4;
                A.data(j,1) = 8;
            elseif AT(j,1)== 5;
                A.data(j,1) = 9;
            end
        end
    elseif AN(j,1) == 3;
        if AL(j,1) == 1;
            if AL(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 4;
            elseif AT(j,1) == 3;
                A.data(j,1) = 5;
            elseif AT(j,1) == 4;
                A.data(j,1) = 6;
            elseif AT(j,1) ==5;
                A.data(j,1) = 7;
            end
        elseif AL(j,1) == 2;
            if AT(j,1) == 1;
                A.data(j,1) = 3;
            elseif AT(j,1) == 2;
                A.data(j,1) = 5;
            elseif AT(j,1)== 3;
                A.data(j,1) = 6;
            elseif AT(j,1)== 4;
                A.data(j,1) = 7;
            elseif AT(j,1)== 5;
                A.data(j,1) = 8;
            end
        elseif AL(j,1) == 3;
            if AT(j,1) == 1;
                A.data(j,1) = 5;
            elseif AT(j,1) == 2;
                A.data(j,1) = 6;
            elseif AT(j,1)== 3;
                A.data(j,1) = 7;
            elseif AT(j,1)== 4;
                A.data(j,1) = 8;
            elseif AT(j,1)== 5;
                A.data(j,1) = 9;
            end
        elseif AL(j,1) == 4;
            if AT(j,1) == 1;
                A.data(j,1) = 6;
            elseif AT(j,1) == 2;
                A.data(j,1) = 7;
            elseif AT(j,1)== 3;
                A.data(j,1) = 8;
            elseif AT(j,1)== 4;
                A.data(j,1) = 9;
            elseif AT(j,1)== 5;   
                A.data(j,1) = 9;
            end
        end
    end    
end                


%% Adding Force/Load score & Calculations of Score a

disp(' =========================================== Enter Load/Force Involved ============================================ ')
disp(' For example if Load/Force Involved is 14 lbs, then enter 14 as input' )
Load = input('Enter Load/Force involved in object manipulation (in lbs) = ');
Scorea = [];
m = size(A.data);
for k = 1:m;
    if Load < 11;
        Scorea.data(k,1) = A.data(k,1) + 0;
    elseif 11 <= Load && Load < 22;
        Scorea.data(k,1) = A.data(k,1) + 1;
    elseif Load >= 22;
        Scorea.data(k,1) = A.data(k,1) + 2;
    end 
end


%% Adding Force_Load adjustment

disp(' ============================================ Enter Load/Force Adjustment ========================================= ')
disp(' If shock or rapid built up of force is involved during object manipulation then: Load_Force_Adjustment = 1 ')
disp(' If above is NOT the case then: Load_Force_Adjustment = 0 ')
Load_Force_Adjusment = input('Enter Load_Force_Adjustment = ');

ScoreA = [];
m = size(Scorea.data);
for k = 1:m;
    if Load_Force_Adjusment == 0;
        ScoreA.data(k,1) = Scorea.data(k,1) + 0;
    elseif Load_Force_Adjusment == 1;
        ScoreA.data(k,1) = Scorea.data(k,1) + 1;
    end 
end


%% Plotting the ScoreA Score wrt Frame Number
m = size(ScoreA.data);
x = 1:m;
y = ScoreA.data;
% figure
plot(x,y,'r');
ylim([0 15]);
title('Plot of ScoreA vs Frame Number')
xlabel('Frame Number')
ylabel('ScoreA')

 