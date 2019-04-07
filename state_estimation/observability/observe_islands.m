 function [se] = observe_islands(sys, obs)

%--------------------------------------------------------------------------
% Forms observe islands.
%
% Observable branches will forms new bus-branch model, and connected part
% of that model will define observable islands.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- obs: observability analysis data
%
%  Outputs:
%	- se.observe.island with columns:
%	  (1)bus index; (2)island index
%	- se.observe.branch with columns:
%	  (1)from bus; (2)to bus; (3)indicator observable or unobservable
%	  (4)indicator irrelevant or relevant
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Islands and Branch Data--------------------------
 A = obs.Ai' * obs.Ai;
 G = graph(A);
 b = conncomp(G);
 se.observe.island = [sys.bus(:,15) b'];

 idx = ismember(sys.branch(:,2:3), obs.branch, 'rows');
 se.observe.branch = [sys.branch(:,9:10) idx ~obs.irr];
%--------------------------------------------------------------------------