 clc
 clearvars

%--------------------------------------------------------------------------
% Runs the AC or DC power flow analysis.
%
% The AC power flow routine by default uses the Newton-Raphson Algorithm,
% where reactive power and voltage magnitudes constraints can be used, and
% only one constraint can be used for one simulation run. Additional
% algorithms that can be used are: Gauss-Seidel, decoupled Newton-Raphson,
% and fast decoupled Newton-Raphson (version BX) algorithm.
%
%  Examples:
%	runpf('ieee14_20', 'nr', 'main');
%	runpf('ieee14_20', 'nr', 'maxIter', 100, 'main');
%	runpf('ieee14_20', 'dnr', 'reactive', 'main');
%	runpf('ieee14_20', 'fdnr', 'voltage', 'main');
%	runpf('ieee14_20', 'dc', 'main', 'flow' 'save');
%--------------------------------------------------------------------------
%  Syntax:
%	runpf(DATA, METHOD)
%	runpf(DATA, METHOD, LIMIT)
%	runpf(DATA, METHOD, LIMIT, ATTACH)
%	runpf(DATA, METHOD, LIMIT, ATTACH, DISPLAY, EXPORT)
%
%  Description:
%	- runpf(DATA, METHOD) computes power flow problem
%	- runpf(DATA, METHOD, LIMIT) considering constraints
%	- runpf(DATA, METHOD, LIMIT, ATTACH) maximum number of iterations
%	- runpf(DATA, METHOD, LIMIT, ATTACH, DISPLAY, EXPORT) allows to show
%	  results and export models
%
%  Input Arguments:
%	- DATA: the first input argument in the runpf function must contain
%	  a name of the mat-file that contains power system data
%	- METHOD:
%		- 'nr': AC power flow analysis using Newton-Raphson algorithm
%		- 'gs': AC power flow analysis using Gauss-Seidel algorithm
%		- 'dnr': AC power flow analysis using decoupled
%		   Newton-Raphson algorithm
%		- 'fdnr': AC power flow analysis using fast decoupled
%		   Newton-Raphson algorithm (version BX)
%		- 'dc': DC power flow analysis
%	- LIMIT
%		- 'reactive': forces reactive power constraints
%		- 'voltage': forces voltage magnitude constraints
%	- ATTACH
%		- 'maxIter', X: AC power flow maximum number of iterations(X)
%	- DISPLAY
%		- 'main': main bus data display
%		- 'flow': power flow data display
%	- EXPORT
%		- 'save': save data display
%
% Although the syntax is given in a certain order, for methodological
% reasons, only DATA must appear as the first input argument, and the order
% of other inputs is arbitrary, as well as their appearance.
%--------------------------------------------------------------------------
%  Outputs:
%	- result: see the output variable result.info
%	- data: input power system data
%--------------------------------------------------------------------------


%---------------------------Generate Path Name-----------------------------
 addpath(genpath(fileparts(which(mfilename))));
%--------------------------------------------------------------------------


%---------------------------Power Flow Analysis----------------------------
 [result, data] = runpf('ieee14_20', 'fdnr', 'main', 'flow');
%--------------------------------------------------------------------------