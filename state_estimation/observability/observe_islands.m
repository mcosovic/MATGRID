 function [se] = observe_islands(se, branch, irr, Ai)

%--------------------------------------------------------------------------
% Forms observe islands.
%
% Observable branches will forms new bus-branch model, and connected part
% of that model will define observable islands.
%--------------------------------------------------------------------------
%  Inputs:
%	- se: state estimation system data
%	- branch: indexes of branches
%	- irr: indicator of irrelevant branches
%	- Ai: branch to bus incidence matrix
%
%  Outputs:
%	- se.observe.island with columns:
%	  (1)bus index; (2)island index
%	- se.observe.branch with columns:
%	  (1)from bus; (2)to bus; (3)indicator observable or unobservable
%	  (4)indicator irrelevant or relevant
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Islands and Branch Data--------------------------
 A = Ai' * Ai;
 G = graph(A);
 b = conncomp(G);

 observe = ismember(se.branch(:,2:3), branch, 'row');

 se.observe.island = [se.bus(:,15) b'];
 se.observe.branch = [se.branch(:,9:10) observe ~= 0 ~irr];
%--------------------------------------------------------------------------