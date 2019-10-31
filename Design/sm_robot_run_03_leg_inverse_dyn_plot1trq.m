% Code to plot simulation results from sm_robot_run_03_leg_inverse_dyn
%% Plot Description:
%
% The plots below show the torque for the aerial phase at the hip and knee
% joints.
%
% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_sm_robot_run_03_leg_inverse_dyn', 'var')
    sim('sm_robot_run_03_leg_inverse_dyn')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_robot_run_03_leg_inverse_dyn', 'var') || ...
        ~isgraphics(h1_sm_robot_run_03_leg_inverse_dyn, 'figure')
    h1_sm_robot_run_03_leg_inverse_dyn = figure('Name', 'sm_robot_run_03_leg_inverse_dyn');
end
figure(h1_sm_robot_run_03_leg_inverse_dyn)
clf(h1_sm_robot_run_03_leg_inverse_dyn)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_qHip = logsout_sm_robot_run_03_leg_inverse_dyn.get('hip_angle');
simlog_qKnee = logsout_sm_robot_run_03_leg_inverse_dyn.get('knee_angle');
simlog_trqHip = logsout_sm_robot_run_03_leg_inverse_dyn.get('hip_torque');
simlog_trqKnee = logsout_sm_robot_run_03_leg_inverse_dyn.get('knee_torque');

% Plot results
simlog_handles(1) = subplot(2,2,1);
plot(simlog_trqHip.Values.Time,simlog_trqHip.Values.Data,'LineWidth',1)
axis([T_cg/4 2*T_cg-T_cg/4 -10 5])
ylabel('Torque (Nm)')
title('Hip Torque in Aerial Phase')
grid on

simlog_handles(3) = subplot(2,2,3);
plot(simlog_qHip.Values.Time,simlog_qHip.Values.Data,'LineWidth',1)
set(gca,'XLim', [T_cg/4 2*T_cg-T_cg/4])
xlabel('Time (s)')
ylabel('Angle (deg)')
title('Hip Angle in Aerial Phase');
grid on

simlog_handles(2) = subplot(2,2,2);
plot(simlog_trqKnee.Values.Time,simlog_trqKnee.Values.Data,'LineWidth',1)
axis([T_cg/4 2*T_cg-T_cg/4 -1 3])
ylabel('Torque (Nm)')
title('Knee Torque in Aerial Phase')
grid on

simlog_handles(4) = subplot(2,2,4);
plot(simlog_qKnee.Values.Time,simlog_qKnee.Values.Data,'LineWidth',1)
set(gca,'XLim', [T_cg/4 2*T_cg-T_cg/4])
xlabel('Time (s)')
ylabel('Angle (deg)')
title('Knee Angle in Aerial Phase')
grid on

linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_qKnee simlog_qHip 
clear simlog_trqKnee simlog_trqHip 
