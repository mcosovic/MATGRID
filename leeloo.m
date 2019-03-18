 function [data, results] = leeloo(varargin)

%--------------------------------------------------------------------------
% Proceeds to the different check functions and runs main routines.
%
% Using 'power_flow.m', leeloo function forces the power flow analysis,
% similarly, using 'state_estimation.m', it forces state estimation
% routine. The function leello, if a user uses 'flow_estimation.m', forces
% power flow and generates measurement data, then proceeds to the state
% estimation.
%--------------------------------------------------------------------------
%  Outputs AC and DC power flow, non-linear and DC state estimation:
%	- data: selected input case
%	- results.method: name of the method
%	- results.grid: power system name
%	- results.time.pre: preprocessing time
%	- results.time.conv: convergence time
%	- results.time.pos: postprocessing time
%--------------------------------------------------------------------------
%  Outputs DC power flow:
%	- results.bus with columns:
%	  (1)bus voltage angles(Ti); (2)active power injection(Pi);
%	  (3)active power generation(Pg)
%	- results.branch with column: (1)active power flow(Pij)
%--------------------------------------------------------------------------
%  Outputs AC power flow:
%	- results.bus with columns:
%	  (1)minimum bus limits violated; (2)maximum bus limits violated;
%	  (3)complex bus voltages; (4)apparent power injection(Si);
%	  (5)generator apparent power (Sg); (6)load apparent power(Sl);
%	  (7)apparent power at shunt elements(Ssh)
%	- results.branch with columns:
%	  (1)branch line current from bus(Iij);
%	  (2)branch line current to bus(Iji);
%	  (3)line current from bus after branch shunt susceptance(Iijb);
%	  (4)line current to bus after branch shunt susceptance(Ijib);
%	  (5)branch apparent power from bus(Sij);
%	  (6)branch apparent power to bus(Sji);
%	  (7)apparent power from bus after branch shunt susceptance(Sijb);
%	  (8)apparent power to bus after branch shunt susceptance(Sjib);
%	  (9)reactive power injection from shunt susceptances from bus(Qis);
%	  (10)reactive power injection from shunt susceptances to bus(Qjs);
%	  (11)apparent power loss(Sijl)
%	- pf.No: number of iterations
%--------------------------------------------------------------------------
%  Outputs DC state estimation:
%	- results.b, results.H, results.v: system model for solving
%	- results.Nleg: number of legacy measurements
%	- results.Npmu: number of phasor measurements 
%	- results.Ntot: total number of measurements
%	- results.bus with columns: 
%	  (1)estimated bus voltage angles(Ti); (2)active power injection(Pi); 
%	- results.branch with column: (1)active power flow(Pij) 
%	- results.name with columns: (1)measurement type; (2)measurement unit
%	- results.esti with column: 
%	  (1)unit conversion; (2)measurement values; (3) estimated values;
%	  (4)exact values
%	- results.error.mae1, results.error.rmse1, results.error.wrss1: 
%	  metrics between estimated values and measurement values
%	- results.error.mae2, results.error.rmse2, results.error.wrss2: 
%	  metrics between estimated values and exact values
%	- results.error.mae3, results.error.rmse3: metrics between estimated 
%	  state variables and corresponding exact values
%--------------------------------------------------------------------------
% Main function which is used for all different modules.
%--------------------------------------------------------------------------


%--------------------Generate Path Name and Call Stack---------------------
 addpath(genpath(pwd))
 
 run_mfile = dbstack();
 run_mfile(2).file;
%--------------------------------------------------------------------------


%-------------------------Proceeds with Routines---------------------------
 if strcmp(run_mfile(2).file, 'power_flow.m')
    [user, data] = settings_power_flow(varargin);
	[results, data] = run_power_flow(user, data);
    
 elseif strcmp(run_mfile(2).file, 'state_estimation.m')
    [user, data] = settings_state_estimation(varargin); 
    [results, data] = run_state_estimation(user, data);

 elseif strcmp(run_mfile(2).file, 'generator.m')
    [user, data] = settings_generator(varargin);  
    [data] = run_measurement_generator(user, data);
    
 else
    error_source_file
 end
%--------------------------------------------------------------------------