% Startup script for running robot example
% Copyright 2012-2018 The MathWorks, Inc.

RR4_HomeDir = pwd;

addpath(pwd);
addpath([pwd filesep 'Libraries'])
addpath([pwd filesep 'Scripts_Data'])
addpath([pwd filesep 'Design'])
addpath([pwd filesep 'Design' filesep 'html' filesep 'html'])
addpath([pwd filesep 'html' filesep 'html'])

% Code to use copy within this repository
addpath([pwd filesep 'Libraries' filesep 'CFL_Libs']);
cd([pwd filesep 'Libraries' filesep 'CFL_Libs']);
startup_Contact_Forces

cd(RR4_HomeDir)

%load('sm_robot_run_4legs_param.mat')

sm_robot_run_4legs
