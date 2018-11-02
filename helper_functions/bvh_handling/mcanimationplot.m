function mcanimationplot()
 % Old function not used - Shashi Mohan Singh | July 06, 2018
REBAScore = REBASCORE;
y = REBAScore.data;
m = size(REBAScore.data);
x = 1:1:m;
grid on;
curve = animatedline('LineWidth', 1, 'Color', 'r');
hold on;
for i = 1:m;
    set(gca, 'XLim', [0, 1600], 'YLim', [0, 15]);
    title('Plot of REBA Score vs Frame Number')
    xlabel('Frame Number')
    ylabel('REBA Score')
    addpoints(curve, x(i), y(i));
    head = scatter(x(i), y(i));
    drawnow
    pause(0.05);
    delete(head);
   
    %subplot(1,2,2);
    %skelPlayData(skel, channels, frameLength);
    %skelPlayData(skelStruct, channels, frameLength, videoname);
    %handle = skelVisualise(channels(1, :), skel);
    %skelModify(handle, channels(m, :), skel);
    %pause(frameLength)
    %hold off;
end



