% Quadruped robot design file. Takes the nominal gait as defined by model
% sm_robot_run_01_gait_selection.slx, and determines required knee and hip
% torques using an inverse-kinematic leg model. The torque and
% corresponding velocity and angle profiles are then used by the leg
% controller for each of the four limbs in the complete robot model
% "sm_robot_run_4legs.slx".
%
% R A Hyde
% Copyright 2008-2018 The MathWorks 

%% Generate nominal gait, leg length and payload mass

% Biomechanical parameters
L = 1.0;    % Leg length (m)
g = 9.81;   % Acceleration due to gravity (m/s^2)
m = 25;     % Mass (Kg)
k = 5315;   % Leg stiffness (N/m)

% Initial conditions for normalized positions and speeds
x0 = 0.0;   % Horizontal position of mass in middle of stance phase ()
y0 = 0.85*L;  % Height of mass in middle of stance phase ()
u0 = 2.0;   % Horizontal speed in middle of stance phase (/s)
v0 = 0.0;   % Vertical speed in the middle of the stance phase (/s)

sim('sm_robot_run_01_gait_selection')       % Returns leg_angle0, leg_vel0, leg_angle, y0, u0, L, and m.
T_cg = leg_angle.time(end);    % Gait period
idx_stance = find(stance.signals.values<=0.5,1);
T_stance = 2*stance.time(idx_stance);
sm_robot_run_01_gait_selection_plot1gaittrajectory

%% Construct aerial phase trajectory using leg_angle0 and leg_vel0 as initial conditions
sim('sm_robot_run_02_aerial_trajectory')    % Returns aerial_phase_angle
sm_robot_run_02_aerial_trajectory_plot1legangletrajectory

%% Determine required hip and knee torques using inverse dynamics

% Build complete trajectory
% Second half of the stance
idx_3_4 = find(leg_angle.signals.values(2:end)>=0, 1 );
data1 = leg_angle.signals.values(1:idx_3_4-1);
time1 = leg_angle.time(1:idx_3_4-1);

% Aerial phase
data2 = aerial_phase_angle.signals.values;
time2 = leg_angle.time(idx_3_4) + aerial_phase_angle.time;

% First half of the stance
idx_1_2 = 1+find(leg_angle.signals.values(2:end)>0, 1 );
data3 = leg_angle.signals.values(idx_1_2:end);
time3 = time2(end) + leg_angle.time(idx_1_2:end) - leg_angle.time(idx_1_2-1);

% Complete trajectory
TimeValues = [time1;time2;time3];
DataValues = [data1;data2;data3];

%% Constants & environment
t_final = T_cg*6;
ground.stiffness = 100000;
ground.damping = 250;

%% Define top-level design parameters
% Note: m is half the total mass of four-legged robot
M = m*0.9;           % Supported payload - assumes each leg is 5% of total mass
R = 100;             % Radius of supported mass (artificially high to prevent rotation)
L_stance = y0;       % Leg length mid stance
L_back = 1.5;        % Length of back
joint_damping = 0.1; % Damping in Nm/(rad/s) at hip and knee joints
th1 = 25*pi/180;     % Upper-leg angle to vertical if no vertical load [0<th1<90 deg]
th2_retracted = 45*pi/180; % Inside knee angle when fully retracted

%% Derived parameters

l1 = L/(2*cos(th1));     % Upper leg length (m)
l2 = L/(2*cos(th1));     % Lower leg length (m)
th2 = 2*asin((L/2)/l1);  % Inside knee angle
m1 = 0.05*m/(l1+l2);     % Upper-leg mass per unit length
m2 = 0.05*m/(l1+l2);     % Lower-leg mass per unit length

% Joint angles at midstance
dLs = L-L_stance;
th2_0 = 2*asin( 0.5*(L-dLs)/l1);
th1_0 = pi/2 - th2_0/2;

% Calculate knee spring stiffness based on mid stance
k2 = k*dLs*l1*sin(th1_0)/(th2-th2_0);

% Initial conditions
h0 = 0.0;    % On the ground
hdot0 = 0.0; % Initial vertical velocity

% Perform inverse dynamics simulation of leg
sim('sm_robot_run_03_leg_inverse_dyn')
sm_robot_run_03_leg_inverse_dyn_plot1trq

%% Determine battery weight

% Find starting and finishing indices for aerial phase for one leg
idx1 = find(hip_torque.time > T_cg/4, 1 );
idx2 = find(hip_torque.time > 7*T_cg/4, 1 );

% Hip angle in aerial phase
t_th = Hip.time(idx1+1:idx2-1);
t_th = t_th - t_th(1);
u_th = Hip.signals.values(idx1+1:idx2-1);
th_dot0 = (u_th(2)-u_th(1))/(t_th(2)-t_th(1));

% Hip velocity in aerial phase
t_w = HipVel.time(idx1+1:idx2-1);
t_w = t_w - t_w(1);
u_w = HipVel.signals.values(idx1+1:idx2-1);

% Maximum inertia about hip
J = m2*l2*l1^2+(m1*l1^3+m2*l2^3)/3;

% Hip angle controller parameters
N  = 80;
bw = 200;

% Plot battery currents
sim('sm_robot_run_04_actuator')
sm_robot_run_04_actuator_plot1current

%% Run full system (robot) model
Trq_propulsive = 0.5; % Propulsive torque during stance phase
open('sm_robot_run_4legs')
sim('sm_robot_run_4legs')
sm_robot_run_4legs_plot1current







