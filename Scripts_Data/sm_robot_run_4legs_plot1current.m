% Code to plot simulation results from sm_robot_run_4legs
%% Plot Description:
%
% The plot below shows the current drawn by the load and the contribution
% from the battery and ultracapacitor during the test.
%
% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_sm_robot_run_4legs', 'var')
    sim('sm_robot_run_4legs')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_robot_run_4legs', 'var') || ...
        ~isgraphics(h1_sm_robot_run_4legs, 'figure')
    h1_sm_robot_run_4legs = figure('Name', 'sm_robot_run_4legs');
end
figure(h1_sm_robot_run_4legs)
clf(h1_sm_robot_run_4legs)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_t = simlog_sm_robot_run_4legs.Power_Supply.Battery.i.series.time;
simlog_iBatt = simlog_sm_robot_run_4legs.Power_Supply.Battery.i.series.values('A');
simlog_iLoad = simlog_sm_robot_run_4legs.Power_Supply.Load_Current.Current_Sensor.I.series.values('A');
if(simlog_sm_robot_run_4legs.Body_Constraint.Constraint.hasChild('Planar'))
    simlog_robotx = simlog_sm_robot_run_4legs.Body_Constraint.Constraint.Planar.Planar_Joint.Px.p.series.values('m');
    simlog_roboty = simlog_sm_robot_run_4legs.Body_Constraint.Constraint.Planar.Planar_Joint.Py.p.series.values('m');
else
    simlog_robotx = simlog_sm_robot_run_4legs.Body_Constraint.Constraint.Six_DOF.Bushing_Joint.Px.p.series.values('m');
    simlog_roboty = simlog_sm_robot_run_4legs.Body_Constraint.Constraint.Six_DOF.Bushing_Joint.Py.p.series.values('m');
end

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
plot(simlog_t, simlog_roboty, 'LineWidth', 1)
hold off
grid on
title('Robot CG Height ')
ylabel('Height (m)')

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_t, simlog_iBatt, 'LineWidth', 1)
hold on
plot(simlog_t, simlog_iLoad, 'LineWidth', 1)
grid on
title('Currents')
ylabel('Current (A)')
xlabel('Time (s)')
legend({'Battery','Load'},'Location','Best');

linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_robotx simlog_roboty simlog_iBatt simlog_iLoad 

