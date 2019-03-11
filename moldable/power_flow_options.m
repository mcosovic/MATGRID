 function [user, data] = power_flow_options(user)                           %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data
%
% The function checks 'flow', 'grid', 'reactive', 'voltage', 'bus',
% 'branch' and 'save' variables defined in the 'power_flow.m', and loads
% power system data according to the grid variable. Default values are:
% flow = 1; grid = 'ieee30_41'; reactive = 0; voltage = 0; bus = 1; branch
% = 0; save = 0.
%
%  Input:
%	- user: all user inputs
%
%  Outputs:
%	- user.module_flow: AC or DC power flow
%	- user.grid_flow: name of the power system data
%	- user.reactive_flow: bus reactive power limits
%	- user.voltage_flow: bus voltage magnitude limits
%	- user.bus_flow: bus data display
%	- user.branch_flow: branch data display
%	- user.save_flow: save display data
%	- data: power system data
%
% Check function which is used in power flow module.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 in = isfield(user, {'grid_flow', 'module_flow', 'reactive_flow', 'voltage_flow', 'bus_flow', 'branch_flow', 'save_flow'});
%--------------------------------------------------------------------------


%----------------------------Check Grid Input------------------------------
 if ~in(1) || ~ischar(user.grid_flow)
	user.grid_flow = 'ieee30_41';
	warning('pf:grid', 'Invalid "grid" data structure. The algorithm proceeds with default power system: %s.\n', user.grid_flow)
 end
%--------------------------------------------------------------------------


%---------------------------Check Module Input-----------------------------
 if ~in(2) || ~isnumeric(user.module_flow) || length(user.module_flow) ~= 1 || all(user.module_flow ~= [1 2])
	user.module_flow = 1;
	warning('pf:moduleAllowed', ['The variable "flow.module" requires at least one input argument: ' ...
	'\n\t"flow.module = 1" - AC power flow'...
	'\n\t"flow.module = 2" - DC power flow'...
	'\nThe algorithm proceeds with default option, AC power flow.'])
 end
%--------------------------------------------------------------------------


%---------------------------Check Limit Inputs-----------------------------
 if ~in(3) || ~isnumeric(user.reactive_flow) || length(user.reactive_flow) ~= 1 || all(user.reactive_flow ~= [0 1])
	user.reactive_flow = 0;
 end
 if ~in(4) || ~isnumeric(user.voltage_flow) || length(user.voltage_flow) ~= 1 || all(user.voltage_flow ~= [0 1])
	user.voltage_flow = 0;
 end
%--------------------------------------------------------------------------


%--------------------------Check Terminal Inputs---------------------------
 if ~in(5) || ~isnumeric(user.bus_flow) || length(user.bus_flow) ~= 1 || all(user.bus_flow ~= [0 1])
	user.bus_flow = 0;
 end
 if ~in(6) || ~isnumeric(user.branch_flow) || length(user.branch_flow) ~= 1 || all(user.branch_flow ~= [0 1])
	user.branch_flow = 0;
 end
 if ~in(7) || ~isnumeric(user.save_flow) || length(user.save_flow) ~= 1 || all(user.save_flow ~= [0 1])
	user.save_flow = 0;
 end
%--------------------------------------------------------------------------


%--------------------------------Load Data---------------------------------
 try
	load(user.grid_flow)
 catch
	error('pf:gridLoad', 'The power system data "%s" not found.\n', user.grid_flow)
 end
%--------------------------------------------------------------------------