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
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- pf.Pij: active power flows
%   - pf.Pi: active power injections
%   - pf.Pg: generation active powers
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-20
% Last revision by Mirsad Cosovic on 2019-04-21
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------Active Power Flow at Branches-----------------------
 i = sys.branch(:,2);
 j = sys.branch(:,3);

 pf.Pij = sys.branch(:,11) .* (pf.Va(i) - pf.Va(j) - sys.branch(:,8));
%--------------------------------------------------------------------------


%------------------Injection Active Power with Slack Bus-------------------
 pf.Pi = sys.Ybu * pf.Va + sys.bus(:,16) + sys.bus(:,7);
%--------------------------------------------------------------------------


%-----------------Generation Active Power with Slack Bus-------------------
 pf.Pg = sys.bus(:,11);
 pf.Pg(sys.sck(1)) = pf.Pi(sys.sck(1)) + sys.bus(sys.sck(1),5);
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 pf.time.pos = toc;
%--------------------------------------------------------------------------