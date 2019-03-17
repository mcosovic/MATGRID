 function [data] = input_power_grid(data, flag)

%--------------------------------------------------------------------------
% Checks power system data.
%
% The function checks 'baseMVA', 'bus', 'line', 'inTransformer',
% 'shiftTransformer', 'stop' and 'case' variables defined in the input
% mat-file. If variables 'baseMVA', 'stop' and 'case' are missing, the
% function adds default values.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data
%	- flag: indicate non-linear algorithms
%
%  Output:
%	- data: input power system data
%--------------------------------------------------------------------------
% Check function which is used in power flow and state estimation modules.
%--------------------------------------------------------------------------


%----------------------------Check Power Grid------------------------------
 if ~isfield(data, 'system')
	error('pg:system', 'Invalid power flow data structure, variable "data.system" not found.\n')
 end

 in = isfield(data.system, {'bus', 'line', 'inTransformer', 'shiftTransformer', 'baseMVA'});

 if ~in(1)
	error('pg:bus', 'Invalid power flow data structure, variable "data.system.bus" not found.\n')
 end
 if ~in(2) && ~in(3) && ~in(4)
	error('pg:branch', 'Invalid power flow data structure, variables "data.system.line", "data.system.inTransformer" or "data.system.shiftTransformer" not found.\n')
 end
 if ~in(5)
	data.system.baseMVA = 100;
	warning('pg:baseMVA','The variable "data.system.baseMVA" not found. The algorithm proceeds with default value: %1.f(MVA). \n', data.system.baseMVA)
 end

 if ~isfield(data, 'stop') && flag == 1
	data.stop = 10^-6;
	warning('pg:stop','The variable "data.stop" not found. The algorithm proceeds with default value: %1.e.\n', data.stop)
 end
 if ~isfield(data, 'case')
	data.case = 'unknown';
 end
%--------------------------------------------------------------------------