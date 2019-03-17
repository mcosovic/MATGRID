 function [J21] = jacobian21(alg, idx, Nbu)

%--------------------------------------------------------------------------
% Computes the Jacobian matrix J21.
%
% The function computes a partial derivative of reactive power injection
% into buses with respect to bus voltage angles, where we compute diagonal
% and non-diagonal elements separately.
%--------------------------------------------------------------------------
%  Inputs:
%	- alg: algorithm data
%	- idx: indexes data
%	- Nbu: number of buses
%
%  Output:
%	- J21: Jacobian matrix
%--------------------------------------------------------------------------
% The local function which is used in the Newton-Raphson algorithm.
%--------------------------------------------------------------------------


%---------------------------Jacobian Matrix J21----------------------------
 D = alg.Vpq .* alg.fD2;
 N = -alg.Vij(idx.ij) .* alg.Te2(idx.ij);

 J21 = sparse(idx.jci, idx.jcj, [D; N], alg.Npq, Nbu - 1);
%--------------------------------------------------------------------------