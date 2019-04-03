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
%	- user.pseudo: variance for pseudo-measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-01
% Last revision by Mirsad Cosovic on 2019-04-01
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------Check observability Input-------------------------
 if ismember('observe', user.list) && ~isempty(user.pseudo) && (~isvector(user.pseudo) || ~(any(length(user.pseudo) == 1)) || user.pseudo <= 0)
	user.pasudo = 10^12;
	warning('se:Pseudo', ['The value pair argument of the variable ' ...
	'"observe" has invalid type. The algorithm proceeds with default ' ...
	'value: %1.e.\n'], 10^12)
 elseif ismember('observe', user.list) && isempty(user.pasudo)
    user.pasudo = 10^12;
 end
%--------------------------------------------------------------------------