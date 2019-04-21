 function [branch, irrelevant, Ai] = irrelevant_branches(se, af, ai, va)

%--------------------------------------------------------------------------
% Removes irrelevant branches for the DC state estimation.
%
% Function finds irrelevant branches, that have no incident measurements.
% Also, we include the slack bus immediately in the observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- branch: indexes of relevant branches
%	- irrelevant: indicator of irrelevant branches
%	- Ai: branch to bus incidence matrix
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-04
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------------------Slack Bus---------------------------------
 if va.on(se.sck(1)) == 0
    va.bus(se.sck(1))= se.sck(1);
 end
%--------------------------------------------------------------------------


%-----------------------Remove Irrelevant Branches-------------------------
 branch = se.branch(:,2:3);

 idxPf1 = ismember(branch, [af.from af.to], 'rows');
 idxPf2 = ismember(branch, [af.to af.from], 'rows');
 idxPf  = idxPf1 | idxPf2;
 idxPi  = any(ismember(branch, ai.bus), 2);
 idxTi  = any(ismember(branch, va.bus), 2);

 irrelevant = ~(idxPf | idxPi | idxTi);

 branch(irrelevant,:) = [];
 
 [Ai] = bus_branch_matrix(branch, se.Nbu);
%--------------------------------------------------------------------------