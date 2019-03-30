 function [user] = check_maxiter(user)

%--------------------------------------------------------------------------
% Checks input values for maximum number of iterations.
%
% The function checks values of variable 'maxIter', given as input
% arguments of the function runpf.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%
%  Output:
%	- user.maxIter: maximum number of iterations
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Check Number of Iterations-------------------------
 if (ismember('maxIter', user.list) && (~isvector(user.maxIter) || ~(length(user.maxIter) == 1) || user.maxIter <= 0)) || ~ismember('maxIter', user.list) 
	if ismember('nr', user.list)
	   user.maxIter = 500;
	end
	if ismember('gs', user.list)
	   user.maxIter = 500;
	end
	if ismember('dnr', user.list)
	   user.maxIter = 500;
    end
	if ismember('fdnr', user.list)
	   user.maxIter = 500;
	end
	if ismember('nonlinear', user.list)
	   user.maxIter = 500;
	end    
 end
%--------------------------------------------------------------------------
