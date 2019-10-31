function sm_robot_run_4legs_param_def_load(modelname)
% Loads default parameters for running robot models
% Copyright 2017-2018 The MathWorks, Inc.

filename = 'sm_robot_run_4legs_param_def.mat';

varset1 = {'L', 'g', 'm', 'k', 'x0', 'y0', 'u0', 'v0'};
varset2 = {'T_cg', 'T_stance', 'leg_angle0', 'leg_vel0'};
varset3 = {'TimeValues', 'DataValues', 'th1', 'th2', 'm2', 'l2', 'm1', 'l1', 'T_cg'};
varset4 = {'T_cg', 'bw', 'J', 'th_dot0', 'N', 't_th', 'u_th', 't_w', 'u_w'};
varsetRobot = {...
    'M', 'l1', 'l2', 'm1', 'm2',...
    'L_back', 'L_stance', ...
    'T_cg', 't_th', 'th2', 'th1_0', 'th2_0', ...
    'u0', 't_final', 'ground', 'u_th', 'u_w', 't_w', ...
    'bw', 'J', 'N', 'Trq_propulsive', 'knee_torque', 'joint_damping', 'k2'};

switch (lower(modelname))
    case 'sm_robot_run_01_gait_selection'
        varset = varset1;
    case 'sm_robot_run_02_aerial_trajectory'
        varset = varset2;
    case 'sm_robot_run_03_leg_inverse_dyn'
        varset = varset3;
    case 'sm_robot_run_04_actuator'
        varset = varset4;
    case 'sm_robot_run_4legs'
        varset = varsetRobot;
    case 'save defaults'
        [p, f, e] = fileparts(which(filename));
        filename_with_path = [p filesep f e];
        disp(['Saving default values to ' filename_with_path]);
        defaultvars = sort(unique({varset1{:},varset2{:},varset3{:},varset4{:},varsetRobot{:}}));
        for i=1:length(defaultvars)
            if(i==1)
                delete(filename_with_path)
                evalin('base',['save(''' filename_with_path ''',''' defaultvars{i} ''');']);
%                disp(['save(''' filename_with_path ''',''' defaultvars{i} ''');']);
            else
                evalin('base',['save(''' filename_with_path ''',''' defaultvars{i} ''', ''-append'');']);
            end
        end
end

if(~strcmpi(modelname,'save defaults'))
    disp(['Loading default parameters for ' modelname ]);
    % Load required variables
    for i=1:length(varset)
        evalin('base',['load(''' filename ''',''' varset{i} ''');']);
        %disp(['load(''' filename ''',''' varset{i} '''); ']);
    end
end
