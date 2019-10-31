function [xy_data] = Extr_Data_LinkEndHole(W, varargin)
%Extr_Data_LinkEndHole Produce extrusion data for a link end with a hole
%   [xy_data] = Extr_Data_LinkEndHole(W, r, <l>)
%   This function returns x-y data for a rounded link end with a hole.  The
%   link end length can be extended with parameter l.
%   You can specify:
%       Width       W
%       Hole radius r
%       Length      l
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_LinkEndHole
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_LinkEndHole(2,0.5,0.5, 'plot')
%
% Copyright 2014-2019 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    W = 2;
    r = 0.5;
    l = 0.5;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
end
if nargin==1
    l=0;
    r=0;
end
if nargin==2
    if ischar(varargin{1})   % PLOT REQUESTED
        r = 0;
        l = 0;
        showplot = varargin{1};
    else
        r = varargin{1};    % r SPECIFIED
        l = 0;
        showplot = 'n';
    end
end
if nargin==3
    if ischar(varargin{2})   % PLOT REQUESTED
        r = varargin{1};    % r SPECIFIED
        l = 0;
        showplot = varargin{2};
    else
        r = varargin{1};    % r SPECIFIED
        l = varargin{2};    % l SPECIFIED
        showplot = 'n';
    end
end

if nargin==4
    r = varargin{1};    % l SPECIFIED
    l = varargin{2};    % l SPECIFIED
    showplot= varargin{3};
end

% Rounded ends and outer boundary of member
theta = (-89:1:+90)' * pi/180; % CCW
linkend = repmat([W/2+l 0], length(theta), 1) + W/2 * [cos(theta), sin(theta)];
boundary = [0 0;0 -W/2; W/2+l -W/2; linkend; 0 W/2;0 0];

% Circular hole
theta = (180:-1:-180)' * pi/180; % CW
hole = repmat([W/2+l 0], length(theta), 1) + r * [cos(theta), sin(theta)];

if(r>0)
    xy_data = [boundary; hole];
else
    xy_data = [boundary];
end

% Plot diagram to show parameters and extrusion
if (nargin == 0 || strcmpi(showplot,'plot'))
    % Figure name
    figString = ['h1_' mfilename];
    % Only create a figure if no figure exists
    figExist = 0;
    fig_hExist = evalin('base',['exist(''' figString ''')']);
    if (fig_hExist)
        figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
    end
    if ~figExist
        fig_h = figure('Name',figString);
        assignin('base',figString,fig_h);
    else
        fig_h = evalin('base',figString);
    end
    figure(fig_h)
    clf(fig_h)
    
    % Plot extrusion
    patch(xy_data(:,1),xy_data(:,2),[1 1 1]*0.95,'EdgeColor','none');
    hold on
    plot(xy_data(:,1),xy_data(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
    
    axis([-0.1 1.9 -1.1 1.1]*(W/2+l/2));
    axis('equal');
    
    % Show parameters
    plot([W/8 W/8],[-W/2 W/2],'b-d','MarkerFaceColor','b');
    text(W/3.8,W/4,'{\color{blue}W}');
    if(r>0)
        plot([W/2+l W/2+r*(cosd(60))+l],[0 r*sind(60)],'k-d','MarkerFaceColor','k');
        text(W/2+l+r*(cosd(60))/2,r*sind(60)/2,'Hole radius','HorizontalAlignment','right');
    end
    if(l>0)
        plot([0 l],[0.01 0.01]*W,'r-d','MarkerFaceColor','r');
        text(l/4,0.025*W,'{\color{red}l}');
    end
    plot([l l+W/2],[0.01 0.01]*W,'r-d','MarkerFaceColor','r');
    text(l+3*W/8,0.025*W,'{\color{red}W/2}');
    title('[xy\_data] = Extr\_Data\_LinkHolesEnd(W, <r>, <l>);');
    
    hold off
    box on
    clear xy_data
end


