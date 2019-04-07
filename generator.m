 clc
 clearvars

%--------------------------------------------------------------------------
% Generates measurement data from the AC power flow analysis using
% Newton-Raphson algorithm.
%
% The module generates legacy and phasor measurement data, according to user
% settings. The function corrupts the exact solutions from power flow
% analysis by the additive white Gaussian noises according to defined
% variances. Further, the function forms measurement set according to
% predefined inputs.
%
%  Examples:
%	rungen('ieee14_20', 'pmuOptimal', 'pmuUnique', 10^-12);
%	rungen('ieee14_20', 'legDevice', [10 0 4 0]);
%	rungen('ieee14_20', 'legRedundancy', 3, 'legUnique', 10^-4);
%--------------------------------------------------------------------------
%  Syntax:
%	rungen(DATA, LIMITS, ATTACH, SET)
%	rungen(DATA, LIMITS, ATTACH, SET, VARIANCE)
%
%  Description:
%	- rungen(DATA, LIMIT, ATTACH, SET) defines measurement set,  active and
%	  inactive measurements
%	- rungen(DATA, LIMIT, ATTACH, SET, VARIANCE) defines measurement
%	  variances
%
%  Input Arguments:
%	- DATA: the first input argument in the rungen function must contain
%	  a name of the mat-file that contains power system data
%	- LIMIT
%		- 'reactive': forces reactive power constraints
%		- 'voltage': forces voltage magnitude constraints
%	- ATTACH
%		- 'maxIter', X: AC power flow maximum number of iterations(X)
%	- SET
%		- 'pmuOptimal': optimal PMU location to make the entire system
%		   completely observable only by phasor measurements
%		- 'pmuRedundancy', X: randomize phasor measurements according to
%		   redundancy X;
%		   default setting: maximum value of legacy redundancy
%		- 'pmuDevice', X: enables phasor measurements according to number
%		   of measurement devices X placed on buses
%		   default setting: all PMUs are active
%		- 'legRedundancy', X: randomize legacy measurements according to
%		   redundancy X
%		   default setting maximum value of phasor redundancy
%		- 'legDevice', [X Y Z V]: enables legacy measurements according to
%		   device subsets [(Pij,Qij),(Iij),(Pi,Qi),(Vi)]
%		   default setting: all legacy devices are active
%   - VARIANCE
%		- 'pmuUnique', X: applied unique variance X over all phasor
%		   measurements
%		   default setting: 10^-12;
%		- 'pmuRandom', [X Y]: randomized variances within limits X and Y
%		   applied over all phasor measurements
%		   default setting: [10^-12 10^-10];
%		- 'pmuType', [X Y Z V]: defining variances over the subset of
%		   measurements from PMUs (Iij, Dij, Vi, Ti)
%		   default setting: [10^-10 10^-12 10^-10 10^-12];
%		- 'legUnique', X: applied unique variance X over all legacy
%		   measurements
%		   default setting: 10^-8;
%		- 'legRandom', [X Y]: randomized variances within limits X and Y
%		   applied over all legacy measurements
%		   default setting: [10^-9 10^-8];
%		- 'legType', [X Y Z V P Q]: defining variances over the subset of
%		   legacy measurements (Pij, Qij, Iij, Pi, Qi, Vi)
%		   default setting: [10^-6 10^-8 10^-8 10^-6 10^-8 10^-8];
%
% Although the syntax is given in a certain order, for methodological
% reasons, only DATA must appear as the first input argument, and the order
% of other inputs is arbitrary, as well as their appearance.
%--------------------------------------------------------------------------
%  Outputs:
%	- data: with additional struct variables:
%	  - data.legacy.flow with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)active power flow measurements;
%		(4)active power flow measurement variances;
%		(5)active power flow measurements turn on/off;
%		(6)reactive power flow measurements;
%		(7)reactive power flow measurement variances;
%		(8)reactive power flow measurement turn on/off;
%		(9)active power flow exact value;
%		(10)reactive power flow exact value;
%	  - data.legacy.current with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurement turn on/off;
%		(6)line current magnitude exact value;
%	  - data.legacy.injection with columns:
%		(1)bus indexes; (2)active power injection measurements;
%		(3)active power injection measurement variances;
%		(4)active power injection measurements turn on/off;
%		(5)reactive power injection measurements;
%		(6)reactive power injection measurement variances;
%		(7)reactive power injection measurements turn on/off;
%		(9)active power injection exact value;
%		(10)reactive power injection exact value;
%	  - data.legacy.voltage with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage magnitude exact value;
%	  - data.pmu.current with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurements turn on/off;
%		(6)line current angle measurements;
%		(7)line current angle measurement variances;
%		(8)line current angle measurements turn on/off;
%		(9)line current magnitude exact value;
%		(10)line current angle exact value;
%	  - data.pmu.voltage with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage angle measurements;
%		(6)bus voltage angle measurement variances;
%		(7)bus voltage angle measurements turn on/off;
%		(8)bus voltage magnitude exact value;
%		(9)bus voltage angle exact value;
%--------------------------------------------------------------------------


%---------------------------Generate Path Name-----------------------------
 addpath(genpath(fileparts(which(mfilename))));
%--------------------------------------------------------------------------


%------------------------------Main Function-------------------------------
 [data] = rungen('matlab', 'legDevice', [10 0 4 0], 'legUnique', 10^-2);
%--------------------------------------------------------------------------