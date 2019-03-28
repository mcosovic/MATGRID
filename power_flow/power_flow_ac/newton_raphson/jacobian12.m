 function [J12] = jacobian12(V, alg, idx, Nbu)

%--------------------------------------------------------------------------
% Computes the Jacobian matrix J12.
%
% The function computes a partial derivative of active power injection into
% buses with respect to bus voltage magnitudes, where we compute diagonal
% and non-diagonal elements separately.
%--------------------------------------------------------------------------
%  Inputs:
%	- V: bus voltage magnitude vector
%	- alg: algorithm data
%	- idx: indexes data
%	- Nbu: number of buses
%
%  Output:
%	- J12: Jacobian matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Jacobian Matrix J12----------------------------
 D = alg.fD2  + 2 * alg.Gii .* alg.Vpq;
 N = V(idx.i) .* alg.Te2(idx.ij);

 J12 = sparse(idx.jci, idx.jcj, [D; N], Nbu - 1, alg.Npq);
%--------------------------------------------------------------------------