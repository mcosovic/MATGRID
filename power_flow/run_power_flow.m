 function [pf, data, sys] = run_power_flow(user, data)

%--------------------------------------------------------------------------
% Runs the AC or DC power flow analysis.
%
% The function proceeds to check power system data and settings, builds
% containers, and runs the AC or DC power flow.
%--------------------------------------------------------------------------
%  Input:
%	- user: user settings
%--------------------------------------------------------------------------
%  Outputs AC and DC power flow:
%	- pf.method: name of the method
%	- pf.grid: power system name
%	- pf.time.pre: preprocessing time
%	- pf.time.conv: convergence time
%	- pf.time.pos: postprocessing time
%   - data: load power system data
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
%--------------------------------------------------------------------------
%  Outputs AC power flow:
%	- pf.bus with columns:
%	  (1)minimum limits violated at bus; (2)maximum limits violated at bus;
%	  (3)complex bus voltages; (4)apparent power injection(Si);
%	  (5)generation apparent power(Sg); (6)load apparent power(Sl);
%	  (7)apparent power at shunt elements(Ssh)
%	- pf.branch with columns:
%	  (1)line current at branch - from bus(Iij);
%	  (2)line current at branch - to bus(Iji);
%	  (3)line current after branch shunt susceptance - from bus(Iijb);
%	  (4)line current after branch shunt susceptance - to bus(Ijib);
%	  (5)apparent power at branch - from bus(Sij);
%	  (6)apparent power at branch - to bus(Sji);
%	  (7)apparent power after branch shunt susceptance - from bus(Sijb);
%	  (8)apparent power after branch shunt susceptance - from bus(Sjib);
%	  (9)reactive power injection from shunt susceptances - from bus(Qis);
%	  (10)reactive power injection from shunt susceptances - to bus(Qjs);
%	  (11)apparent power of losses(Sijl)
%	- pf.No: number of iterations
%	- sys.branch with additional columns:
%	  (11)branch admittance(yij); (12)charging susceptance(bsi);
%	  (13)complex tap ratio(aij); (14)yij + bsi; (15)yij/aij^2;
%	  (16)-yij/conj(aij); (17)-yij/aij
%	- sys.ysh: shunt elements vector
%	- sys.Yij: Ybus matrix with only non-diagonal elements
%	- sys.Yii: Ybus matrix with only diagonal elements
%--------------------------------------------------------------------------
%  Outputs DC power flow:
%	- pf.bus with columns:
%	  (1)bus voltage angles(Ti); (2)active power injection(Pi);
%	  (3)active power generation(Pg)
%	- pf.branch with column: (1)active power flow(Pij)
%	- sys.bus with additional column: (16)shift vector(Psh)
%	- sys.branch with additional column: (11)1/(tij*xij)
%--------------------------------------------------------------------------
% The local function which is used in power flow modules.
%--------------------------------------------------------------------------


%------------------Processing Module Inputs and Settings-------------------
 [data] = load_power_grid(data, user.pf);
%--------------------------------------------------------------------------


%----------------------------Power System Data-----------------------------
 [sys] = run_container(data);
%--------------------------------------------------------------------------


%------------------------------AC Power Flow-------------------------------
 if user.pf == 1
	[sys] = ybus_ac(sys);
	[pf]  = newton_raphson(user, sys);
	[pf]  = processing_acpf(sys, pf);
 end
%--------------------------------------------------------------------------


%------------------------------DC Power Flow-------------------------------
 if user.pf == 2
	[sys] = ybus_shift_dc(sys);
	[pf]  = solve_dcpf(sys);
	[pf]  = processing_dcpf(sys, pf);
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.save, data.case);

 if user.main == 1 || user.flow == 1
	terminal_info(pf, sys, user.pf, user.grid, 1)
 end
 if user.main == 1
	terminal_bus_pf(pf, sys, user.pf)
 end
 if user.flow == 1
	terminal_flow(pf, sys, user.pf)
 end

 diary_off(user.save);
%--------------------------------------------------------------------------