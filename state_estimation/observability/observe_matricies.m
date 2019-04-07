 function [obs] = observe_matricies(obs, sys)

%--------------------------------------------------------------------------
% Forms the bus-branch incidence matrix and active power flow and injection
% Jacobians.
%
% The system observability is independent of the power system parameters.
% Consequently, all branches can be assumed to have an impedance of
% 1(p.u.). Finally, matrices are formed only for relevant branches.
%--------------------------------------------------------------------------
%  Inputs:
%	- obs: observability analysis data
%	- sys: power system data
%
%  Outputs:
%	- obs.Ai: bus-branch incidence matrix
%	- obs.Hi: active power injection Jacobian matrix
%	- obs.Hf: active power flow Jacobian matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Forms Matrices-------------------------------
 row = [(1:obs.Nbr)'; (1:obs.Nbr)'];
 col = [obs.branch(:,1); obs.branch(:,2)];
 ind = ones(obs.Nbr,1);

 obs.Ai = sparse(row, col, [ind; -ind], obs.Nbr, sys.Nbu);
 obs.Hi = sys.Ai(:,obs.inj)' * sys.Ai;

 N = size(obs.flo,1);
 n = (1:N)';
 i = [n; n];
 j = [obs.flo(:,1); obs.flo(:,2)];
 c = ones(N,1);
 obs.Hf = sparse(i, j, [c; -c], N, sys.Nbu);
%--------------------------------------------------------------------------