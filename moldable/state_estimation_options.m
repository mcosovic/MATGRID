 function [user, data] = state_estimation_options(user, load_data)          %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data and measurements.
%
% The function checks 'estimation', 'grid', 'bus', 'branch', 'estimate',
% 'evaluation', 'save', 'linear', and initialization variables 'flat',
% 'warm', 'random' defined in the 'state_estimation.m', and loads power
% system data and measurements according to the grid variable. Default
% values are: estimation = 1; grid = 'ieee30_41'; bus = 1; branch = 0;
% estimate = 0; evaluation = 0; save = 0; linear = 0; flat = [0 1]; warm =
% 1; random = [-0.5 0.5 0.95 1.05];
%
%  Input:
%	- user.estimate: user inputs
%
%  Outputs:
%	- user.module_estimate: non-linear, DC, or state estimation with PMUs
%	- user.grid_estimate: name of the power system data with measurements
%	- user.bus_estimate: bus data display
%	- user.branch_estimate: branch data display
%	- user.estimation_estimate: estimation display
%	- user.evaluation_estimate: evaluation display
%	- user.save_estimate: save display data
%	- user.linear_estimate: export the system model of the state estimation
%	- user.flat_estimate: initial point, flat start
%	- user.warm_estimate: initial point, warm start
%	- user.random_estimate: initial point, random perturbation
%	- data: power system data with measurements
%
% Check function which is used in state estimation modules.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 in = isfield(user, {'grid_estimate', 'module_estimate', 'bus_estimate', 'branch_estimate', 'estimation_estimate' 'evaluation_estimate', 'save_estimate', 'linear_estimate'});
%--------------------------------------------------------------------------


%----------------------------Check Grid Input------------------------------
 if ~in(1) || ~ischar(user.grid_estimate)
	user.grid_estimate = 'ieee30_41';
	warning('se:grid', 'Invalid "estimate.grid" data structure. The algorithm proceeds with default power system: %s.\n', user.grid_estimate)
 end
%--------------------------------------------------------------------------


%---------------------------Check Module Input-----------------------------
 if ~in(2) || ~isnumeric(user.module_estimate) || length(user.module_estimate) ~= 1 || all(user.module_estimate ~= [1 2 3])
	user.module_estimate = 1;
	warning('se:moduleAllowed', ['The variable "estimate.module" requires at least one input argument: ' ...
	'\n\t"estimate.module = 1" - non-linear state estimation'...
	'\n\t"estimate.module = 2" - PMU state estimation'...
	'\n\t"estimate.module = 3" - DC state estimation'...
	'\nThe algorithm proceeds with default option, non-linear state estimation.'])
 end
%--------------------------------------------------------------------------


%--------------------------Check Terminal Inputs---------------------------
 if ~in(3) || ~isnumeric(user.bus_estimate) || length(user.bus_estimate) ~= 1 || all(user.bus_estimate ~= [0 1])
	user.bus_estimate = 0;
 end
 if ~in(4) || ~isnumeric(user.branch_estimate) || length(user.branch_estimate) ~= 1 || all(user.branch_estimate ~= [0 1])
	user.branch_estimate = 0;
 end
 if ~in(5) || ~isnumeric(user.estimation_estimate) || length(user.estimation_estimate) ~= 1 || all(user.estimation_estimate ~= [0 1])
	user.evaluation_estimate = 1;
 end
 if ~in(6) || ~isnumeric(user.evaluation_estimate) || length(user.evaluation_estimate) ~= 1 || all(user.evaluation_estimate ~= [0 1])
	user.branch_estimate = 0;
 end
 if ~in(7) || ~isnumeric(user.save_estimate) || length(user.save_estimate) ~= 1 || all(user.save_estimate ~= [0 1])
	user.save_flow = 0;
 end
%--------------------------------------------------------------------------


%---------------------------Check Export Inputs----------------------------
 if ~in(8) || ~isnumeric(user.linear_estimate) || length(user.linear_estimate) ~= 1 || all(user.linear_estimate ~= [1 2])
	user.linear_estimate = 0;
 end
%--------------------------------------------------------------------------


%----------------------------Check Start Input-----------------------------
 startAC = isfield(user, {'flat_estimate', 'warm_estimate', 'random_estimate'});

 if all(~startAC) && user.module_estimate == 1
	user.warm_estimate = 1;
	warning('se:startAllowed', ['The variable for the Gauss-Newton initialization requires at least one input argument: ' ...
			'\n\t"estimate.flat" - all voltage angles and magnitudes have the same initial point [angle magnitude]'...
			'\n\t"estimate.warm" - the initial point is defined as the one applied in AC power flow, or it is defined from the exact values'...
			'\n\t"estimate.random" - random perturbation of initial point within limits [minimum angle, maximum angle, minimum magnitude, maximum magnitude]'...
			'\nThe algorithm proceeds with the same initial point as the one applied in AC power flow.'])
 end

 if startAC(1) && (~isvector(user.flat_estimate) || ~(length(user.flat_estimate) == 2))
	user.flat_estimate = [0 1];
	warning('se:startFlat','The variable expression "estimate.flat" has invalid type. The algorithm proceeds with default value: [%1.f %1.f].\n', user.flat_estimate(1), user.flat_estimate(2))
 end
 if startAC(2) && (~isvector(user.warm_estimate) || ~(length(user.warm_estimate) == 1) || all(user.warm_estimate ~= [1 2]))
	user.warm_estimate = 1;
	warning('se:startWarm','The variable expression "estimate.warm" has invalid type. The algorithm proceeds with the same initial point as the one applied in AC power flow.\n')
 end
 if startAC(3) && (~isvector(user.random_estimate) || ~(length(user.random_estimate) == 4))
	user.random_estimate = [-0.5 0.5 0.95 1.05];
	warning('se:startRandom','The variable expression "estimate.random" has invalid type. The algorithm proceeds with default value: [%1.2f %1.f %1.2f %1.2f].\n', user.random_estimate(1), user.random_estimate(2), user.random_estimate(3), user.random_estimate(4))
 end
%--------------------------------------------------------------------------


%--------------------------------Load Data---------------------------------
 if load_data == 1
	try
	   load(user.grid_estimate)
	catch
	   error('se:GridLoad', 'The power system data "%s" not found.\n', user.grid_estimate)
	end
 else
	data = [];
 end
%--------------------------------------------------------------------------