 function [se, data] = run_state_estimation(user, data)

%--------------------------------------------------------------------------
% Runs the non-linear and DC state estimation, as well as the state
% estimation with PMUs.
%
% The function first checks state estimation settings and measurment data,
% and proceeds with state estimation rotuines.
%--------------------------------------------------------------------------
%  Input:
%	- var: native user settings
%--------------------------------------------------------------------------
%  Outputs non-linear, PMU and DC state estimation:
%	- se.method: method name
%	- se.grid: power system name
%	- se.time.pre: preprocessing time
%	- se.time.conv: convergence time
%	- se.time.pos: postprocessing time
%	- se.error.mae1, se.error.rmse1, se.error.wrss1: between estimated
%	  values and measurement values
%	- se.error.mae2, se.error.rmse2, se.error.wrss2: metrics between
%	  estimated values and exact values (if exist)
%	- se.error.mae3, se.error.rmse3: metrics between estimated state
%	  variables and exact values (if exist)
%	- se.device with columns: (1)measurement type; (2)measurement unit
%	- se.estimate with columns:
%	  (1)measurement values; (2)measurement variances; (3)estimated values;
%	  (4)unit conversion; (4)exact values (if exist)
%--------------------------------------------------------------------------
%  Outputs non-linear and PMU state estimation:
%	- se.bus with columns:
%	  (1)estimated complex bus voltages(Vc);
%	  (2)apparent injection power(Si);
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
%--------------------------------------------------------------------------
%  Outputs DC state estimation:
%	- se.bus with columns:
%	  (1)estimated bus voltage angles(Ti); (2)active power injection(Pi);
%	- se.branch with column: (1)active power flow
%--------------------------------------------------------------------------
% The local function which is used in state estimation modules.
%--------------------------------------------------------------------------


%------------------Processing Module Inputs and Settings-------------------
 [data] = load_measurements(user, data);
%--------------------------------------------------------------------------


%------------------------Preprocessing Functions---------------------------
 [sys] = run_container(data); 
 
 if user.se == 1 || user.se == 3 || user.setpmu == 3
    [sys] = ybus_ac(sys);
 end
 
 [data] = run_play_measurement(user, data, sys);
%--------------------------------------------------------------------------


%----------------------------AC State Estimation---------------------------
 if user.se == 1
    [user] = check_start(user);  
    [br]  = branch_data_acse(sys); 
	[sys] = compose_flow(data.legacy.flow, sys, br);
	[sys] = compose_current(data.legacy.current, data.pmu.current, sys, br);
	[sys] = compose_injection(data.legacy.injection, sys);
	[sys] = compose_voltage(data.legacy.voltage, data.pmu.voltage, sys);
	[sys, se] = compose_measurement(sys);
    
    if user.bad == 1
       [user] = check_bad_data(user); 
       [se] = gauss_newton_bad_data(user, sys, se, data);
    else
       [se] = gauss_newton(user, sys, se, data);
    end

	[se] = processing_acse(sys, se);
	[sys, se] = evaluation_acse(data, sys, se);
	[se] = name_unit_acse(sys, se);
 end
%--------------------------------------------------------------------------


%--------------------------PMU State Estimation----------------------------
 if user.se == 3
    [br]  = branch_data_acse(sys);
	[dat] = polar_to_rectangular(data);
	[dat, sys] = measurements_pmuse(dat, sys, br);
    
    if user.bad == 1
       [user] = check_bad_data(user); 
       [se] = solve_pmuse_bad_data(user, sys);
       [sys] =  name_unit_bad_data(dat, sys);
    else
	[se] = solve_pmuse(sys);
    end
    
	[se] = processing_acse(sys, se);
	[sys, se] = evaluation_pmuse(data, dat, sys, se);
	[se] = name_unit_pmuse(sys, se, dat);
 end
%--------------------------------------------------------------------------


%---------------------------DC State Estimation----------------------------
 if user.se == 2
	[sys] = preprocessing_dcse(sys);
	[dat, sys, se] = measurements_dcse(data, sys);
	    
    if user.bad == 1
       [user] = check_bad_data(user); 
       [se] = solve_dcse_bad_data(user, sys, se);
    else
       [se] = solve_dcse(sys, se);
    end
    
	[se] = processing_dcse(sys, se);
	[sys, se] = evaluation_dcse(dat, sys, se);
	[se] = name_unit_dcse(dat, sys, se);
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.save, data.case);

 if user.main == 1 || user.flow == 1 || user.estimate == 1 || user.error == 1 || user.bad == 1
	terminal_info(se, sys, user.se, user.grid, 0)
 end
 if user.bad == 1
	terminal_bad_data(se, user.se, sys)
 end
 if user.main == 1
	terminal_bus_se(se, sys, user.se)
 end
 if user.flow == 1
	terminal_flow(se, sys, user.se)
 end
 if user.estimate == 1
	termianl_measurement_se(se, sys);
 end
 if user.error == 1
	terminal_evaluation_se(sys, se);
 end

 diary_off(user.save);
%--------------------------------------------------------------------------


%-------------------------------Export Data--------------------------------
 if user.export == 1 || user.exports == 1
    [data] = produce_Abv(data, user, sys, se);
 end
%--------------------------------------------------------------------------