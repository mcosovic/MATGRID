 function [se] = observability_dc(data, sys)

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
%  Inputs:
%	- data: input power system data
%	- sys: power system data
%
%  Output:
%	- se.observe: observability analysis data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------Irrelevant Branches and Measurement Data------------------
 [obs] = irrelevant_branches(data.pmu, data.legacy, sys);
%--------------------------------------------------------------------------


%-------------------------Voltage Angle Jacobian---------------------------
 N  = size(obs.vol,1);
 Hv = sparse((1:N)', obs.vol, 1, N, sys.Nbu);
%--------------------------------------------------------------------------


%-------------------------Observability Analysis---------------------------
 P = 1;
 while max(P) ~= 0
	   [obs] = observe_matricies(obs, sys);
	   [P] = unobservable_branches(sys, obs, Hv);
	   [obs] = remove_branches(obs, P);
 end
%--------------------------------------------------------------------------


%---------------------------Observable Islands-----------------------------
 [se] = observe_islands(sys, obs);
%--------------------------------------------------------------------------