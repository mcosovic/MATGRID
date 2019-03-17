 function [user, data] = power_flow_options(var)                           %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data
%
% The function checks 'ac', 'dc', 'reactive', 'voltage', 'main', 'flow' and
% 'save' variables given as input arguments of the function leeloo in the
% 'power_flow.m', and loads power system data according to the grid
% variable. Default inputs are: 'ieee30_41'; 'ac'.
%--------------------------------------------------------------------------
%  Input:
%	- var: all user inputs
%
%  Outputs:
%	- user.pf: AC or DC power flow
%	- user.grid: name of the power system data
%	- user.limit: bus reactive power or voltage limits
%	- user.main: bus data display
%	- user.flow: branch data display
%	- user.save: save display data
%	- data: power system data
%--------------------------------------------------------------------------
% Check function which is used in power flow routine.
%--------------------------------------------------------------------------


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str, var, 'un', 0);
%--------------------------------------------------------------------------


%----------------------------Default Settings------------------------------
 user.pf    = 1;
 user.limit = 0;
 user.main  = 0;
 user.flow  = 0;
 user.save  = 0;
%--------------------------------------------------------------------------


%-------------------------------Empty Input--------------------------------
 if isempty(var)
	var{1} = 'ieee30_41';
	warning('pf:empty', ['Invalid input data structure. The algorithm '...
    'proceeds with %s power system.\n'], strcat(var{1},'.mat'))
 end
%--------------------------------------------------------------------------


%------------------------Check AC or DC Power Flow-------------------------
 in = ismember({'ac', 'dc'}, var);

 if in(1)
	user.pf = 1;
 elseif in(2)
	user.pf = 2;
 else
	warning('pf:module', ['The power flow requires "ac" or "dc" input ' ...
	'arguments for the AC or DC power flow analysis. '...
	'The algorithm proceeds with the AC power flow.\n'])
 end
%--------------------------------------------------------------------------


%---------------------------Check Limit Inputs-----------------------------
 in = ismember({'reactive', 'voltage'}, var);

 if in(1)
	user.limit = 1;
 elseif in(2)
	user.limit = 2;
 end
%--------------------------------------------------------------------------


%--------------------------Check Terminal Inputs---------------------------
 in = ismember({'main', 'flow', 'save'}, var);

 if in(1)
	user.main = 1;
 end
 if in(2)
	user.flow = 1;
 end
 if in(3)
	user.save = 1;
 end
%--------------------------------------------------------------------------


%--------------------------------Load Data---------------------------------
 try
   user.grid = strcat(var{1},'.mat');
   load(user.grid, '-mat', 'data')
 catch
   error('pf:gridLoad', 'The power system data "%s" not found.\n', user.grid)
 end
%--------------------------------------------------------------------------