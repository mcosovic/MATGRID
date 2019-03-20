 function [user, data] = settings_state_estimation(var)                     %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data and measurements.
%
% The function checks 'nonlinear', 'pmu', 'dc' 'bus', 'branch', 'estimate',
% 'error', 'save', 'export', 'export slack', initialization variables
% 'flat', 'warm', 'exact', 'random', set variables 'pmuRedundancy',
% 'pmuDevice', 'pmuOptimal' 'legRedundancy', and 'legDevice', variance
% variable 'legUnique', 'legRandom', 'legType', 'pmuUnique', 'pmuRandom',
% and 'pmuType', given as input arguments of the function leeloo in the
% 'state_estimation.m', and loads power system data and measurements
% according to the grid variable. Default inputs are: 'ieee30_41';
% 'nonlinear'; 'warm'.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user inputs
%
%  Outputs:
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
%   - user.setpmu: phasor measurement set indicator
%   - user.setleg: legacy measurement set indicator
%	- user.pmuRedundancy: set according to redundancy for legacy
%	  measurements
%	- user.legDevice: set according to devices for legacy measurements
%	- user.pmuRedundancy: set according to redundancy for phasor
%	  measurements
%	- user.pmuDevice: set according to devices for phasor measurements
%	- user.pmuOptimal: optimal PMU location to make the entire system
%     completely observable
%   - user.varpmu: phasor measurement variances indicator
%   - user.varleg: legacy measurement variances indicator
%	- user.legUnique: unique variance for legacy measurements
%	- user.pmuUnique: unique variance for phasor measurements
%	- user.legRandom: random variances for legacy measurements
%	- user.pmuRandom: random variances for phasor measurements
%	- user.legType: variances per type for legacy measurements
%	- user.pmuType: variances per type for phasor measurements
%	- data: power system data with measurements
%--------------------------------------------------------------------------
% Check function which is used in state estimation modules.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str,var, 'un', 0);
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
    user.se = 1;
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

 user.start = 1;

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
%--------------------------------------------------------------------------


%----------------------Check Phasor Measurement Set------------------------
 in = ismember(var, {'pmuRedundancy', 'pmuDevice', 'pmuOptimal'});
 v1 = find(in, 1, 'first');
 pmu = var(v1);

 user.setpmu = 0;

 if strcmp(pmu, 'pmuRedundancy')
	user.setpmu = 1;
	user.pmuRedundancy = str2num(var(v1+1));
 elseif strcmp(pmu, 'pmuDevice')
	user.setpmu = 2;
	user.pmuDevice = str2num(var(v1+1));
 elseif strcmp(pmu, 'pmuOptimal')
	user.setpmu = 3;
 end
%--------------------------------------------------------------------------


%----------------------Check Legacy Measurement Set------------------------
 in = ismember(var, {'legRedundancy', 'legDevice'});
 v1 = find(in, 1, 'first');
 leg = var(v1);

 user.setleg = 0;

 if strcmp(leg, 'legRedundancy')
	user.setleg = 1;
	user.legRedundancy = str2num(var(v1+1));
 elseif strcmp(leg, 'legDevice')
	user.setleg = 2;
	user.legDevice = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------



%--------------------Check Phasor Measurement Variance---------------------
 in = ismember(var, {'pmuUnique', 'pmuRandom', 'pmuType'});
 v1 = find(in, 1, 'first');
 pmu = var(v1);

 user.varpmu = 0;

 if strcmp(pmu, 'pmuUnique')
	user.varpmu = 1;
	user.pmuUnique = str2num(var(v1+1));
 elseif strcmp(pmu, 'pmuRandom')
	user.varpmu = 2;
	user.pmuRandom = str2num(var(v1+1));
 elseif strcmp(pmu, 'pmuType')
	user.varpmu = 3;
	user.pmuType = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%--------------------Check Legacy Measurement Variance---------------------
 in = ismember(var, {'legUnique', 'legRandom', 'legType'});
 v1 = find(in, 1, 'first');
 pmu = var(v1);

 user.varleg = 0;

 if strcmp(pmu, 'legUnique')
	user.varleg = 1;
	user.legUnique = str2num(var(v1+1));
 elseif strcmp(pmu, 'legRandom')
	user.varleg = 2;
	user.legRandom = str2num(var(v1+1));
 elseif strcmp(pmu, 'legType')
	user.varleg = 3;
	user.legType = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------



%---------------------Check Terminal and Export Inputs---------------------
 in = ismember({'main', 'flow', 'estimate', 'error', 'save', 'export', 'exportSlack'}, var);

 user.main     = 0;
 user.flow     = 0;
 user.estimate = 0;
 user.error    = 0;
 user.save     = 0;
 user.export   = 0;
 user.exports  = 0;

 if in(1)
	user.main = 1;
 end
 if in(2)
	user.flow = 1;
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
 if in(6) && (user.se == 2 || user.se == 3)
	user.export = 1;
 end
 if in(7) && (user.se == 2 || user.se == 3)
	user.exports = 1;
 end
%--------------------------------------------------------------------------


%------------------------Check Bad Data Test Input-------------------------
 in = ismember(var, {'bad'});
 v1 = find(in, 1, 'first');
 bad = var(in);

 user.bad = 0;

 if strcmp(bad, 'bad')
	user.bad = 1;
	user.badSet = str2num(var(v1+1));
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