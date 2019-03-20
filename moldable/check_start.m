 function [user] = check_start(user)              

%--------------------------------------------------------------------------
% Checks input values for Gasuss-Newton method start.

%
% The function checks initialization values of variables 'flat', 'random',
% given as input arguments of the function leeloo in the
% 'state_estimation.m'.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%
%  Outputs:
%	- user.flat: initial point, flat start
%	- user.random: initial point, random perturbation
%--------------------------------------------------------------------------
% Check function which is used in state estimation modules.
%--------------------------------------------------------------------------


%---------------------------Check Start Inputs-----------------------------
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