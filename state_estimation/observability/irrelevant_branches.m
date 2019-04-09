 function [obs, bra] = irrelevant_branches(pmu, leg, sys)

%--------------------------------------------------------------------------
% Removes irrelevant branches for the DC state estimation.
%
% Function finds irrelevant branches, that have no incident measurements.
% Also, we include the slack bus immediately in the observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- pmu: phasor measurement data
%	- leg: legacy measurement data
%	- sys: power system data
%
%  Outputs:
%	- obs.branch: indexes of relevant branches
%	- obs.Nbr: number of relevant branches
%	- obs.irr: indicator of irrelevant branches
%	- obs.bus: indexes of buses
%	- obs.vol: indexes of voltage angle measurements
%	- obs.flo: indexes of active power flow measurements
%	- obs.inj: indexes of active power injection measurements
%	- br: branch indexes and parameters
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-04
% Last revision by Mirsad Cosovic on 2019-04-09
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Remove Irrelevant Branches-------------------------
 [bra] = branch_data_dcse(sys);

 obs.branch = sys.branch(:,2:3);
 obs.bus = sys.bus(:,1);

 obs.vol = obs.bus;
 obs.flo = [bra.i bra.j];
 obs.inj = obs.bus;

 pmu.voltage(sys.sck(1),7) = 1;
 obs.flo(~logical(leg.flow(:,5)), :) = [];
 obs.inj(~logical(leg.injection(:,4)), :) = [];
 obs.vol(~logical(pmu.voltage(:,7)), :) = [];

 idxPf1 = ismember(obs.branch, obs.flo, 'rows');
 idxPf2 = ismember(obs.branch, [obs.flo(:,2), obs.flo(:,1)], 'rows');
 idxPf  = idxPf1 | idxPf2;
 idxPi  = any(ismember(obs.branch, obs.inj), 2);
 idxTi  = any(ismember(obs.branch, obs.vol), 2);

 obs.irr = ~(idxPf | idxPi | idxTi);

 obs.branch(obs.irr,:) = [];
 obs.Nbr = size(obs.branch,1);
%--------------------------------------------------------------------------