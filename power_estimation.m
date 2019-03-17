 clc
 clearvars

%--------------------------------------------------------------------------
% Runs the AC power flow, builds measurement data, and runs the non-linear
% and DC state estimation, as well as the state estimation with PMUs.
%
% The AC power flow routine uses the Newton-Raphson algorithm, where
% reactive power and voltage magnitudes constraints can be used, and only
% one constraint can be used for one simulation run. The non-linear state
% estimation routine uses the Gauss-Newton method.
%
%  Examples:
%	leeloo('data5_6', 'nonlinear', 'warm', 'bus');
%	leeloo('data5_6', 'pmu', 'pmuOptimal', 'pmuUnique', 10^-12, 'save');
%	leeloo('data5_6', 'dc', 'bus');
%	leeloo('data5_6', 'dc', 'legDevice', [10 0 4 5], 'branch');
%	leeloo('data5_6', 'dc', 'legUnique', 10^-4, 'branch');
%--------------------------------------------------------------------------
%  Syntax:
%	leeloo(DATA, LIMITS, METHOD)
%	leeloo(DATA, LIMITS, METHOD, START)
%	leeloo(DATA, LIMITS, METHOD, START, SET)
%	leeloo(DATA, LIMITS, METHOD, START, SET, VARIANCE)
%	leeloo(DATA, LIMITS, METHOD, START, SET, VARIANCE, DISPLAY, EXPORT)
%
%  Description:
%   - leeloo(DATA, LIMITS, METHOD) computes the AC power flow problem 
%     considering LIMITS (optional) and computes state estimation problem
%     according to METHOD (sets and variances are defined by defualt 
%     settings)
%	- leeloo(DATA, LIMITS, METHOD, START) initialize the Gauss-Newton 
%     Method
%   - leeloo(DATA, LIMITS, METHOD, START, SET) defines measurment set, 
%     active and inactive measurments 
%	- leeloo(DATA, LIMITS, METHOD, START, SET, VARIANCE) defines measurment
%     variances
%	- leeloo(DATA, LIMITS, METHOD, START, SET, VARIANCE, DISPLAY, EXPORT)
%     allows to show results and export models
%
%  Input Arguments:
%   - DATA: the first input argument in the 'leeloo' function must contain  
%     a name of the mat-file that contains power system data
%	- LIMITS
%       - 'reactive': forces reactive power constraints
%       - 'voltage': forces voltage magnitude constraints
% 	- METHOD: 
%       - 'nonlinear': non-linear state estimation
%       - 'pmu': linear state estimation only with PMUs;
%       - 'dc': dc state estimation
%	- START
%       - 'warm': the initial point is defined as the one applied in AC 
%		   power flow
%       - 'exact': the initial point is defined from the exact values, if
%          those exist
%       - 'flat', [X Y]: unique initial values for voltage angles (X) in 
%		   degree and magnitude (Y) in per-unit
%		   default setting: [0 1]
%       - 'random', [X Y Z V]: random perturbation between minimum (X) and 
%          maximum values (Y) of voltage angles in degrees, and minimum (Z) 
%          and maximum (V) values of voltage magnitudes in per-units
%		   default setting: [-0.5 0.5 0.95 1.05]
%	- SET
%       - 'pmuOptimal': optimal PMU location to make the entire system
%		   completely observable only by phasor measurements
%       - 'pmuRedundancy', X: randomize phasor measurements according to
%		   redundancy X;
%		   default setting: maximum value of legacy redundancy
%       - 'pmuDevice', X: enables phasor measurements according to number 
%		   of measurement devices X placed on buses
%		   default setting: all PMUs are active
%       - 'legRedundancy', X: randomize legacy measurements according to 
%		   redundancy X
%		   default setting maximum value of phasor redundancy
%       - 'legDevice', [X Y Z V]: enables legacy measurements according to
%		   device subsets [(Pij,Qij),(Iij),(Pi,Qi),(Vi)]
%		   default setting: all legacy devices are active
%   - VARIANCE
%		- 'pmuUnique', X: applied unique variance X over all phasor 
%          measurements
%		   default setting: 10^-12;
%       - 'pmuRandom', [X Y]: randomized variances within limits X and Y 
%		   applied over all phasor measurements
%		   default setting: [10^-12 10^-10];
%		- 'pmuType', [X Y Z V]: defining variances over the subset of 
%		   measurements from PMUs (Iij, Dij, Vi, Ti)
%		   default setting: [10^-10 10^-12 10^-10 10^-12];
%		- 'legUnique', X: applied unique variance X over all legacy
%		   measurements 
%          default setting: 10^-8;
%		- 'legRandom', [X Y]: randomized variances within limits X and Y 
%		   applied over all legacy measurements
%		   default setting: [10^-9 10^-8];
%		- 'legType', [X Y Z V P Q]: defining variances over the subset of 
%		   legacy measurements (Pij, Qij, Iij, Pi, Qi, Vi)
%		   default setting: [10^-6 10^-8 10^-8 10^-6 10^-8 10^-8];
%
% Note, except for the first input, the order of other inputs is arbitrary,
% as well as their appearance.
%--------------------------------------------------------------------------
%  Outputs non-linear, PMU and DC state estimation:
%	- results.method: method name
%	- results.grid: power system name
%	- results.time.pre: preprocessing time
%	- results.time.conv: convergence time
%	- results.time.pos: postprocessing time
%	- results.error.mae1, results.error.rmse1, results.error.wrss1:
%	  metrics between estimated values and measurement values
%	- results.error.mae2, results.error.rmse2, results.error.wrss2:
%	  metrics between estimated values and exact values (if exist)
%	- results.error.mae3, results.error.rmse3: metrics between estimated
%	  state variables and exact values (if exist)
%	- results.device with columns: (1)measurement type; (2)measurement unit
%	- results.estimate with columns:
%	  (1)measurement values; (2)measurement variances; (3)estimated values;
%	  (4)unit conversion; (4)exact values (if exist)
%--------------------------------------------------------------------------
%  Outputs non-linear and PMU state estimation:
%	- results.bus with columns:
%	  (1)estimated complex bus voltages; (2)apparent injection power;
%	  (3)apparent power at shunt elements
%	- results.branch with columns:
%	  (1)line current at branch - from bus;
%	  (2)line current at branch - to bus;
%	  (3)line current after branch shunt susceptance - from bus;
%	  (4)line current after branch shunt susceptance - to bus;
%	  (5)apparent power at branch - from bus;
%	  (6)apparent power at branch - to bus;
%	  (7)apparent power after branch shunt susceptance - from bus;
%	  (8)apparent power after branch shunt susceptance - from bus;
%	  (9)reactive power injection from shunt susceptances - from bus;
%	  (10)reactive power injection from shunt susceptances - to bus;
%	  (11)apparent power of losses
%	- results.No: number of iterations
%--------------------------------------------------------------------------
%  Outputs DC state estimation:
%	- results.bus with columns:
%	  (1)estimated bus voltage angles; (2)active power injection;
%	- results.branch with column: (1)active power flow
%--------------------------------------------------------------------------


%------------------------------Main Function-------------------------------
 [results, data] = leeloo('ieee14_20', 'nonlinear', 'warm', ...
                          'pmuOptimal','estimate');
%--------------------------------------------------------------------------