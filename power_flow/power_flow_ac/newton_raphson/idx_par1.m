 function [alg, idx] = idx_par1(sys)

%--------------------------------------------------------------------------
% Forms indexes and defines parameters to compute and form Jacobian
% matrices.
%
% To form indexes and parameters, corresponding elements with the slack
% bus are removed. The function is called only in the initialization step,
% and data remains constant, even when limits are violated for reactive and
% voltage magnitude quantities.
%
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- alg.i, alg.j, alg.Gij, alg.Bij: to compute elements Ti-Tj, Vi*Vj,
%	  Gij*sin(Tij)-Bij*cos(Tij), Gij*cos(Tij)+Bij*sin(Tij)
%	- alg.fd1i, alg.ii, idx.j11.ij, idx.j11.jci, idx.j11.jcj: indexes
%	  for the Jacobian J11
%
% The local function which is used in the Newton-Raphson algorithm.
%--------------------------------------------------------------------------


%------------------Global System Indexes and Parameters--------------------
 Yte = sys.Yij;

 sys.Yij(sys.sck(1),:) = 0;
 [alg.i, alg.j] = find(sys.Yij);

 GijBij  = sys.Ybu(sub2ind([sys.Nbu sys.Nbu], alg.i, alg.j));
 alg.Gij = real(GijBij);
 alg.Bij = imag(GijBij);
%--------------------------------------------------------------------------


%----------------Indexes for Summation - Without Slack Bus-----------------
 Yte(sys.sck(1),:) = [];
 [alg.fd1i, ~]  = find(Yte);
%--------------------------------------------------------------------------


%--------------------------Jacobian J11 Indexes----------------------------
 alg.ii = sys.bus(:,1);
 alg.ii(sys.sck(1)) = [];

 idx.j11.ij = alg.j ~= sys.sck(1);

 Yte(:,sys.sck(1)) = [];
 [q, w] = find(Yte);
 bu = (1:sys.Nbu - 1)';

 idx.j11.jci = [bu; q];
 idx.j11.jcj = [bu; w];
%--------------------------------------------------------------------------