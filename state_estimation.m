 clc
 clearvars

%--------------------------------------------------------------------------
% Runs the non-linear and DC state estimation, as well as the linear state
% estimation only with PMUs.
%
% The non-linear state estimation routine uses the Gauss-Newton method. The
% linear state estimation only with PMUs is based on the rectangular
% coordinates, where the covariance matrix is transformed from polar to
% rectangular coordinates.
%
%  Examples:
%	runse('ieee14_20', 'nonlinear', 'warm', 'maxIter', 100, 'main');
%	runse('ieee14_20', 'pmu', 'pmuOptimal', 'pmuUnique', 10^-12, 'save');
%	runse('ieee14_20', 'dc', 'main');
%	runse('ieee14_20', 'dc', 'legDevice', [10 0 4 0], 'estimate');
%	runse('ieee14_20', 'dc', 'legUnique', 10^-4, 'estimate');
%--------------------------------------------------------------------------
%  Syntax:
%	runse(DATA, METHOD)
%	runse(DATA, METHOD, START)
%	runse(DATA, METHOD, START, ATTACH)
%	runse(DATA, METHOD, START, ATTACH, SET)
%	runse(DATA, METHOD, START, ATTACH, SET, VARIANCE)
%	runse(DATA, METHOD, START, ATTACH, SET, VARIANCE, DISPLAY, EXPORT)
%
%  Description:
%	- runse(DATA, METHOD) computes state estimation problem using WLS
%	- runse(DATA, METHOD, START) the Gauss-Newton initial point
%	- runse(DATA, METHOD, START, ATTACH) the Gauss-Newton maximum number
%	  of iterations, as well bad data processing and least absolute value
%	  state estimation
%	- runse(DATA, METHOD, START, ATTACH, SET) defines measurement set
%	- runse(DATA, METHOD, START, ATTACH, SET, VARIANCE) defines measurement
%	  variances
%	- runse(DATA, METHOD, START, ATTACH, SET, VARIANCE, DISPLAY, EXPORT)
%	  allows to show results and export models
%
%  Input Arguments:
%	- DATA: the first input argument in the runse function must contain a
%	  name of the mat-file that contains power system and measurement data
% 	- METHOD:
%		- 'nonlinear': non-linear state estimation based on the WLS
%		- 'pmu': WLS linear PMU state estimation;
%		- 'dc': WLS DC state estimation;
%	- START
%		- 'warm': the Gauss-Newton initial point defined as the one applied
%		   in the AC power flow
%		- 'exact': the Gauss-Newton initial point defined from the exact
%		   values, if those exist
%		- 'flat', [X Y]: unique the Gauss-Newton initial point for voltage
%		   angles (X) in degree and magnitude (Y) in per-unit
%		   default setting: [0 1]
%		- 'random', [X Y Z V]: the Gauss-Newton initial point defined using
%		   random perturbation between minimum (X) and maximum values (Y)
%		   of voltage angles in degrees, and minimum (Z) and maximum (V)
%		   values of voltage magnitudes in per-units
%		   default setting: [-0.5 0.5 0.95 1.05]
%	- ATTACH
%		- 'bad': bad data processing
%		- 'lav': least absolute value state estimation
%       - 'observe': observability analysis (only the DC state estimation)
%		- 'maxIter', X: maximum number of the Gauss-Newton iterations(X)
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
%	- VARIANCE
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
%	- DISPLAY
%		- 'main': bus data display
%		- 'flow': power flow data display
%		- 'estimate': estimation data display
%		- 'error': evaluation data display
%	- EXPORT
%		- 'save': save display data
%		- 'export': export the system model without slack bus (for linear
%		   state estimation problems, exports in data.extras)
%		- 'exportSlack': export the system model with slack bus (for
%		   DC state estimation problem, exports in data.extras)
%
% Although the syntax is given in a certain order, for methodological
% reasons, only DATA must appear as the first input argument, and the order
% of other inputs is arbitrary, as well as their appearance.
%--------------------------------------------------------------------------
%  Outputs:
%	- data: input power system data
%--------------------------------------------------------------------------


%---------------------------Generate Path Name-----------------------------
 addpath(genpath(fileparts(which(mfilename))));
%--------------------------------------------------------------------------


%----------------------------State Estimation------------------------------
 [result, data] = runse('ieee14_20', 'dc', 'legRedundancy', 4, 'observe', 1e4, 'bad', [0.2 3], 'main');
%--------------------------------------------------------------------------