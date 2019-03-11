 clc
 clearvars

%--------------------------------------------------------------------------
% Runs AC or DC power flow.
%
% The AC power flow routine uses the Newton-Raphson Algorithm, where
% reactive power and voltage magnitudes constraints can be used, and only
% one constraint can be used for one simulation run.
%
%  User options:
%	- name of the mat-file that contains power system data
%	  example: flow.grid = 'ieee300_411';
%	- AC or DC power flow
%	  flow.module = 1 - AC power flow; flow.module = 2 - DC power flow;
%	- forces reactive power constraints
%	  flow.reactive = 1 - turn on;
%	- forces voltage magnitude constraints
%	  flow.voltage = 1 - forces constraints;
%	- bus data display
%	  flow.bus = 1 - turn on;
%	- branch data display
%	  flow.branch = 1 - turn on;
%	- save display data
%	  flow.save = 1 - turn on;
%
%  Outputs AC and DC power flow:
%	- results.method: name of the method
%	- results.grid: power system name
%	- results.time.pre: preprocessing time
%	- results.time.conv: convergence time
%	- results.time.pos: postprocessing time
%
%  Outputs AC power flow:
%	- results.bus with columns:
%	  (1)minimum limits violated at bus; (2)maximum limits violated at bus;
%	  (3)complex bus voltages; (4)apparent power injection;
%	  (5)generation apparent power; (6)load apparent power;
%	  (7)apparent power at shunt elements(Ssh)
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
%  Outputs DC power flow:
%	- results.bus with columns:
%	  (1)bus voltage angles; (2)active power injection;
%	  (3)active power generation
%	- results.branch: active power flow
%--------------------------------------------------------------------------


%-------------------------------Load Data----------------------------------
 flow.grid = 'ieee300_411';
%--------------------------------------------------------------------------


%---------------------------Power Flow Options-----------------------------
 flow.module = 1;
%-------------------
 flow.reactive = 0;
 flow.voltage = 0;
%-------------------
 flow.bus = 0;
 flow.branch = 0;
%--------------------------------------------------------------------------


%---------------------------------Extras-----------------------------------
 flow.save = 0;
%--------------------------------------------------------------------------


%------------------------------Main Function-------------------------------
 [data, results, sys] = leeloo;
%--------------------------------------------------------------------------