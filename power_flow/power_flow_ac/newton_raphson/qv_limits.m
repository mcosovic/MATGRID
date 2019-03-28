 function [sys] = qv_limits(user, sys)

%--------------------------------------------------------------------------
% Checks constraints according to the type of buses.
%
% The algorithm can force one type of inequalities per run. Reactive power
% constraints are allowed within PV(2) buses and must be Qmin < Qmax, while
% voltage magnitude constraints are allowed within PQ(1) bus and must be
% Vmin < Vmax. The reactive power limits given in the input data are
% related with generator reactive powers.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user data
%	- sys: power system data
%
%  Outputs:
%	- sys.Qcon: bus reactive power injection constraint matrix
%	- sys.Vcon: bus voltage magnitude constraint matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Inequalities for Buses---------------------------
 on = sparse(sys.Nbu,1);

 if ismember('reactive', user.list)
	on(sys.bus(:,2) == 2 & sys.bus(:,13) < sys.bus(:,14)) = 1;
	sys.Qcon = [sys.bus(:,13)-sys.bus(:,6) sys.bus(:,14)-sys.bus(:,6) on];
 elseif ismember('voltage', user.list)
	on(sys.bus(:,2) == 1 & sys.bus(:,9) < sys.bus(:,10)) = 1;
	sys.Vcon = [sys.bus(:,9:10) on];
 end
%--------------------------------------------------------------------------