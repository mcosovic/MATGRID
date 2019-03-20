 function [user] = check_bad_data(user)              

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


%--------------------------Check Bad Data Inputs---------------------------
 if user.bad == 1 && ~isempty(user.badSet) && (~isvector(user.badSet) || ~(any(length(user.badSet) == [1 2])))
	user.badThreshold = 3;
    user.badPass = 10;
	warning('se:Threshold', ['The value pair argument of the variable ' ...
	'"bad" has invalid type. The algorithm proceeds with default ' ...
	'value: [%1.f %1.f].\n'], 3, 10)
 elseif user.bad == 1 && isempty(user.badSet)
	user.badThreshold = 3;
    user.badPass = 10^60;
 elseif user.bad == 1 && length(user.badSet) == 1
    user.badThreshold = user.badSet(1);
    user.badPass = 10^60;
 elseif user.bad == 1 && length(user.badSet) == 2
    user.badThreshold = user.badSet(1);
    user.badPass = user.badSet(2);    
 end
%--------------------------------------------------------------------------