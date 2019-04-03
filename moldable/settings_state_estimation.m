 function [user, data] = settings_state_estimation(var)                     %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data and measurements.
%
% The function checks 'nonlinear', 'pmu', 'dc', 'lav', 'bad', 'observe',
% 'maxIter' 'bus', 'branch', 'estimate', 'error', 'save', 'export', 'export
% slack', initialization variables 'flat', 'warm', 'exact', 'random', set
% variables 'pmuRedundancy', 'pmuDevice', 'pmuOptimal' 'legRedundancy', and
% 'legDevice', variance variable 'legUnique', 'legRandom', 'legType',
% 'pmuUnique', 'pmuRandom', and 'pmuType', given as input arguments of the
% function runse, and loads power system data according to the grid
% variable. Default inputs are: 'ieee30_41'; 'nonlinear'; 'warm'.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user input arguments
%
%  Outputs:
%	- data: load power system data
%	- user: user settings
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-18
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
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
 in = ismember(var, {'nonlinear', 'pmu', 'dc'});
 se = var(find(in, 1, 'first'));

 if isempty(se)
	se = 'nonlinear';
	warning('se:module', ['The state estimation requires "nonlinear", ' ...
	'"dc" or "pmu" input arguments for the non-linear, DC, or linear ' ...
	'state estimation only with PMUs. The algorithm proceeds with the ' ...
	'non-linear state estimation.\n'])
 end
%--------------------------------------------------------------------------


%---------------------------Check Start Inputs-----------------------------
 in = ismember(var, {'warm', 'exact', 'flat', 'random'});
 v1 = find(in, 1, 'first');
 st = var(v1);

 if isempty(st)
    st = 'warm';
 elseif strcmp(st, 'flat')
	user.flat = str2num(var(v1+1));                                         %#ok<*ST2NM>
 elseif strcmp(st, 'random')
	user.random = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%----------------------Check Phasor Measurement Set------------------------
 in = ismember(var, {'pmuRedundancy', 'pmuDevice', 'pmuOptimal'});
 v1 = find(in, 1, 'first');
 ps = var(v1);

 if strcmp(ps, 'pmuRedundancy')
	user.pmuRedundancy = str2num(var(v1+1));
 elseif strcmp(ps, 'pmuDevice')
	user.pmuDevice = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%----------------------Check Legacy Measurement Set------------------------
 in = ismember(var, {'legRedundancy', 'legDevice'});
 v1 = find(in, 1, 'first');
 ls = var(v1);

 if strcmp(ls, 'legRedundancy')
	user.legRedundancy = str2num(var(v1+1));
 elseif strcmp(ls, 'legDevice')
	user.legDevice = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------



%--------------------Check Phasor Measurement Variance---------------------
 in = ismember(var, {'pmuUnique', 'pmuRandom', 'pmuType'});
 v1 = find(in, 1, 'first');
 pv = var(v1);

 if strcmp(pv, 'pmuUnique')
	user.pmuUnique = str2num(var(v1+1));
 elseif strcmp(pv, 'pmuRandom')
	user.pmuRandom = str2num(var(v1+1));
 elseif strcmp(pv, 'pmuType')
	user.pmuType = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%--------------------Check Legacy Measurement Variance---------------------
 in = ismember(var, {'legUnique', 'legRandom', 'legType'});
 v1 = find(in, 1, 'first');
 lv = var(v1);

 if strcmp(lv, 'legUnique')
	user.legUnique = str2num(var(v1+1));
 elseif strcmp(lv, 'legRandom')
	user.legRandom = str2num(var(v1+1));
 elseif strcmp(lv, 'legType')
	user.legType = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------



%---------------------Check Terminal and Export Inputs---------------------
 in = ismember(var, {'main', 'flow', 'estimate', 'error', 'save', 'export', 'exportSlack'});
 tr = var(in);
%--------------------------------------------------------------------------


%------------------------Check Bad Data Test Input-------------------------
 in = ismember(var, 'bad');
 v1 = find(in, 1, 'first');
 bd = var(in);

 if strcmp(bd, 'bad')
	user.badSet = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%-----------------------------Check LAV Input------------------------------
 in = ismember(var, 'lav');
 lav = var(in);
%--------------------------------------------------------------------------


%------------------------Check observability Input-------------------------
 in = ismember(var, 'observe');
 v1 = find(in, 1, 'first');
 ob = var(in);

 if strcmp(ob, 'observe')
	user.pseudo = str2num(var(v1+1));
 end
%--------------------------------------------------------------------------


%-----------------------Check Number of Iterations-------------------------
 in = ismember(var, 'maxIter');
 v1 = find(in);
 it = var(v1);

 if strcmp(it, 'maxIter')
	user.maxIter = round(str2num(var(v1+1)));
 end
%--------------------------------------------------------------------------


%--------------------------------Load Data---------------------------------
 try
	gd = strcat(var{1},'.mat');
	load(gd, '-mat', 'data')
 catch
	error('se:gridLoad', 'The power system data with measurements "%s" not found.\n', gd)
 end
%--------------------------------------------------------------------------


%------------------------------User Settings-------------------------------
 user.list = [se, st, ps, ls, pv, lv, bd, lav, ob, it, tr, gd];
%--------------------------------------------------------------------------