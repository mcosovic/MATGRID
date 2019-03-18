 function [user, data] = settings_generator(var)                           %#ok<*STOUT>

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
%	- var: native user settings
%
%  Outputs:
%	- user.pf: AC or DC power flow
%	- user.grid: name of the power system data
%	- user.limit: bus reactive power or voltage limits
%	- user.main: bus data display
%	- user.flow: branch data display
%	- user.save: save display data
%	- data: load power system data
%--------------------------------------------------------------------------
% Check function which is used in power flow modules.
%--------------------------------------------------------------------------


 var = [var, 'dc'];
 [user, data] = settings_state_estimation(var); 


%---------------------------------Inputs-----------------------------------
 var = cellfun(@num2str, var, 'un', 0);
%--------------------------------------------------------------------------


%---------------------------Force AC Power Flow----------------------------
 user.pf = 1;
%--------------------------------------------------------------------------


%-------------------------Force Unique Variances---------------------------
 if user.varleg == 0
    user.varleg = 1;
    user.legUnique = [];
 end
 if user.varpmu == 0
    user.varpmu = 1;
    user.pmuUnique = [];
 end
%--------------------------------------------------------------------------



%---------------------------Check Limit Inputs-----------------------------
 in = ismember({'reactive', 'voltage'}, var);

 user.limit = 0;

 if in(1)
	user.limit = 1;
 elseif in(2)
	user.limit = 2;
 end
%--------------------------------------------------------------------------
