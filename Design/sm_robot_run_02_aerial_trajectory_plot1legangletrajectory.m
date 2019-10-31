% Code to plot simulation results from sm_robot_run_02_aerial_trajectory
%% Plot Description:
%
% The plot below shows the trajectory of the leg angle during a gait
% period.
%
% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
sim('sm_robot_run_01_gait_selection')
sim('sm_robot_run_02_aerial_trajectory')

% Get simulation results
temp_leganglestance = logsout_sm_robot_run_01_gait_selection.get('leg_angle');
temp_legangleaerial = logsout_sm_robot_run_02_aerial_trajectory.get('angle');

% Second half of the stance
temp_stance_launch_ind = find(temp_leganglestance.Values.Data(2:end)>=0, 1 );
temp_stance_land_ind = 1+find(temp_leganglestance.Values.Data(2:end)>0, 1 );

temp_legAngleData1 = temp_leganglestance.Values.Data(1:temp_stance_launch_ind-1);
temp_legAngleTime1 = temp_leganglestance.Values.Time(1:temp_stance_launch_ind-1);

% Aerial phase
temp_legAngleData2 = temp_legangleaerial.Values.Data;
temp_legAngleTime2 = temp_legangleaerial.Values.Time+temp_leganglestance.Values.Time(temp_stance_launch_ind);

% First half of the stance
temp_legAngleData3 = temp_leganglestance.Values.Data(temp_stance_land_ind:end);
temp_legAngleTime3 = temp_legAngleTime2(end) + temp_leganglestance.Values.Time(temp_stance_land_ind:end)-...
    temp_leganglestance.Values.Time(temp_stance_land_ind-1);

% Complete trajectory
TimeValues = [temp_legAngleTime1;temp_legAngleTime2;temp_legAngleTime3];
DataValues = [temp_legAngleData1;temp_legAngleData2;temp_legAngleData3];

% Find indices for right foot on floor
temp_rffloor_start = find(temp_legAngleTime2>(sum(temp_legAngleTime2([1 end])/2)-temp_legAngleTime1(end)),1);
temp_rffloor_end = find(temp_legAngleTime2>(sum(temp_legAngleTime2([1 end])/2)+temp_legAngleTime1(end)),1);

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_robot_run_02_aerial_trajectory', 'var') || ...
        ~isgraphics(h1_sm_robot_run_02_aerial_trajectory, 'figure')
    h1_sm_robot_run_02_aerial_trajectory = figure('Name', 'sm_robot_run_02_aerial_trajectory');
end
figure(h1_sm_robot_run_02_aerial_trajectory)
clf(h1_sm_robot_run_02_aerial_trajectory)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
% Trajectory of leg angle
plot([temp_legAngleTime1;temp_legAngleTime2;temp_legAngleTime3],...
    [temp_legAngleData1;temp_legAngleData2;temp_legAngleData3],...
    'LineWidth',2);

hold on
lower_ylim = min(get(gca,'YLim'));

% Launch/land points
plot([temp_legAngleTime1(end) temp_legAngleTime3(1)]', [temp_legAngleData1(end) temp_legAngleData3(1)]', 'd',...
    'MarkerEdgeColor','k','MarkerFaceColor','k')

% Patch for left leg launch
patch([temp_legAngleTime1(1) temp_legAngleTime1(1:end)' temp_legAngleTime1(end)],...
    [lower_ylim temp_legAngleData1' lower_ylim],...
    [1 0.8 0.8]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(sum(temp_legAngleTime1([1 end]))/2,...
    lower_ylim*0.85,sprintf('%s\n%s','Left Leg','Launch'),'HorizontalAlignment','center')

% Patch for legs in air
patch([temp_legAngleTime1(end) temp_legAngleTime1(end) temp_legAngleTime2(1:end)' temp_legAngleTime3(1) temp_legAngleTime3(1)],...
    [lower_ylim temp_legAngleData1(end) temp_legAngleData2' temp_legAngleData3(1) lower_ylim],...
    [1 1 1]*0.90,'EdgeColor','none','FaceAlpha','0.5');

% Patch for right leg on floor
patch(temp_legAngleTime2([temp_rffloor_start temp_rffloor_start:temp_rffloor_end temp_rffloor_end]),...
    [lower_ylim temp_legAngleData2(temp_rffloor_start:temp_rffloor_end)' lower_ylim],...
    [0.8 0.8 1]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(sum(temp_legAngleTime2([1 end]))/2,...
    lower_ylim*0.85,sprintf('%s\n%s','Right Leg','on Floor'),'HorizontalAlignment','center')

% Line for angle at left leg launch
plot([0 temp_legAngleTime1(end)],[1 1]*temp_legAngleData1(end),...
    '--','LineWidth',1,'Color',temp_colororder(4,:));

% Slope line for leg omega at launch
plot([1 1]*temp_legAngleTime1(end)+[-0.07 0.07]*temp_legAngleTime3(end),...
    [1 1]*temp_legAngleData1(end)+ [-0.07 0.07]*temp_legAngleTime3(end)*leg_vel0,...
    'LineWidth',1,'Color',temp_colororder(5,:));

% Patch for left leg land
patch([temp_legAngleTime3(1) temp_legAngleTime3(1:end)' temp_legAngleTime3(end)],...
    [lower_ylim temp_legAngleData3' lower_ylim],...
    [1 0.8 0.8]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(sum(temp_legAngleTime3([1 end]))/2,...
    lower_ylim*0.85,sprintf('%s\n%s','Left Leg','Land'),'HorizontalAlignment','center')

hold off

title('Trajectory of Left Leg Angle');
xlabel('Time (s)')
ylabel('Leg Angle (deg)')
legend({'Leg Angle','Launch/Land','Left Leg on Floor','Both Legs in Air','Right Leg on Floor',...
    ['{\theta}_{launch} = ' sprintf('%2.2f', leg_angle0) '{\circ}'],...
    ['{\omega}_{launch} = ' sprintf('%2.2f', leg_vel0) '{\circ}/s']},...
    'Location','NorthWest')

% Remove temporary variables
clear temp_colororder
clear temp_change_inds        temp_legangle
clear temp_legAngleTime1      temp_legAngleTime2      temp_legAngleTime3
clear temp_legAngleData1      temp_legAngleData2      temp_legAngleData3
clear temp_legangleaerial     temp_leganglestance 
clear temp_stance_launch_ind  temp_stance_land_ind    
clear temp_rffloor_start temp_rffloor_end 
