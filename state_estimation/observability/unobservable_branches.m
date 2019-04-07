 function [P] = unobservable_branches(sys, obs, Hv)

%--------------------------------------------------------------------------
% Observability analysis using LU factorization for the DC model.
%
% Using the gain matrix, we perform LU factorization, and for zero pivots,
% we add the pseudo-measurement of the voltage angles at buses that
% corresponding to zero pivots. Then, we solve the DC state estimator
% equation and evaluate branch flows.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%	- obs: observability analysis data
%	- Hv: voltage angle Jacobian
%
%  Output:
%	- P: variable that indicates branches with non-zero flows
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Non-zero Branch Power Flow-------------------------
 H = [obs.Hi; obs.Hf; Hv];
 G = H'*H;

 [~,U] = lu(sparse(G));

 U   = round(U*10^5)/10^5;
 idx = diag(U) == 0;
 N   = sum(idx);
 idx = logical(idx);

 if N ~= 0
	Hp = sparse((1:N)', find(idx), 1, N, sys.Nbu);
	H  = [obs.Hi; obs.Hf; Hv; Hp];
	G  = H'*H;
	ta = zeros(sys.Nbu,1);
	ta(idx) = (1:1:N)';

	T = G \ ta;
	P = round((obs.Ai * T)*10^5)/(10^5) ~= 0;
 else
	P = [];
 end
%--------------------------------------------------------------------------