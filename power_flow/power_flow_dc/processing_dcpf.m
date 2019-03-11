 function [pf] = processing_dcpf(sys, pf)

%--------------------------------------------------------------------------
% Computes the DC power flow (active power flows and injections).
%
% The active power flow for the DC problem is defined as Pij = 1/(tij*xij)
% * (Ti - Tj - fij), and holds Pij = -Pji. Also, the active power injection
% is given as Pi = Ybus*T + Psh + rsh. In general, according to the
% convention, a negative power value indicates the power flow direction in
% a bus, while a positive power value means direction out a bus. Finally,
% the postprocessing time is obtained here.
%
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- pf.bus with additional columns:
%	  (2)active power injection(Pi); (3)active power generation(Pg)
%	- pf.branch with column: (1)active power flow(Pij)
%	- pf.time.pos: postprocessing time
%
% The local function which is used in the DC power flow.
%--------------------------------------------------------------------------


%----------------------Active Power Flow at Branches-----------------------
 i = sys.branch(:,2);
 j = sys.branch(:,3);
 T = pf.bus(:,1);

 pf.branch = sys.branch(:,11) .* (T(i) - T(j) - sys.branch(:,8));
%--------------------------------------------------------------------------


%------------------Injection Active Power with Slack Bus-------------------
 pf.bus(:,2) = sys.Ybu * T + sys.bus(:,16) + sys.bus(:,7);
%--------------------------------------------------------------------------


%-----------------Generation Active Power with Slack Bus-------------------
 pf.bus(:,3) = sys.bus(:,11);
 pf.bus(sys.sck(1),3) = pf.bus(sys.sck(1),2) + sys.bus(sys.sck(1),5);
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 pf.time.pos = toc;
%--------------------------------------------------------------------------