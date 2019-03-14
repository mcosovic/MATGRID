 function [pf, sys] = run_power_flow(user, data)

%--------------------------------------------------------------------------
% Runs AC or DC power flow.
%
% The function proceeds to check power system data and runs AC or DC power
% flow.
%
%  Inputs:
%	- user: user inputs
%	- data: input power system data
%
%  Outputs AC and DC power flow:
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
%	- pf.method: name of the method
%	- pf.grid: power system name
%	- pf.time.pre: preprocessing time
%	- pf.time.conv: convergence time
%	- pf.time.pos: postprocessing time
%
%  Outputs DC power flow:
%	- sys.bus with additional column: (16)shift vector(Psh)
%	- sys.branch with additional column: (11)1/(tij*xij)
%	- pf.bus with columns:
%	  (1)bus voltage angles(Ti); (2)active power injection(Pi);
%	  (3)active power generation(Pg)
%	- pf.branch with column: (1)active power flow(Pij)
%
%  Outputs AC power flow:
%	- sys.branch with additional columns:
%	  (11)branch admittance(yij); (12)charging susceptance(bsi);
%	  (13)complex tap ratio(aij); (14)yij + bsi; (15)yij/aij^2;
%	  (16)-yij/conj(aij); (17)-yij/aij
%	- sys.ysh: shunt elements vector
%	- sys.Yij: Ybus matrix with only non-diagonal elements
%	- sys.Yii: Ybus matrix with only diagonal elements
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
%
% The local function which is used in power flow modules.
%--------------------------------------------------------------------------


%--------------------------Processing User Data----------------------------
 [data] = input_power_grid(data, user.module_flow);
%--------------------------------------------------------------------------


%----------------------------Power System Data-----------------------------
 [sys] = branch_container(data.system);
 [sys] = bus_container(data.system, data.stop, sys);
 [sys] = numbering(data.system, sys);
 [sys] = bus_generator(sys);
%--------------------------------------------------------------------------


%------------------------------AC Power Flow-------------------------------
 if user.module_flow == 1
	[sys] = ybus_ac(sys);
	[pf]  = newton_raphson(user, sys);
	[pf]  = processing_acpf(sys, pf);
 end
%--------------------------------------------------------------------------


%------------------------------DC Power Flow-------------------------------
 if user.module_flow == 2
	[sys] = ybus_shift_dc(sys);
	[pf]  = solve_dcpf(sys);
	[pf]  = processing_dcpf(sys, pf);
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.save_flow, data.case);

 if user.bus_flow == 1 || user.branch_flow == 1
	terminal_info(pf, sys, user.module_flow, user.grid_flow, 1)
 end
 if user.bus_flow == 1
	terminal_bus_pf(pf, sys, user.module_flow)
 end
 if user.branch_flow == 1
	terminal_flow(pf, sys, user.module_flow)
 end

 diary_off(user.save_flow);
%--------------------------------------------------------------------------