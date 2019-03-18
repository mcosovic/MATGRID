 function [data] = play_export_set(user, data, sys, msr)

%--------------------------------------------------------------------------
% Builds measurement data.
%
% The function produces measurement sets according to user inputs and
% options.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- data: input power system data
%	- sys: power system data
%	- msr: measurement data
%
%  Outputs
%	- data.legacy.flow with changed columns:
%	  (5)active power flow measurements turn on/off;
%	  (8)reactive power flow measurement turn on/off;
%	- data.legacy.current with changed columns:
%	  (5)line current magnitude measurement turn on/off;
%	- data.legacy.injection with changed columns:
%	  (4)active power injection measurements turn on/off;
%	  (7)reactive power injection measurements turn on/off;
%	- data.legacy.voltage with changed columns:
%	  (4)bus voltage magnitude measurements turn on/off;
%	- data.pmu.current with changed columns:
%	  (5)line current magnitude measurements turn on/off;
%	  (8)line current angle measurements turn on/off;
%	- data.pmu.voltage with changed columns:
%	  (4)bus voltage magnitude measurements turn on/off;
%	  (7)bus voltage angle measurements turn on/off;
%--------------------------------------------------------------------------
% The local function which is used to play with measurements.
%--------------------------------------------------------------------------


%-------------------------Legacy Measurement Set---------------------------
 if user.setleg ~= 0
	data.legacy.flow(:,5) = msr.set{1}(1:2*msr.w);
	data.legacy.flow(:,8) = msr.set{1}(2*msr.w+1:4*msr.w);  
	data.legacy.current(:,5) = msr.set{1}(4*msr.w+1:6*msr.w);
	data.legacy.injection(:,4) = msr.set{1}(6*msr.w+1:6*msr.w+sys.Nbu);
	data.legacy.injection(:,7) = msr.set{1}(6*msr.w+sys.Nbu+1:6*msr.w+2*sys.Nbu);
	data.legacy.voltage(:,4) = msr.set{1}(6*msr.w+2*sys.Nbu+1:end);
 end
%--------------------------------------------------------------------------


%-------------------------Phasor Measurement Set---------------------------
 if user.setpmu ~= 0
	data.pmu.current(:,5) = msr.set{2}(1:2*msr.w);
	data.pmu.current(:,8) = msr.set{2}(2*msr.w+1:4*msr.w);
	data.pmu.voltage(:,4) = msr.set{2}(4*msr.w+1:4*msr.w+sys.Nbu);
	data.pmu.voltage(:,7) = msr.set{2}(4*msr.w+sys.Nbu+1:end);
 end
%--------------------------------------------------------------------------