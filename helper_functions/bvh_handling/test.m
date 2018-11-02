REBAScore = REBASCORE;
y1 = REBAScore.data;
m = size(REBAScore.data);
x1 = 1:m;
curve1 = animatedline('LineWidth', 0.8, 'Color', 'r');
StartFrame = input('Enter Start Frame Number = ');
EndFrame = input('Enter End Frame Number = ');
% n is the number of frames for which data is in the .bvh file because video
% files have more number of frames than the .bvh files
n = (EndFrame - StartFrame + 1);
subplot(3,2,1);

%title(caption, 'FontSize', fontSize);
xlabel('Frame Number')
ylabel('REBA Score') 
axis([0 1000 0 15]);
for j = 1:n;
    %caption = sprintf('Current REBA Score = %d', y1(j));
    addpoints(curve1, x1(j), y1(j));
    hold on;
    %drawnow
    head = scatter(x1(j), y1(j), '*','b');
    hold on;
    pause(0.02);
    delete(head)
end