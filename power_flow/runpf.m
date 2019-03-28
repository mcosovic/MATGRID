 function [data, pf, sys] = runpf(varargin)

%--------------------------------------------------------------------------
% Runs the AC or DC power flow analysis.
%
% The function proceeds to check power system data and settings, builds
% containers, and runs the AC or DC power flow analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- varargin: user input arguments
%
%  Outputs AC and DC power flow:
%	- data: load power system data
%	- pf: see the output variable result.info
%	- sys.branch with columns:
%	  (1)branch number; (2)indexes from bus(i); (3)indexes to bus(j);
%	  (4)branch resistance(rij); (5)branch reactance(xij);
%	  (6)charging susceptance(bsi); (7)tap ratio magnitude(tij);
%	  (8)phase shift angle(fij); (9)original indexes from bus;
%	  (10)original indexes to bus
%	- sys.bus with columns:
%	  (1)bus(i); (2)bus type; (3)initial voltage magnitude(Vo);
%	  (4)initial voltage angle(To); (5)load active power(Pl);
%	  (6)load reactive power(Ql); (7)shunt resistance(rsh);
%	  (8)shunt reactance(xsh); (9)bus voltage limit(Vmin);
%	  (10)bus voltage limit(Vmax); (11)generator active power(Pg);
%	  (12)generator reactive power(Qg); (13)bus reactive power limit(Qmin);
% 	  (14)bus reactive power limit(Qmax); (15)original bus numeration;
%	- sys.Nbr: number of branches
%	- sys.Nbu: number of buses
%	- sys.sck: slack bus variable with bus number and voltage angle value
%	- sys.base: power system base power in (MVA)
%	- sys.stop: stopping iteration criteria
%	- sys.Ybu: Ybus matrix
%
%  Outputs AC power flow:
%	- sys.branch with additional columns:
%	  (11)branch admittance(yij); (12)charging susceptance(bsi);
%	  (13)complex tap ratio(aij); (14)yij + bsi; (15)yij/aij^2;
%	  (16)-yij/conj(aij); (17)-yij/aij
%	- sys.ysh: shunt elements vector
%	- sys.Yij: Ybus matrix with only non-diagonal elements
%	- sys.Yii: Ybus matrix with only diagonal elements
%
%  Outputs DC power flow:
%	- sys.bus with additional column: (16)shift vector(Psh)
%	- sys.branch with additional column: (11)1/(tij*xij)
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------Processing Module Inputs and Settings-------------------
 [data, user] = settings_power_flow(varargin);
 [data]       = load_power_system(data, user.list);
%--------------------------------------------------------------------------


%----------------------------Power System Data-----------------------------
 [sys] = container(data);
%--------------------------------------------------------------------------


%------------------------------AC Power Flow-------------------------------
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr'}, user.list))
	[user] = check_maxiter(user); 
	[sys]  = ybus_ac(sys);

	if ismember('nr', user.list)
	   [pf] = newton_raphson(user, sys);
	elseif ismember('gs', user.list)
	   [pf] = gauss_seidel(user, sys);
	elseif ismember('dnr', user.list)
	   [pf] = decoupled_newton_raphson(user, sys);
	elseif ismember('fdnr', user.list)
	   [pf] = fast_newton_raphson(user, sys);
	end

	[pf] = processing_acpf(sys, pf);
	[pf] = info_acpf(pf);
 end
%--------------------------------------------------------------------------


%------------------------------DC Power Flow-------------------------------
 if ismember('dc', user.list)
	[sys] = ybus_shift_dc(sys);
	[pf]  = solve_dcpf(sys);
	[pf]  = processing_dcpf(sys, pf);
	[pf]  = info_dcpf(pf);
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.list, data.case);

 if any(ismember({'main', 'flow'}, user.list))
	terminal_info(pf, sys, user.list)
 end
 if ismember('main', user.list)
	terminal_bus_pf(pf, sys, user.list)
 end
 if ismember('flow', user.list)
	terminal_flow(pf, sys, user.list)
 end

 diary_off(user.list);
%--------------------------------------------------------------------------