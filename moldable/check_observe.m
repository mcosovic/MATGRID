 function [user] = check_observe(user)

%--------------------------------------------------------------------------
% Checks input values for the observability analysis.
%
% The function checks values of variable 'observe', given as input
% arguments of the function runse.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%
%  Output:
%	- user.psvar: variance of pseudo-measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-17
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------Check observability Input-------------------------
 if ismember('observe', user.list) && ~isempty(user.psvar) && (~isvector(user.psvar) || ~(any(length(user.psvar) == 1)) || user.psvar <= 0)
	user.psvar = 10^6;
	warning('se:psvar', ['The value pair argument of the variable ' ...
	'"observe" has invalid type. The algorithm proceeds with default ' ...
	'value: %1.e.\n'], 10^6)
 elseif ismember('observe', user.list) && isempty(user.psvar)
    user.psvar = 10^6;
 end
%--------------------------------------------------------------------------