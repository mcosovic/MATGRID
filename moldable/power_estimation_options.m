 function [var, user, data] = power_estimation_options(var)                 %#ok<*STOUT>

%--------------------------------------------------------------------------
% Checks user inputs and if those are missing, adds default values and
% loads power system data
%
% The function checks variable given as input arguments of the function
% leeloo in the 'power_estimation.m' related with state estimation, and
% input variables related with power flow analysis. If variables are
% missing or are not properly defined, we add default values, which allows
% to execute a code without errors.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user inputs
%
%  Outputs:
%	- user.method: power-estimation indicator
%	- user.pf: AC power flow
%	- user.limit: bus reactive power or voltage limits
%	- user.main: bus data display
%	- user.flow: branch data display
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
%	- data: power system data with measurements
%--------------------------------------------------------------------------
% Check function which is used in power flow proceeds to state estimation
% routine.
%--------------------------------------------------------------------------


%----------------------Check State Estimation Inputs-----------------------
 [var, user, data] = state_estimation_options(var);
%--------------------------------------------------------------------------


%-------------------------Default Power Settings---------------------------
 user.method = 2;
 user.pf     = 1;
 user.limit  = 0;
 user.main   = 0;
 user.flow   = 0;
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
 in = ismember({'main', 'flow'}, var);

 if in(1)
	user.main = 1;
 end
 if in(2)
	user.flow = 1;
 end
%--------------------------------------------------------------------------