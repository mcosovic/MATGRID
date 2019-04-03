 function [se] = observability_dc(sys, se)

%--------------------------------------------------------------------------
% Observability analysis using LU factorization for the DC model
%
% Using the gain matrix, we observe (G'*G)*T = t. If the matrix G has full
% column rank, these properties will be valid: every columns of G has a
% pivot, the null space of G contains only zero vector T = 0, it means only
% for t = 0 will be T = 0. If there exists an estimate T, which yields a
% nonzero branch flow P = A*T, the system is unobservable, and branches
% with nonzero flows will be unobservable.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%	- se: state estimation data
%
%  Output:
%	- se.observe.notBranch: unobservable branches
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-03
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Observability Analysis---------------------------
 H = sys.H;
 G = H' * H;
 [L,U,P,Q] = lu(G);

 U = round(U*(10^10))/(10^10);
 n = find(diag(U)==0);
 C = zeros(sys.Nbu,1);

 for i = 1:length(n)
	 U(n(i),n(i)) = 1;
	 if length(n) == 1
		C(n(i)) = i;
	 end
	 if length(n) ~= 1
		C(n(i)) = i-1;
	end
 end

 G = P'*L*U*Q';
 T = G \ (P'*C);
 P = round((sys.Ai * T)*(10^8))/(10^8)';

 se.observe.notBranch = sys.branch(sys.branch(P ~= 0), 9:10);
%--------------------------------------------------------------------------