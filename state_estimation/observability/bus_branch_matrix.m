 function [Ai] = bus_branch_matrix(branch, Nbu)

%--------------------------------------------------------------------------
% Builds the branch to bus incidence matrix
%
% The corresponding matrix describes a directed graph.
%--------------------------------------------------------------------------
%  Inputs:
%	- branch: from and to bus ends
%   - Nbu: number of buses (number of columns)
%
%  Output:
%	- Ai: branch to bus incidence matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-17
% Last revision by Mirsad Cosovic on 2019-04-17
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------Branch to Bus Incidence Matrix-----------------------
 Nbr = size(branch,1);
 row = (1:Nbr)';
 
 row = [row; row];
 col = [branch(:,1); branch(:,2)];
 ind = ones(Nbr,1);

 Ai = sparse(row, col, [ind; -ind], Nbr, Nbu);
%--------------------------------------------------------------------------