function radarplot(varargin)
%RADARPLOT produces a radar-like plot of data from distance and direction  
%
%    RADARPLOT(DISTANCE,DIRECTION [,STYLEPICKER])
%
%       DISTANCE & DIRECTION are numeric vector inputs which give
%                   (respectively) the distance along the radial axes and
%                   the angle of the data points to be plotted on the radar
%                   plot.
%
%       STYLEPICKER is an optional scalar input. It the value is equal to 1
%                   then the plot will be styled with a black background,
%                   cyan axes and green scatter points.
%  Author  - Adam Leadbetter (alead@bodc.ac.uk)
%  Version - 2010Sept21
  errText  =   'RADARPLOT requires 2 or 3 inputs...';
  if(nargin  <  2)
    error(['Error: Too few input arguments.' errText]);
  elseif(nargin  >  3)
     error(['Error: Too many input arguments.' errText]);
  end
  speed  =  varargin{1};
  direction  =  varargin{2};
  if(nargin  ==  3)
    stylePicker   =  varargin{3};
  else
    stylePicker   =  0;
  end
  
  if(~isvector(speed) || ~isnumeric(speed))
    error(['Error: RADARPLOT requires the input parameter DISTANCE '... 
      'to be a numeric vector...']);
  end
  if(~isvector(direction) || ~isnumeric(direction))
    error(['Error: RADARPLOT requires the input parameter DIRECTION '... 
      'to be a numeric vector...']);
  end
  
  if(length(speed)  ~=  length(direction))
    error(['Error: Inputs DISTANCE and DIRECTION to function RADARPLOT '...
      'are required to be of equal length...']);
  end
  
  if(~isscalar(stylePicker)  ||  ~isnumeric(stylePicker))
    error(['Error: RADARPLOT requires the input parameter STYLEPICKER '... 
      'to be a numeric scalar...']);
  end
  
  gid  =  figure;
  if(stylePicker  ==  1)
    style  =  [0.5,1,0.9];
    styleS  =  'g';
    whitebg(gid,'k');
  else
    style  =  'k';
    styleS  =  'b';
  end
  
  whos
  
  rMax  =  ceil(max(mod(speed,0)));
  
  cosMask  =  unique([find(direction <= 90),find(direction  >=  270)]);
  sinMask  =  find(direction  <  270  &  direction  >  90);
  
  u(cosMask)  =  speed(cosMask)  .*  cosd(direction(cosMask));
  v(cosMask)  =  speed(cosMask)  .*  sind(direction(cosMask));
  
  u(sinMask)  =  speed(sinMask)  .*  cosd(direction(sinMask));
  v(sinMask)  =  speed(sinMask)  .*  sind(direction(sinMask));
  
  circle([0,0],rMax,360,style);
  hold on;
  circle([0,0],rMax * (2/3),360,style);
  circle([0,0],rMax * (1/3),360,style);
  radialaxis(0,rMax,style);
  radialaxis(45,rMax,style);
  radialaxis(90,rMax,style);
  radialaxis(135,rMax,style);
  radialaxis(180,rMax,style);
  radialaxis(225,rMax,style);
  radialaxis(270,rMax,style);
  radialaxis(315,rMax,style);
  
  scatter(u,v,[],styleS);
  
  hold off;
  
  function H=circle(center,radius,NOP,style)
%--------------------------------------------------------------------------
% H=CIRCLE(CENTER,RADIUS,NOP,STYLE)
% This routine draws a circle with center defined as
% a vector CENTER, radius as a scaler RADIS. NOP is 
% the number of points on the circle. As to STYLE,
% use it the same way as you use the rountine PLOT.
% Since the handle of the object is returned, you
% use routine SET to get the best result.
%
%   Usage Examples,
%
%   circle([1,3],3,1000,':'); 
%   circle([2,4],2,1000,'--');
%
%   Zhenhai Wang <zhenhai@ieee.org>
%   Version 1.00
%   December, 2002
%--------------------------------------------------------------------------
    if (nargin <3),
     error('Please see help for INPUT DATA.');
    elseif (nargin==3)
        style='b-';
    end;
    THETA=linspace(0,2*pi,NOP);
    RHO=ones(1,NOP)*radius;
    [X,Y] = pol2cart(THETA,RHO);
    X=X+center(1);
    Y=Y+center(2);
    H=plot(X,Y);
    set(H,'Color',style);
    axis square;
%--------------------------------------------------------------------------
function H  =  radialaxis(angle,maxx,plotColour)
    x(1)  =  0;
    y(1)  =  0;
    if(angle  >=  270  &&  angle  <=  90)
      x(2)  =  maxx * cosd(angle);
      y(2)  =  maxx * sind(angle);
    else
      y(2)  =  maxx * cosd(angle);
      x(2)  =  maxx * sind(angle);
    end
    H  =  plot(x,y);
    set(H,'Color',plotColour);