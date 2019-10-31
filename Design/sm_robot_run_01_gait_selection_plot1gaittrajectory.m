% Code to plot simulation results from sm_robot_run_01_gait_selection
%% Plot Description:
%
% The plot below shows the phases of leg motion during a single step. It
% indicates the amount of time the leg spends in the air and shows the leg
% launch and land angles.  This information is used to compute the angle
% trajectories for leg joints.
%
% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('logsout_sm_robot_run_01_gait_selection', 'var')
    sim('sm_robot_run_01_gait_selection')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_robot_run_01_gait_selection', 'var') || ...
        ~isgraphics(h1_sm_robot_run_01_gait_selection, 'figure')
    h1_sm_robot_run_01_gait_selection = figure('Name', 'sm_robot_run_01_gait_selection');
end
figure(h1_sm_robot_run_01_gait_selection)
clf(h1_sm_robot_run_01_gait_selection)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
temp_cg_x=logsout_sm_robot_run_01_gait_selection.get('X');
temp_cg_y=logsout_sm_robot_run_01_gait_selection.get('Y');
temp_stance=logsout_sm_robot_run_01_gait_selection.get('stance');
temp_legangle=logsout_sm_robot_run_01_gait_selection.get('leg_angle');

% Plot results
% Trajectory of leg-body attachment point
plot(temp_cg_x.Values.Data, temp_cg_y.Values.Data, 'LineWidth', 2)
temp_change_inds = find(diff(temp_stance.Values.Data));
temp_change_inds = temp_change_inds+[0 1]';
hold on

% Launch/land points
plot(temp_cg_x.Values.Data(temp_change_inds), temp_cg_y.Values.Data(temp_change_inds), 'd',...
    'MarkerEdgeColor','k','MarkerFaceColor','k')

% Patch for left leg launch
patch(...
    temp_cg_x.Values.Data([1 1:temp_change_inds(1) temp_change_inds(1)]),...
    [0 temp_cg_y.Values.Data(1:temp_change_inds(1))' 0],...
    [1 0.8 0.8]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(sum(temp_cg_x.Values.Data([1 temp_change_inds(1)]))/2,...
    max(temp_cg_y.Values.Data)/10,sprintf('%s\n%s','Left Leg','Launch'),'HorizontalAlignment','center')

% Patch for legs in air
patch([...
    temp_cg_x.Values.Data(temp_change_inds(1))
    temp_cg_x.Values.Data(temp_change_inds(1):temp_change_inds(2))
    temp_cg_x.Values.Data(temp_change_inds(2))],[...
    0
    temp_cg_y.Values.Data(temp_change_inds(1):temp_change_inds(2))
    0],[1 1 1]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(max(temp_cg_x.Values.Data)/2,...
    max(temp_cg_y.Values.Data)/2,'Both Legs in Air','HorizontalAlignment','center');

% Patch for right leg land
patch(...
    temp_cg_x.Values.Data([temp_change_inds(2) temp_change_inds(2):end end]),...
    [0 temp_cg_y.Values.Data(temp_change_inds(2):end)' 0],...
    [0.8 0.8 1]*0.90,'EdgeColor','none','FaceAlpha','0.5');
text(sum(temp_cg_x.Values.Data([temp_change_inds(2) end]))/2,...
    max(temp_cg_y.Values.Data)/10,sprintf('%s\n%s','Right Leg','Land'),'HorizontalAlignment','center')

% Line for angle at left leg launch
plot([0 temp_cg_x.Values.Data(temp_change_inds(1))],[0 temp_cg_y.Values.Data(temp_change_inds(1))],...
    '--','LineWidth',1,'Color',temp_colororder(4,:));

% Circular arrow for leg omega at launch
temp_legomega0 =...
    (temp_legangle.Values.Data(temp_change_inds(1))-temp_legangle.Values.Data(temp_change_inds(1)-1))/...
    (temp_legangle.Values.Time(temp_change_inds(1))-temp_legangle.Values.Time(temp_change_inds(1)-1));
plot(temp_cg_x.Values.Data(temp_change_inds(1))+L/20*cosd(linspace(0,180,30)),...
    temp_cg_y.Values.Data(temp_change_inds(1))+L/20*sind(linspace(0,180,30)),...
    'LineWidth',1,'Color',temp_colororder(5,:))

% Circular arrow for leg angle at launch
temp_legtheta0 = -atan2d(temp_cg_x.Values.Data(temp_change_inds(1)),temp_cg_y.Values.Data(temp_change_inds(1)));
plot(temp_cg_x.Values.Data(temp_change_inds(1))+L/2*sind(linspace(0, temp_legtheta0,15)),...
    temp_cg_y.Values.Data(temp_change_inds(1))-L/2*cosd(linspace(0, temp_legtheta0,15)),...
    'LineWidth',1,'Color',temp_colororder(4,:))
plot(temp_cg_x.Values.Data(temp_change_inds(1)),...
    temp_cg_y.Values.Data(temp_change_inds(1))-L/2,...
    '>','MarkerEdgeColor',temp_colororder(4,:),'MarkerFaceColor',temp_colororder(4,:))

% Line for leg angle at land
plot([temp_cg_x.Values.Data(temp_change_inds(2)) temp_cg_x.Values.Data(end)],[temp_cg_y.Values.Data(temp_change_inds(1)) 0],...
    '--','LineWidth',1,'Color',[1 1 1]*0.7);

% Arrowhead for circular arrow for leg omega at launch
plot(temp_cg_x.Values.Data(temp_change_inds(1))-L/20,...
    temp_cg_y.Values.Data(temp_change_inds(1)),...
    'v','MarkerEdgeColor',temp_colororder(5,:),'MarkerFaceColor',temp_colororder(5,:));

% Circular arrow for leg angle at land
plot(temp_cg_x.Values.Data(temp_change_inds(2))-L/2*sind(linspace(0, temp_legtheta0,15)),...
    temp_cg_y.Values.Data(temp_change_inds(2))-L/2*cosd(linspace(0, temp_legtheta0,15)),...
    'LineWidth',1,'Color',[1 1 1]*0.7)
plot(temp_cg_x.Values.Data(temp_change_inds(2))-L/2*sind(temp_legtheta0),...
    temp_cg_y.Values.Data(temp_change_inds(2))-L/2*cosd(temp_legtheta0),...
    '>','MarkerEdgeColor',[1 1 1]*0.7,'MarkerFaceColor',[1 1 1]*0.7)

hold off

set(gca,'YLim',[0 max(temp_cg_y.Values.Data)*1.05])
axis equal
grid on
title('Trajectory of Leg Upper End')
ylabel('Height (m)')
xlabel('Distance (m)')
legend({'Trajectory','Launch/Land','Left Leg on Floor','Both Legs in Air','Right Leg on Floor',...
    ['{\theta}_{launch} = ' sprintf('%2.2f', temp_legtheta0) '{\circ}'],...
    ['{\omega}_{launch} = ' sprintf('%2.2f', temp_legomega0) '{\circ}/s'],...
    },'Location','South')

% Remove temporary variables
clear temp_colororder
clear temp_stance temp_cg_y temp_cg_y_data temp_cg_x temp_cg_x_data
clear temp_change_inds  temp_legtheta0 temp_legomega0 temp_legangle

