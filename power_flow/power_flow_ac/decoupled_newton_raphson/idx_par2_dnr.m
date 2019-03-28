 function [alg, idx] = idx_par2_dnr(sys, alg, idx)

%--------------------------------------------------------------------------
% Forms indexes and defines parameters to compute and form Jacobian
% matrix J22.
%
% To form indexes and parameters, corresponding elements with the slack
% bus are removed. The function is called in the initialization step, and
% each time when limits are violated.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- alg: algorithm data
%	- idx: indexes data
%
%  Outputs:
%	- alg.pq, alg.Npq: PQ buses and number of PQ buses
%	- alg.fdi, alg.fdj, alg.fij: indexes for the Jacobian J22
%	- alg.Bii: parameters for Jacobian J22
%	- idx.j22: indexes for the Jacobians J22
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------

%--------------------------------PQ Buses----------------------------------
 alg.pq  = find(sys.bus(:,2) == 1);
 alg.Npq = length(alg.pq);
%--------------------------------------------------------------------------


%------------------Indexes for Summation - Only PQ Buses-------------------
 [alg.fdi, alg.fdj] = find(sys.Yij(alg.pq,:));
 alg.fij = ismember(alg.i, alg.pq);
%--------------------------------------------------------------------------


%-------------------------------Parameters---------------------------------
 GiiBii  = sys.Ybu(sub2ind([sys.Nbu sys.Nbu], alg.pq, alg.pq));
 alg.Bii = full(imag(GiiBii));
%--------------------------------------------------------------------------


%--------------------------Jacobian J22 Indexes----------------------------
 ij = ismember(alg.j, alg.pq);
 mn = ismember(alg.i, alg.pq);
 idx.j22.ij = logical(ij .* mn); 
 idx.j22.i  = alg.i(idx.j22.ij);

 Yii = sys.Yii(alg.pq, :);
 [c, d] = find(Yii(:, alg.pq));

 Yij = sys.Yij(alg.pq, :);
 [q, w] = find(Yij(:, alg.pq));
 
 idx.j22.jci = [c; q];
 idx.j22.jcj = [d; w];
%--------------------------------------------------------------------------