 function [sys] = qv_limits(user, sys)

%--------------------------------------------------------------------------
% Checks constraints according to the type of buses.
%
% The algorithm can force one type of inequalities per run, where reactive
% power constraints take precedence, for the case when both included.
% Reactive power constraints are allowed within PV(2) buses and must be
% Qmin < Qmax, while voltage magnitude constraints are allowed within PQ(1)
% bus and must be Vmin < Vmax.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user data
%	- sys: power system data
%
%  Outputs:
%	- sys.Qcon: bus reactive power injection constraint matrix
%	- sys.Vcon: bus voltage magnitude constraint matrix
%--------------------------------------------------------------------------
% The local function which is used in the Newton-Raphson algorithm.
%--------------------------------------------------------------------------


%-------------------------Inequalities for Buses---------------------------
 on = sparse(sys.Nbu,1);

 if user.limit == 1
	on(sys.bus(:,2) == 2 & sys.bus(:,13) < sys.bus(:,14)) = 1;
	sys.Qcon = [sys.bus(:,13:14) on];
 elseif user.limit == 2
	on(sys.bus(:,2) == 1 & sys.bus(:,9) < sys.bus(:,10)) = 1;
	sys.Vcon = [sys.bus(:,9:10) on];
 end
%--------------------------------------------------------------------------