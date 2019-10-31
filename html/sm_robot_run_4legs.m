%% Mechatronic Running Robot
% This model shows how a running or walking robot can be modeled to
% support system design. This four-legged robot has compliant legs that can
% store and re-release kinetic energy. As such it is biologically-inspired
% by an equestrian trotting gait. The model can be used to support
% selection of leg length, leg spring stiffness and actuators. An objective
% could be to minimise power consumption for a steady trot at some nominal
% average forward speed. The DC power supply is augmented with an
% ultracapacitor which is sized to smooth battery currents and store
% regenerative electrical energy.
%
% For details on the design process, see <matlab:web('sm_robot_run_limb_design.html'); Mechatronic Running Robot Limb Design>

% Copyright 2012-2018 The MathWorks, Inc.


%% Model
load('sm_robot_run_4legs_param_def')

open_system('sm_robot_run_4legs')

set_param(find_system('sm_robot_run_4legs','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% 
% <<sm_robot_run_4legs_mechExp_anim.gif>>

%% Leg LF Subsystem
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Leg%20LF','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Leg LF','LinkStatus','none')
open_system('sm_robot_run_4legs/Leg LF','force')
%% Hip Actuator Subsystem
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Leg%20LF/Hip%20Actuator/Actuator','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Leg LF/Hip Actuator/Actuator','LinkStatus','none')
open_system('sm_robot_run_4legs/Leg LF/Hip Actuator/Actuator','force')


%% Power Supply Subsystem
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Power%20Supply','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Power Supply','LinkStatus','none')
open_system('sm_robot_run_4legs/Power Supply','force')

%% Gait Phase Subsystem
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Gait%20Phase','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Gait Phase','LinkStatus','none')
open_system('sm_robot_run_4legs/Gait Phase','force')

%% Contact Forces Between Feet and Floor
%
% Two methods are used for modeling the contact force between the foot and
% the floor.  One is used for the X-Y plane only, the other accommodates
% movement in any direction.  You can select the appropriate force for your
% test using a parameter in the leg subsystem mask.
%
% *Planar Contact Model*
%
% The planar variant of the contact force model assumes that the leg is
% moving in the positive global x direction and stays within the XY-plane.
% Simulink is used to model a spring-damper that connects the end of the
% leg to the floor at the exact location where it lands.  This
% spring-damper is deactivated when the foot leaves the floor.  This
% idealized form of a contact model is good for initial testing.
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Leg%20RR/Contact%20Force%20Model/Planar','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Leg RR/','popup_contact_model','Planar');
set_param('sm_robot_run_4legs/Leg RR','LinkStatus','none')
open_system('sm_robot_run_4legs/Leg RR/Contact Force Model/Planar','force')

%%
% *Six Degree of Freedom Contact Model*
%
% This variant of the contact force model assumes the end of the leg is a
% sphere and detects collision between the sphere and the surface of the
% floor. It models contact and friction force between the sphere and the
% plane.  It is valid for all six degrees of freedom.
%
% <matlab:open_system('sm_robot_run_4legs');open_system('sm_robot_run_4legs/Leg%20RR/Contact%20Force%20Model/SixDOF','force'); Open Subsystem>

set_param('sm_robot_run_4legs/Leg RR/','popup_contact_model','Six DOF');
open_system('sm_robot_run_4legs/Leg RR/Contact Force Model/SixDOF','force')


%% Simulation Results from Simscape Logging
%%
%
% The plot below shows the current drawn by the motor and supplied by the
% battery as the robot runs.
%
set_param('sm_robot_run_4legs/Leg RR/','popup_contact_model','Planar');
close_system('sm_robot_run_4legs/Leg RR/Contact Force Model/Planar')

sm_robot_run_4legs_plot1current;

%%

bdclose all
clear all
close all
