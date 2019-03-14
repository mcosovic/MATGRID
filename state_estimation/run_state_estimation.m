 function [se, data] = run_state_estimation(user, data)

%--------------------------------------------------------------------------
% Runs the non-linear and DC state estimation, as well as the state
% estimation with PMUs.
%
% The function first check if data from the power flow exists. If state
% estimation is run after power flow the algorithm directly proceeds with
% state estimation, otherwise preprocessing functions must be performed.
%
%  Inputs:
%    - user: user inputs
%    - data: power system data with measurement data
%
%  Outputs non-linear and DC state estimation:
%	- se.method: method name
%	- se.grid: power system name
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%	- se.time.pos: postprocessing time
%	- se.error.mae1, se.error.rmse1, se.error.wrss1: between estimated
%     values and measurement values
%	- se.error.mae2, se.error.rmse2, se.error.wrss2: metrics between
%     estimated values and exact values (if exist)
%	- se.error.mae3, se.error.rmse3: metrics between estimated state
%     variables and exact values (if exist)
%	- se.device with columns: (1)measurement type; (2)measurement unit
%	- se.estimate with columns:
%	  (1)measurement values; (2)measurement variances; (3)estimated values;
%	  (4)unit conversion; (4)exact values (if exist)
%
%  Outputs non-linear state estimation:
%	- se.bus with columns:
%	  (1)estimated complex bus voltages(Vc);
%     (2)apparent injection power(Si);
%	  (3)apparent power at shunt elements(Sph)
%	- se.branch with columns:
%	  (1)line current at branch - from bus(Iij);
%	  (2)line current at branch - to bus(Iji);
%	  (3)line current after branch shunt susceptance - from bus(Iijb);
%	  (4)line current after branch shunt susceptance - to bus(Ijib);
%	  (5)apparent power at branch - from bus(Sij);
%	  (6)apparent power at branch - to bus(Sji);
%	  (7)apparent power after branch shunt susceptance - from bus(Sijb);
%	  (8)apparent power after branch shunt susceptance - from bus(Sjib);
%	  (9)reactive power injection from shunt susceptances - from bus(Qis);
%	  (10)reactive power injection from shunt susceptances - to bus(Qjs);
%	  (11)apparent power of losses(Sijl)
%	- se.No: number of iterations
%
%  Outputs DC state estimation:
%	- se.bus with columns:
%	  (1)estimated bus voltage angles(Ti); (2)active power injection(Pi);
%	- se.branch with column: (1)active power flow
%
% The local function which is used in state estimation modules.
%--------------------------------------------------------------------------


%------------------------Preprocessing Functions---------------------------
 [data] = input_measurements(user, data);
 [data] = input_power_grid(data, user.module_estimate);
 [sys]  = branch_container(data.system);
 [sys]  = bus_container(data.system, data.stop, sys);
 [sys]  = numbering(data.system, sys);
%--------------------------------------------------------------------------


%----------------------------AC State Estimation---------------------------
 if user.module_estimate == 1
	[sys] = ybus_ac(sys);
	[br]  = branch_data_acse(sys);
	[sys] = compose_flow(data.legacy.flow, sys, br);
	[sys] = compose_current(data.legacy.current, data.pmu.current, sys, br);
	[sys] = compose_injection(data.legacy.injection, sys);
	[sys] = compose_voltage(data.legacy.voltage, data.pmu.voltage, sys);
	[sys, se] = compose_measurement(sys);
	[se] = gauss_newton(user, sys, se, data);
	[se] = processing_acse(sys, se);
	[sys, se] = evaluation_acse(data, sys, se);
	[se] = name_unit_acse(sys, se);
 end
%--------------------------------------------------------------------------


%--------------------------PMU State Estimation----------------------------
 if user.module_estimate == 2
    [sys] = ybus_ac(sys); 
    [br]  = branch_data_acse(sys); 
    [dat] = polar_to_rectangular(data);
    [dat, sys, se] = measurements_pmuse(dat, sys, br);
    [se] = solve_pmuse(sys, se);
	[se] = processing_acse(sys, se);
    [sys, se] = evaluation_pmuse(data, dat, sys, se);
    [se] = name_unit_pmuse(sys, se, dat);
 end
%--------------------------------------------------------------------------


%----------------------------DC State Estimation---------------------------
 if user.module_estimate == 3
	[sys] = preprocessing_dcse(sys);
	[dat, sys, se] = measurements_dcse(data, sys);
	[se] = solve_dcse(sys, se);
    [se] = processing_dcse(sys, se);
    [sys, se] = evaluation_dcse(dat, sys, se);
	[se] = name_unit_dcse(dat, sys, se);

	if any(user.linear_estimate == [1 2])
	   [data] = produce_Abv(data, user, sys, se);
	end
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.save_estimate, data.case);

 if user.bus_estimate == 1 || user.branch_estimate == 1 || user.estimation_estimate == 1 || user.evaluation_estimate == 1
	terminal_info(se, sys, user.module_estimate, user.grid_estimate, 0)
 end
 if user.bus_estimate == 1
	terminal_bus_se(se, sys, user.module_estimate);
 end
 if user.branch_estimate == 1
	terminal_flow(se, sys, user.module_estimate)
 end
 if user.estimation_estimate == 1
	termianl_measurement_se(se, sys);
 end
 if user.evaluation_estimate == 1
	terminal_evaluation_se(sys, se);
 end

 diary_off(user.save_estimate);
%--------------------------------------------------------------------------