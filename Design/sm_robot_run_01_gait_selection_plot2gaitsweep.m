% Code to plot simulation results from sm_robot_run_01_gait_selection
%% Plot Description:
%
% The plots below show the effect of stance height and spring stiffness on
% the percentage of time in a gait period that the leg is touching the
% floor.  A deeper crouch and a stiffer spring will lead to a higher leap
% and less time spent on the floor.
%
% Copyright 2017-2018 The MathWorks, Inc.

%% Get simulation results

% Save initial values
k_bkg = k;
y0_bkg = y0;

% Define parameter sweep
% Height of leg in stance (compression)
y0_vec = [0.75 0.8 0.85 0.9];

% Equivalent spring stiffness for leg model
k_vec = [0.5:0.5:3]*1e4;

% Run parameter sweep
numRuns = 0;
clear legend_info
for j=1:length(y0_vec)
    y0 = y0_vec(j);
    for i=1:length(k_vec)
        k=k_vec(i);
        numRuns=numRuns+1;
        sim('sm_robot_run_01_gait_selection');
        t_stance_vec(i,j) = t_stance;
        t_final_vec(i,j) = tout(end);
        cg_x(numRuns)=logsout_sm_robot_run_01_gait_selection.get('X');
        cg_y(numRuns)=logsout_sm_robot_run_01_gait_selection.get('Y');
    end
    y0_vec(j) = y0;
    legend_info{j} = ['Stance Height = ' num2str(y0*100) '%'];
end
k = k_bkg;
y0 = y0_bkg;

%% Plot trajectory of gait
% Reuse figure if it exists, else create new figure
if ~exist('h2_sm_robot_run_01_gait_selection', 'var') || ...
        ~isgraphics(h2_sm_robot_run_01_gait_selection, 'figure')
    h2_sm_robot_run_01_gait_selection = figure('Name', 'sm_robot_run_01_gait_selection');
end
figure(h2_sm_robot_run_01_gait_selection)
clf(h2_sm_robot_run_01_gait_selection)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
subplot(2,2,1),hold on;
subplot(2,2,2),hold on;
subplot(2,2,3),hold on;
subplot(2,2,4),hold on;

numRuns=0;
xMin = inf; xMax = 0; yMin = inf; yMax = 0;
for i=1:length(y0_vec)
    subplot(2,2,i)
    for j=1:length(k_vec)
        results_ind = (i-1)*length(k_vec)+(j);
        cg_x_data = cg_x(results_ind).Values.Data;
        cg_y_data = cg_y(results_ind).Values.Data;
        plot(cg_x_data, cg_y_data, 'LineWidth', 1)
    end
    xMin = min(xMin, min(cg_x_data));
    xMax = max(xMax, max(cg_x_data));
    yMin = min(yMin, min(cg_y_data));
    yMax = max(yMax, max(cg_y_data));
end
for i=1:4
    subplot(2,2,i)
    hold off;box on;axis equal;grid on;
    title(['Height in Stance: ' num2str(y0_vec(i)*100) '%']);
    axis([xMin xMax yMin yMax]);
    if (i==1 || i==3 )
        ylabel('Height Upper End (m)');
    end
    if (i==3 || i==4 )
        xlabel('Distance (m)');
    end
    
end
legend([repmat('k=',length(k_vec),1) num2str(k_vec')],'Location','Best');

%% Plot percentage of gait period spent in compression
% Reuse figure if it exists, else create new figure
if ~exist('h3_sm_robot_run_01_gait_selection', 'var') || ...
        ~isgraphics(h3_sm_robot_run_01_gait_selection, 'figure')
    h3_sm_robot_run_01_gait_selection = figure('Name', 'sm_robot_run_01_gait_selection');
end
figure(h3_sm_robot_run_01_gait_selection)
clf(h3_sm_robot_run_01_gait_selection)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
plot(k_vec,100*2*t_stance_vec./t_final_vec, 'LineWidth', 1)
hold on
for i=1:length(k_vec)
    plot(k_vec(i)*ones(size(t_final_vec,2),1),100*2*t_stance_vec(i,:)./t_final_vec(i,:), 'd',...
        'MarkerEdgeColor',temp_colororder(i,:),...
        'MarkerFaceColor',temp_colororder(i,:))
end
hold off
grid on
xlabel('Leg stiffness (N/m)')
ylabel('% of Gait Period with Feet on Floor')
title('Effect of Stance Height and Spring Stiffness on Gait Cycle')
for i=1:length(k_vec)
    legend_info{end+1} = ['k=' num2str(k_vec(i))];
end
legend(legend_info,'Location','Best');

