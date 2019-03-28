 function  [J22] = jacobian22(V, alg, idx)

%--------------------------------------------------------------------------
% Computes the Jacobian matrix J22.
%
% The function computes a partial derivative of reactive power injection
% into buses with respect to bus voltage magnitudes, where we compute
% diagonal and non-diagonal elements separately.
%--------------------------------------------------------------------------
%  Inputs:
%	- V: bus voltage magnitude vector
%	- alg: algorithm data
%	- idx: indexes data
%
%  Output:
%	- J22: Jacobian matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Jacobian Matrix J22----------------------------
 D = alg.fD3 - 2 * alg.Bii .* alg.Vpq;
 N = V(idx.i) .* alg.Te1(idx.ij);

 J22 = sparse(idx.jci, idx.jcj, [D; N], alg.Npq, alg.Npq);
%--------------------------------------------------------------------------