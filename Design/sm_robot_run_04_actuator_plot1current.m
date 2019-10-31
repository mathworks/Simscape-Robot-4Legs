% Code to plot simulation results from sm_robot_run_04_actuator
%% Plot Description:
%
% The plot below shows the current drawn by the load and the contribution
% from the battery and ultracapacitor during the test.
%
% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_sm_robot_run_04_actuator', 'var')
    sim('sm_robot_run_04_actuator')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_robot_run_04_actuator', 'var') || ...
        ~isgraphics(h1_sm_robot_run_04_actuator, 'figure')
    h1_sm_robot_run_04_actuator = figure('Name', 'sm_robot_run_04_actuator');
end
figure(h1_sm_robot_run_04_actuator)
clf(h1_sm_robot_run_04_actuator)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_t = simlog_sm_robot_run_04_actuator.Power_Supply.Battery.i.series.time;
simlog_iBatt = simlog_sm_robot_run_04_actuator.Power_Supply.Battery.i.series.values('A');
simlog_iLoad = simlog_sm_robot_run_04_actuator.Power_Supply.Load_Current.Current_Sensor.I.series.values('A');
simlog_iUCap = simlog_sm_robot_run_04_actuator.Power_Supply.Ultra_Capacitor.i.series.values('A');
simlog_qMotor = simlog_sm_robot_run_04_actuator.Motion_Sensor.A.series.values('deg');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
plot(simlog_t, simlog_qMotor, 'LineWidth', 1)
hold off
grid on
title('Motor Shaft Angle')
ylabel('Angle (deg)')

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_t, simlog_iBatt, 'LineWidth', 1)
hold on
plot(simlog_t, simlog_iLoad, 'LineWidth', 1)
plot(simlog_t, simlog_iUCap, 'LineWidth', 1)
grid on
title('Currents')
ylabel('Current (A)')
xlabel('Time (s)')
legend({'Battery','Load','Ultra Capacitor'},'Location','Best');
linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_iBatt simlog_iLoad simlog_iUCap simlog_qMotor

