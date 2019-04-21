 function [data, user, se, af, ai] = observe_dc(data, user, se, af, ai, va)

%--------------------------------------------------------------------------
% Observability analysis using LDL factorization for the DC model.
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
%	- user: user inputs
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- data: measurement data with pseudo-measurements
%	- user.list: flag if the system is unobservable
%	- se.observe: observability analysis data
%	- ai: active power injection measurements with pseudo-measurements
%	- af: active power flow measurements with pseudo-measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------Processing Inputs and Settings-----------------------
 [user] = check_observe(user);
%--------------------------------------------------------------------------


%---------------------------Irrelevant Branches----------------------------
 [br, ir, Ai] = irrelevant_branches(se, af, ai, va);
%--------------------------------------------------------------------------


%-------------------------Observability Analysis---------------------------
 [user, se, br, Ai] = unobservable_branches(data, user, se, af, ai, va, br, Ai);
%--------------------------------------------------------------------------


%---------------------Islands and Pseudo-measurements----------------------
 if ismember('unobservable', user.list)
	[se] = observe_islands(se, br, ir, Ai);
	[data, se, af, ai] = restore_observability(data, user, se);
 end
%--------------------------------------------------------------------------