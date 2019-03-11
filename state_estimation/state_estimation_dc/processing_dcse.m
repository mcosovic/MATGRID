 function [se] = processing_dcse(sys, se)

%--------------------------------------------------------------------------
% Computes the DC power flow (active power flows and injections) after DC
% state estimation
%
% The active power flow for the DC problem is defined as Pij = 1/(tij*xij)
% * (Ti - Tj - fij), and holds Pij = -Pji. Also, the active power injection
% is given as Pi = Ybus*T + Psh + rsh. In general, according to the
% convention, a negative power value indicates the power flow direction in
% a bus, while a positive power value means direction out a bus.
%
%  Inputs:
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.bus with additional column :(2)active power injection(Pi);
%	- se.branch with column: (1)active power flow(Pij)
%
% The local function which is used in the DC state estimation.
%--------------------------------------------------------------------------


%----------------------Active Power Flow at Branches-----------------------
 i = sys.branch(:,2);
 j = sys.branch(:,3);
 T = se.bus(:,1);

 se.branch = sys.branch(:,11) .* (T(i) - T(j) - sys.branch(:,8));
%--------------------------------------------------------------------------


%------------------Injection Active Power with Slack Bus-------------------
 se.bus(:,2) = sys.Ybu * T + sys.bus(:,16) + sys.bus(:,7);
%--------------------------------------------------------------------------