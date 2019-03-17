 function [var, user, data] = state_estimation_options(var)                 %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data and measurements.
%
% The function checks 'nonlinear', 'pmu', 'dc' 'bus', 'branch', 'estimate',
% 'error', 'save', 'export', 'export slack', initialization variables
% 'flat', 'warm', 'exact', 'random', given as input arguments of the
% function leeloo in the 'state_estimation.m', and loads power system data
% and measurements according to the grid variable. Default inputs are:
% 'ieee30_41'; 'nonlinear'; 'warm'.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user inputs
%
%  Outputs:
%   - user.method: state estimation indicator
%	- user.se: non-linear, DC, or state estimation with PMUs
%	- user.grid: name of the power system data with measurements
%	- user.bus: bus data display
%	- user.branch: branch data display
%	- user.estimate: estimation display
%	- user.error: evaluation display
%	- user.save: save display data
%	- user.export: export the system model without slack bus
%	- user.exports: export the system model with slack bus
%	- user.flat: initial point, flat start
%	- user.warm: initial point, warm start
%	- user.exact: initial point, exact start
%	- user.random: initial point, random perturbation
%   - user.varleg: legacy measurement variances indicator
%   - user.varpmu: phasor measurement variances indicator
%   - user.setleg: legacy measurement set indicator
%   - user.setpmu: phasor measurement set indicator
%	- data: power system data with measurements
%--------------------------------------------------------------------------
% Check function which is used in state estimation modules.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str,var, 'un', 0);
%--------------------------------------------------------------------------


%----------------------------Default Settings------------------------------
 user.method   = 1;
 user.se       = 1;
 user.start    = 1;
 user.bus      = 0;
 user.branch   = 0;
 user.estimate = 0;
 user.error    = 0;
 user.save     = 0;
 user.export   = 0;
 user.exports  = 0;
 user.varleg   = 0;
 user.varpmu   = 0;
 user.setpmu   = 0;
 user.setleg   = 0;
%--------------------------------------------------------------------------


%-------------------------------Empty Input--------------------------------
 if isempty(var)
	var{1} = 'ieee30_41';
	warning('se:empty', ['Invalid input data structure. The algorithm '...
	'proceeds with %s power system. %s.\n'], strcat(var{1},'.mat'))
 end
 var = string([var, ' ']);
%--------------------------------------------------------------------------


%-------------------Check AC, DC or PMU State Estimation-------------------
 in = ismember({'nonlinear', 'dc', 'pmu'}, var);

 if in(1)
	user.se = 1;
 elseif in(2)
	user.se = 2;
 elseif in(3)
	user.se = 3;
 else
	warning('se:module', ['The state estimation requires "nonlinear", ' ...
	'"dc" or "pmu" input arguments for the non-linear, DC, or linear ' ...
	'state estimation only with PMUs. The algorithm proceeds with the ' ...
	'non-linear state estimation.\n'])
 end
%--------------------------------------------------------------------------


%---------------------------Check Start Inputs-----------------------------
 in = ismember(var, {'warm', 'exact', 'flat', 'random'});
 v1 = find(in, 1, 'first');
 start = var(v1);

 if strcmp(start, 'warm')
	user.start = 1;
 elseif strcmp(start, 'exact')
	user.start = 2;
 elseif strcmp(start, 'flat')
	user.start = 3;
	user.flat = str2num(var(v1+1));                                         %#ok<*ST2NM>
 elseif strcmp(start, 'random')
	user.start = 4;
	user.random = str2num(var(v1+1));
 end

 if user.start == 3 && ~isempty(user.flat) && (~isvector(user.flat) || ~(length(user.flat) == 2))
	user.flat = [0 1];
	warning('se:startFlat', ['The value pair argument of the variable ' ...
	'"flat" has invalid type. The algorithm proceeds with default ' ...
	'value: [%1.f %1.f].\n'], 0,1)
 elseif user.start == 3 && isempty(user.flat)
	user.flat = [0 1];
 end

 if user.start == 4 && ~isempty(user.random) && (~isvector(user.random) || ~(length(user.random) == 4))
	user.random = [-0.5 0.5 0.95 1.05];
	warning('se:startFlat', ['The value pair argument of the variable ' ...
	'"random" has invalid type. The algorithm proceeds with default ' ...
	'value: [%1.2f %1.2f %1.2f %1.2f].\n'], -0.5,0.5,0.95,1.05)
 elseif user.start == 4 && isempty(user.random)
	user.random = [-0.5 0.5 0.95 1.05];
 end
%--------------------------------------------------------------------------


%---------------------Check Terminal and Export Inputs---------------------
 in = ismember({'bus', 'branch', 'estimate', 'error', 'save', 'export', 'export slack'}, var);

 if in(1)
	user.busse = 1;
 end
 if in(2)
	user.branchse = 1;
 end
  if in(3)
	user.estimate = 1;
  end
 if in(4)
	user.error = 1;
 end
 if in(5)
	user.save = 1;
 end
 if in(6)
	user.export = 1;
 end
 if in(7)
	user.exports = 1;
 end
%--------------------------------------------------------------------------


%--------------------------------Load Data---------------------------------
 try
   user.grid = strcat(var{1},'.mat');
   load(user.grid, '-mat', 'data')
 catch
   error('se:gridLoad', 'The power system data with measurements "%s" not found.\n', user.grid)
 end
%--------------------------------------------------------------------------