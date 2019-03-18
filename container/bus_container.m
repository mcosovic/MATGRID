 function [sys] = bus_container(data, stop, sys)

%--------------------------------------------------------------------------
% Builds the bus and generator data containers according to inputs.
%
% According to status, outage generators are removed from outputs
% variables. If generator data does not exist, the sys.bus variable
% automatically expands with zeros (see bus_generator function). Further,
% all corresponding values are normalized to per-unit system.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data that contains buses and/or generators
%	- stop: stopping iteration criteria for the non-linear algorithms
%	- sys: power system data
%
%  Outputs:
%	- sys.base: power system base power in (MVA)
%	- sys.stop: stopping iteration criteria for the non-linear algorithms
%	- sys.sck: slack bus variable with bus number and voltage angle value
%	- sys.bus with columns:
%	  (1)bus(i); (2)bus type; (3)initial voltage magnitude(Vo);
%	  (4)initial voltage angle(To); (5)load active power(Pl);
%	  (6)load reactive power(Ql); (7)shunt resistance(rsh);
%	  (8)shunt reactance(xsh); (9)bus voltage limit(Vmin);
%	  (10)bus voltage limit(Vmax)
%	- sys.generator with columns:
%	  (1)bus(i); (2)generator active power(Pg);
%	  (3)generator reactive power(Qg); (4)bus reactive power limit(Qmin);
%	  (5)bus reactive power limit(Qmax)
%--------------------------------------------------------------------------
% Main function which is used in AC/DC power flow, non-linear and DC state
% estimation, as well as for the state estimation with PMUs.
%--------------------------------------------------------------------------


%--------------------------------Bus Data----------------------------------
 sys.bus = data.bus;
 sys.Nbu = size(data.bus,1);

 sys.bus(:,5:8) = sys.bus(:,5:8) ./ data.baseMVA;
 sys.bus(:,4)   = pi/180 * sys.bus(:,4);
%--------------------------------------------------------------------------


%-----------------------------Generator Data-------------------------------
 if isfield(data, 'generator')
	status  = logical(data.generator(:,7));

	sys.generator = data.generator(status,:);
	sys.generator(:,2:5) = sys.generator(:,2:5) ./ data.baseMVA;
 else
	sys.bus(:,11:14) = zeros(sys.Nbu,4);
 end
%--------------------------------------------------------------------------


%--------------------------------Slack Bus---------------------------------
 sys.sck = find(sys.bus(:,2) == 3);
 sys.sck = [sys.sck sys.bus(sys.sck,4)];
%--------------------------------------------------------------------------


%--------------------------------User Data---------------------------------
 sys.base = data.baseMVA;
 sys.stop = stop;
%--------------------------------------------------------------------------