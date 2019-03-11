 function [J11] = jacobian11(V, alg, idx, Nbu)

%--------------------------------------------------------------------------
% Computes the Jacobian matrix J11.
%
% The function computes a partial derivative of active power injection into
% buses with respect to bus voltage angles, where we compute diagonal and
% non-diagonal elements separately.
%
%  Input:
%	- V: bus voltage magnitude vector
%	- alg: algorithm data
%	- idx: indexes data
%	- Nbu: number of buses
%
%  Outputs:
%	- J11: Jacobian matrix
%
% The local function which is used in the Newton-Raphson algorithm.
%--------------------------------------------------------------------------


%---------------------------Jacobian Matrix J11----------------------------
 D = V(alg.ii) .* alg.fD1;
 N = alg.Vij(idx.ij) .* alg.Te1(idx.ij);

 J11 = sparse(idx.jci, idx.jcj, [D; N], Nbu - 1, Nbu - 1);
%--------------------------------------------------------------------------