 function [obs] = remove_branches(obs)

%--------------------------------------------------------------------------
% Removes unobservable branches and  measurements that are incident to
% these branches.
%
% Active power flow and injection measurements are removed if corresponding
% branch is unobservable. Note that we do not remove voltage angle
% measurements because those are connected at buses.
%--------------------------------------------------------------------------
%  Inputs:
%	- obs: power system data
%	- P: variable that indicates branches with non-zero flows
%
%  Outputs:
%	- obs.branch: indexes of relevant branches
%	- obs.Nbr: number of relevant branches
%	- obs.flo: indexes of active power flow measurements
%	- obs.inj: indexes of active power injection measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-29
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------Remove Branches and Measurements----------------------
 nonObs = obs.branch(obs.Pf, :);

 obs.branch(obs.Pf, :) = [];
 obs.Nbr = size(obs.branch,1);

 idxPi = unique([nonObs(:,1); nonObs(:,2)]);
 idxPi = ismember(obs.inj, idxPi);
 obs.inj(idxPi) = [];

 idxPij1 = ismember(obs.flo, nonObs, 'rows');
 idxPij2 = ismember(obs.flo, [nonObs(:,2) nonObs(:,1)], 'rows');
 idxPij  = idxPij1 | idxPij2;
 obs.flo(idxPij,:) = [];
%--------------------------------------------------------------------------