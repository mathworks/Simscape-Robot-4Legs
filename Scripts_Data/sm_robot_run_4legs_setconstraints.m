function sm_robot_run_4legs_setconstraints(modelname,option)
% Function to change constraints for robot body, camera, and contact force
% model based on desired degrees of freedom for running robot.
%
% Copyright 2017-2018 The MathWorks, Inc.

switch (lower(option))
    case 'planar'
        set_param([modelname '/Leg LF'],'popup_contact_model','Planar');
        set_param([modelname '/Leg RF'],'popup_contact_model','Planar');
        set_param([modelname '/Leg LR'],'popup_contact_model','Planar');
        set_param([modelname '/Leg RR'],'popup_contact_model','Planar');
        set_param([modelname '/Body Constraint/Constraint'],'OverrideUsingVariant','Planar');
        set_param([modelname '/Body Constraint/Camera/Constraint Floor to Camera'],'OverrideUsingVariant','Planar');
        set_param([modelname '/Body Constraint/Camera/Constraint Camera to Body'],'OverrideUsingVariant','Planar');
    case 'planar, six dof contact'
        set_param([modelname '/Leg LF'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg RF'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg LR'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg RR'],'popup_contact_model','Six DOF');
        set_param([modelname '/Body Constraint/Constraint'],'OverrideUsingVariant','Planar');
        set_param([modelname '/Body Constraint/Camera/Constraint Floor to Camera'],'OverrideUsingVariant','Planar');
        set_param([modelname '/Body Constraint/Camera/Constraint Camera to Body'],'OverrideUsingVariant','Planar');
    case 'six dof'
        set_param([modelname '/Leg LF'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg RF'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg LR'],'popup_contact_model','Six DOF');
        set_param([modelname '/Leg RR'],'popup_contact_model','Six DOF');
        set_param([modelname '/Body Constraint/Constraint'],'OverrideUsingVariant','Six_DOF');
        set_param([modelname '/Body Constraint/Camera/Constraint Floor to Camera'],'OverrideUsingVariant','Six_DOF');
        set_param([modelname '/Body Constraint/Camera/Constraint Camera to Body'],'OverrideUsingVariant','Six_DOF');
end
