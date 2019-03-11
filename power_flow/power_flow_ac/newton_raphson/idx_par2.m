 function [alg, idx] = idx_par2(sys, alg, idx)

%--------------------------------------------------------------------------
% Forms indexes and defines parameters to compute and form Jacobian
% matrices.
%
% To form indexes and parameters, corresponding elements with the slack
% bus are removed. The function is called in the initialization step, and
% each time when limits are violated.
%
%  Input:
%	- sys: power system data
%
%  Outputs:
%    - alg.pq, alg.Npq: PQ buses and number of PQ buses
%    - alg.fdi, alg.fdj, alg.fij: indexes for the Jacobians J12, J21, J22
%    - alg.Gii, alg.Bii: parameters for Jacobians J12 and J22
%    - idx.j12: indexes for the Jacobians J12
%    - idx.j21: indexes for the Jacobians J21
%    - idx.j22: indexes for the Jacobians J22
%
% The local function which is used in the Newton-Raphson algorithm.
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
 alg.Gii = real(GiiBii);
 alg.Bii = imag(GiiBii);
%--------------------------------------------------------------------------


%--------------------------Jacobian J12 Indexes----------------------------
 idx.j12.ij = ismember(alg.j, alg.pq);
 idx.j12.i  = alg.i(idx.j12.ij);

 Yii = sys.Yii(:,alg.pq);
 Yii(sys.sck(1),:) = [];
 [c, d] = find(Yii);

 Yij = sys.Yij(:,alg.pq);
 Yij(sys.sck(1),:) = [];
 [q, w] = find(Yij);

 idx.j12.jci = [c; q];
 idx.j12.jcj = [d; w];
%--------------------------------------------------------------------------


%--------------------------Jacobian J21 Indexes----------------------------
 mn = ismember(alg.i, alg.pq);
 idx.j21.ij = logical(idx.j11.ij .* mn);

 Yii = sys.Yii(alg.pq,:);
 Yii(:, sys.sck(1)) = [];
 [c, d] = find(Yii);

 Yij = sys.Yij(alg.pq,:);
 Yij(:, sys.sck(1)) = [];
 [q, w] = find(Yij);

 if alg.Npq == 1
    idx.j21.jci = [c; q'];
    idx.j21.jcj = [d; w'];
 else
    idx.j21.jci = [c; q];
    idx.j21.jcj = [d; w];
 end
%--------------------------------------------------------------------------


%--------------------------Jacobian J22 Indexes----------------------------
 idx.j22.ij = logical(idx.j12.ij .* mn);
 idx.j22.i  = alg.i(idx.j22.ij);

 Yii = sys.Yii(alg.pq,:);
 [c, d] = find(Yii(:,alg.pq));

 Yij = sys.Yij(alg.pq,:);
 [q, w] = find(Yij(:,alg.pq));

 idx.j22.jci = [c; q];
 idx.j22.jcj = [d; w];
%--------------------------------------------------------------------------