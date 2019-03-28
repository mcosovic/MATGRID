 function [data, user] = settings_power_flow(var)                           %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data
%
% The function checks 'ac', 'dc', 'gs', 'dnr', 'fdnr', 'reactive',
% 'voltage', 'maxIter', 'main', 'flow' and 'save' variables given as input
% arguments of the function runpf, and loads power system data according to
% the grid variable. Default inputs are: 'ieee30_41'; 'ac'.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user input arguments
%
%  Outputs:
%	- data: load power system data
%	- user: user settings
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-18
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str, var, 'un', 0);
%--------------------------------------------------------------------------


%-------------------------------Empty Input--------------------------------
 if isempty(var)
	var{1} = 'ieee30_41';
	warning('pf:empty', ['Invalid input data structure. The algorithm '...
	'proceeds with %s power system.\n'], strcat(var{1},'.mat'))
 end
 var = string([var, ' ']);
%--------------------------------------------------------------------------


%-----------------Check AC or DC and Power Flow Algorithm------------------
 in = ismember(var, {'nr', 'gs', 'dnr', 'fdnr', 'dc'});
 pf = var(find(in, 1, 'first'));

 if isempty(pf)
	pf = 'nr';
	warning('pf:module', ['The power flow requires at least "nr" or ' ...
	'"dc" input arguments for the AC or DC power flow analysis. '...
	'The algorithm proceeds with the AC power flow.\n'])
 end
%--------------------------------------------------------------------------


%---------------------------Check Limit Inputs-----------------------------
 in = ismember(var, {'reactive', 'voltage'});
 cs = var(find(in, 1, 'first'));
%--------------------------------------------------------------------------


%---------------------Check Terminal and Save Inputs-----------------------
 in = ismember(var, {'main', 'flow', 'save'});
 tr = var(in);
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
	error('pf:gridLoad', 'The power system data "%s" not found.\n', gd)
 end
%--------------------------------------------------------------------------


%------------------------------User Settings-------------------------------
 user.list = [pf, cs, tr, it, gd];
%--------------------------------------------------------------------------