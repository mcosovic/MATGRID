 function [obs] = unobservable_branches(sys, obs, Hv)

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
% Last revision by Mirsad Cosovic on 2019-04-09
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Non-zero Branch Power Flow-------------------------
 H = [obs.Hi; obs.Hf; Hv];
 G = H'*H;

 [L,D,P] = ldl(G);

 U = round((P*D*P')*10^5)/10^5;
 obs.idx = logical(diag(U) == 0);
 N = sum(obs.idx);

 if N ~= 0
	if obs.Pf == 1
	   obs.L = L;
	   obs.D = D;
	   obs.P = P;
	end

	Hp = sparse((1:N)', find(obs.idx), 1, N, sys.Nbu);
	H  = [obs.Hi; obs.Hf; Hv; Hp];
	ta = zeros(sys.Nbu,1);
	ta(obs.idx) = (1:1:N)';

	T = (H'*H) \ ta;
	obs.Pf = round((obs.Ai * T)*10^5)/(10^5) ~= 0;
 else
	obs.Pf = [];
 end
%--------------------------------------------------------------------------