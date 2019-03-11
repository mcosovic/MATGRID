 clc
 clearvars

%--------------------------------------------------------------------------
% Runs the non-linear and DC state estimation, as well as the state
% estimation with PMUs.
%
% The non-linear state estimation routine uses the Gauss-Newton method.
%
%  User options:
%	- name of the mat-file that contains power system and measurements data
%	  example: estimate.grid = 'ieee300_411';
%	- non-linear, PMU or DC state estimation
%	  estimate.module = 1 - non-linear state estimation;
%	  estimate.module = 2 - state estimation only with PMUs;
%	  estimate.module = 3 - DC state estimation;
%	- initialize the Gauss-Newton method
%	  example estimate.flat = [0 1] - initial values for voltage angles in
%	  degrees and magnitudes;
%	  example estimate.random = [-0.5 0.5 0.95 1.05] - random perturbation
%	  between minimum and maximum values of voltage angles in degrees, and
%	  minimum and maximum values of voltage magnitudes;
%	  estimate.warm = 1 - the initial point is defined as the one applied
%	  in AC power flow; estimate.warm = 2 - the initial point is defined
%	  from the exact values, if those exist;
%	- bus data display
%	  estimate.bus = 1 - turn on;
%	- branch data display
%	  estimate.branch = 1 - turn on; 
%	- estimation data display
%	  estimate.estimation = 1 - turn on; 
%	- evaluation (error) data display
%	  estimate.evaluation = 1 - turn on; 
%	- save display data
%	  estimate.save = 1 - turn on; 
%	- export the system model for the linear state estimation problems
%	  estimate.linear = 1 - without slack bus; 
%     estimate.linear = 2 - with slack bus;
%
%  Outputs non-linear and DC state estimation:
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
%
%  Outputs non-linear state estimation:
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
%
%  Outputs DC state estimation:
%	- results.bus with columns:
%	  (1)estimated bus voltage angles; (2)active power injection;
%	- results.branch with column: (1)active power flow
%--------------------------------------------------------------------------


%-------------------------------Load Data----------------------------------
 estimate.grid = 'ieee30_41';
%--------------------------------------------------------------------------


%------------------------State Estimation Options--------------------------
 estimate.module = 1;
%-------------------------
 estimate.warm = 1;
%-------------------------
 estimate.bus = 1;
 estimate.branch = 0;
 estimate.estimation = 1;
 estimate.evaluation = 0;
%--------------------------------------------------------------------------


%---------------------------------Extras-----------------------------------
 estimate.save   = 0;
 estimate.linear = 0;
%--------------------------------------------------------------------------


%------------------------------Main Function-------------------------------
 [data, results, sys] = leeloo;
%--------------------------------------------------------------------------