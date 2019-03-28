 function [J11] = jacobian11(V, alg, idx, Nbu)

%--------------------------------------------------------------------------
% Computes the Jacobian matrix J11.
%
% The function computes a partial derivative of active power injection into
% buses with respect to bus voltage angles, where we compute diagonal and
% non-diagonal elements separately.
%--------------------------------------------------------------------------
%  Inputs:
%	- V: bus voltage magnitude vector
%	- alg: algorithm data
%	- idx: indexes data
%	- Nbu: number of buses
%
%  Output:
%	- J11: Jacobian matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Jacobian Matrix J11----------------------------
 D = V(alg.ii) .* alg.fD1;
 N = alg.Vij(idx.ij) .* alg.Te1(idx.ij);

 J11 = sparse(idx.jci, idx.jcj, [D; N], Nbu - 1, Nbu - 1);
%--------------------------------------------------------------------------