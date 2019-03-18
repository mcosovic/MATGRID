 function [sys] = run_container(data)

%--------------------------------------------------------------------------
% Builds data containers.
%
% The function builds the branch, bus and generator data containers, and
% defines the new numbering for buses and branches.
%--------------------------------------------------------------------------
%  Input:
%	- data: power system data
%--------------------------------------------------------------------------
%  Outputs:
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
%--------------------------------------------------------------------------
% Main function which is used in AC/DC power flow, non-linear and DC state
% estimation, as well as for the state estimation with PMUs.
%--------------------------------------------------------------------------


%----------------------------Power System Data-----------------------------
 [sys] = branch_container(data.system);
 [sys] = bus_container(data.system, data.stop, sys);
 [sys] = numbering(data.system, sys);
 [sys] = bus_generator(sys);
%--------------------------------------------------------------------------