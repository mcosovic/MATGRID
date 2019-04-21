 function [user, se, branch, Ai] = unobservable_branches(data, user, se, af, ai, va, branch, Ai)

%--------------------------------------------------------------------------
% Observability analysis using LDL factorization for the DC model.
%
% Using the gain matrix, we perform LDL factorization, and for zero pivots,
% we add the pseudo-measurement of the voltage angles at buses that
% corresponding to zero pivots. Then, we solve the DC state estimator
% equation and evaluate branch flows.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data
%	- user: user inputs
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%	- branch: from and to bus ends
%	- Ai: branch to bus incidence matrix
%
%  Output:
%   - user.list: flag if the system is unobservable
%	- se.L, se.D, se.P: matrices from LDL factorization
%	- branch: observable branches
%	- Ai: branch to bus incidence matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------------------Slack Bus---------------------------------
 if va.on(se.sck(1)) == 0
	va.H = [va.H; sparse(1, se.sck(1), 1, 1, se.Nbu)];
 end
%--------------------------------------------------------------------------


%-------------------------Observability Analysis---------------------------
 Pf = 9999;
 user.list = [user.list 'unobservable'];

 while sum(Pf)
	   H = [af.H; ai.H; va.H];
	   G = H' * H;
	   [L,D,P] = ldl(G);

	   idx = logical(diag(P*D*P') <= 1e-5);
	   N   = sum(idx);

	   if N == 0
		  user.list(end) = [];
		  break
	   end

	   if Pf == 9999
		  se.L = L; se.D = D; se.P = P;
	   end

	   H  = [H; sparse((1:N)', find(idx), 1, N, se.Nbu)];					%#ok<AGROW>
	   ta = zeros(se.Nbu,1);
	   ta(idx) = (1:1:N)';
	   T  = (H' * H) \ ta;
	   Pf = abs(Ai  * T) >= 1e-5;

	   nonOb = branch(Pf, :);
	   idxPf = ismember([se.from se.to], [nonOb; nonOb(:,2) nonOb(:,1)], 'rows');
	   idxPi = any(ismember(se.bus(:,1), nonOb), 2);

	   data.legacy.flow(idxPf,5) = 0;
	   data.legacy.injection(idxPi,4) = 0;
	   [af] = flow_dcse(data.legacy.flow, se);
	   [ai] = injection_dcse(data.legacy.injection, se);

	   branch(Pf, :) = [];
	   [Ai] = bus_branch_matrix(branch, se.Nbu);
 end
%--------------------------------------------------------------------------