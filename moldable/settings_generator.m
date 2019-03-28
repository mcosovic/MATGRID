 function [user, data] = settings_generator(var)                           %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data and measurements.
%
% The function checks 'reactive', 'voltage', 'maxIter', set variables
% 'pmuRedundancy', 'pmuDevice', 'pmuOptimal' 'legRedundancy', and
% 'legDevice', variance variable 'legUnique', 'legRandom', 'legType',
% 'pmuUnique', 'pmuRandom', and 'pmuType', given as input arguments of the
% function rungen, and loads power system data according to the grid
% variable. Default inputs are: 'ieee30_41'; 'nonlinear'; 'warm'.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user input arguments
%
%  Outputs:
%	- data: load power system data
%	- user: user settings
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-18
% Last revision by Mirsad Cosovic on 2019-03-28
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str, var, 'un', 0);
%--------------------------------------------------------------------------


%-------------------------------Empty Input--------------------------------
 if isempty(var)
	var{1} = 'ieee30_41';
	warning('se:empty', ['Invalid input data structure. The algorithm '...
	'proceeds with %s power system. %s.\n'], strcat(var{1},'.mat'))
 end
 var = string([var, ' ']);
%--------------------------------------------------------------------------


%---------------------------Force AC Power Flow----------------------------
 pf = 'nr';
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
 else
	pv = 'pmuUnique';
	user.pmuUnique = [];
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
 else
	lv = 'legUnique';
	user.legUnique = [];
 end
%--------------------------------------------------------------------------


%---------------------------Check Limit Inputs-----------------------------
 in = ismember(var, {'reactive', 'voltage'});
 cs = var(find(in, 1, 'first'));
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
 user.list = [pf, ps, ls, pv, lv, cs, it, gd];
%--------------------------------------------------------------------------