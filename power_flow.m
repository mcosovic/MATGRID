 clc
 clearvars

%--------------------------------------------------------------------------
% Runs the AC or DC power flow analysis.
%
% The AC power flow routine uses the Newton-Raphson Algorithm, where
% reactive power and voltage magnitudes constraints can be used, and only
% one constraint can be used for one simulation run.
%
%  Examples:
%	leeloo('data5_6', 'ac', 'main');
%	leeloo('data5_6', 'ac', 'reactive', 'main');
%	leeloo('data5_6', 'dc', 'main', 'branch' 'save');
%--------------------------------------------------------------------------
%  Syntax:
%	leeloo(DATA, METHOD)
%	leeloo(DATA, METHOD, LIMIT)
%	leeloo(DATA, METHOD, LIMIT, DISPLAY, EXPORT)
%
%  Description:
%	- leeloo(DATA, METHOD) computes power flow problem according
%	- leeloo(DATA, METHOD, LIMIT) computes power flow problem considering
%	  reactive power and voltage magnitude constraints
%	- leeloo(DATA, METHOD, LIMIT, DISPLAY, EXPORT) allows to show results
%	  and export models
%
%  Input Arguments:
%	- DATA: the first input argument in the leeloo function must contain
%	  a name of the mat-file that contains power system data
%	- METHOD:
%		- 'ac': AC power flow analysis
%		- 'dc': DC power flow analysis
%	- LIMITS
%		- 'reactive': forces reactive power constraints
%		- 'voltage': forces voltage magnitude constraints
%	- DISPLAY
%		- 'main': main bus data display
%		- 'flow': power flow data display
%	- EXPORT
%		- 'save': save data display
%
% Note, except for the first input, the order of other inputs is arbitrary,
% as well as their appearance.
%--------------------------------------------------------------------------
%  Outputs AC and DC power flow analysis:
%	- results.method: name of the method
%	- results.grid: power system name
%	- results.time.pre: preprocessing time
%	- results.time.conv: convergence time
%	- results.time.pos: postprocessing time
%--------------------------------------------------------------------------
%  Outputs AC power flow analysis:
%	- results.bus with columns:
%	  (1)minimum limits violated at bus; (2)maximum limits violated at bus;
%	  (3)complex bus voltages; (4)apparent power injection;
%	  (5)generation apparent power; (6)load apparent power;
%	  (7)apparent power at shunt elements(Ssh)
%	- results.branch with columns:
%	  (1)line current at branch - from bus side;
%	  (2)line current at branch - to bus side;
%	  (3)line current after branch shunt susceptance - from bus side;
%	  (4)line current after branch shunt susceptance - to bus side;
%	  (5)apparent power at branch - from bus side;
%	  (6)apparent power at branch - to bus side;
%	  (7)apparent power after branch shunt susceptance - from bus side;
%	  (8)apparent power after branch shunt susceptance - from bus side;
%	  (9)reactive power injection from shunt susceptances - from bus side;
%	  (10)reactive power injection from shunt susceptances - to bus side;
%	  (11)apparent power of losses at branch
%	- results.No: number of iterations
%--------------------------------------------------------------------------
%  Outputs DC power flow analysis:
%	- results.bus with columns:
%	  (1)bus voltage angles; (2)active power injection;
%	  (3)active power generation
%	- results.branch: active power flow
%--------------------------------------------------------------------------


%---------------------------Power Flow Analysis----------------------------
 [results, data] = leeloo('ieee14_20', 'ac', 'main', 'flow');
%--------------------------------------------------------------------------