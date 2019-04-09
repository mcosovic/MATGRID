 function [se, data, sys] = runse(varargin)

%--------------------------------------------------------------------------
% Runs the non-linear and DC state estimation, as well as the state
% estimation with PMUs.
%
% The function first checks state estimation settings and measurment data,
% and proceeds with state estimation rotuines.
%--------------------------------------------------------------------------
%  Input:
%	- varargin: user inputs
%
%  Output:
%	- se: see the output variable result.info
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-26
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------Processing Inputs and Settings-----------------------
 [user, data] = settings_state_estimation(varargin);
 [data] = load_power_system(data, user);
 [data] = load_measurements(user, data);
 
 if ismember('bad', user.list)
    [user] = check_bad_data(user); 
 end
%--------------------------------------------------------------------------


%------------------------Preprocessing Functions---------------------------
 [sys] = container(data); 
 
 if any(ismember({'nonlinear', 'pmu', 'pmuOptimal'}, user.list))
    [sys] = ybus_ac(sys);
 end
 
 [data] = runplay(user, data, sys);
%--------------------------------------------------------------------------


%----------------------------AC State Estimation---------------------------
 if ismember('nonlinear', user.list)
    [user] = check_start(user);
    [user] = check_maxiter(user);
     
    [bra] = branch_data_acse(sys); 
 	[sys] = compose_flow(data.legacy.flow, sys, bra);
 	[sys] = compose_current(data.legacy.current, data.pmu.current, sys, bra);
 	[sys] = compose_injection(data.legacy.injection, sys);
 	[sys] = compose_voltage(data.legacy.voltage, data.pmu.voltage, sys);
 	[sys, se] = compose_measurement(sys);
            
    if ismember('bad', user.list)
       [se] = gauss_newton_bad_data(user, sys, se, data);
    elseif ismember('lav', user.list)
       [se] = gauss_newton_lav(user, sys, se, data);
    else
       [se] = gauss_newton(user, sys, se, data);
    end

	[se] = processing_acse(sys, se);
	[sys, se] = evaluation_acse(data, sys, se);
	[se] = name_unit_acse(sys, se);
    [se] = info_acse(user.list, se);
 end
%--------------------------------------------------------------------------


%--------------------------PMU State Estimation----------------------------
 if ismember('pmu', user.list)
	[br] = branch_data_acse(sys);
	[dat] = polar_to_rectangular(data);
 	[dat, sys] = measurements_pmuse(dat, sys, br);
    
    if ismember('bad', user.list)
       [se] = solve_pmuse_bad_data(user, sys);
       [sys] =  name_unit_bad_data(dat, sys);
    elseif ismember('lav', user.list)
       [se] = solve_pmuse_lav(sys);
    else
       [se] = solve_pmuse(sys);
    end
     
	[se] = processing_acse(sys, se);
 	[sys, se] = evaluation_pmuse(data, dat, sys, se);
 	[se] = name_unit_pmuse(sys, se, dat);
    [se] = info_acse(user.list, se);
 end
%--------------------------------------------------------------------------


%---------------------------DC State Estimation----------------------------
 if ismember('dc', user.list)
    [sys] = ybus_shift_dc(sys); 
    
    if ismember('observe', user.list)
       [data, se] = observability_dc(data, sys, user);
    else
       se = [];
    end
    
    [bra] = branch_data_dcse(sys);
    [sys] = compose_flow_dcse(data.legacy.flow, sys, bra);
    [sys] = compose_injection_dcse(data.legacy.injection, sys);
    [sys] = compose_voltage_dcse(data.pmu.voltage, sys);
    [sys, se] = compose_measurement_dcse(sys, se);
   
    if ismember('bad', user.list)
       [se] = solve_dcse_bad_data(user, sys, se);
    elseif ismember('lav', user.list)
       [se] = solve_dcse_lav(sys, se);
    else
       [se] = solve_dcse(sys, se);
    end
    
    [se] = processing_dcse(sys, se);
 	[sys, se] = evaluation_dcse(data, sys, se);
 	[se] = name_unit_dcse(data, sys, se);
    [se] = info_dcse(se);
 end
%--------------------------------------------------------------------------


%--------------------------------Terminal----------------------------------
 diary_on(user.list, data.case);

 if any(ismember({'main', 'flow', 'estimate', 'error', 'bad', 'observe'}, user.list))
	terminal_info(se, sys, user.list)
 end
 if ismember('observe', user.list)
    terminal_observability(se, user.list)
 end
 if ismember('bad', user.list)
	terminal_bad_data(se, sys, user.list)
 end
 if ismember('main', user.list)
	terminal_bus_se(se, sys, user.list)
 end
 if ismember('flow', user.list)
	terminal_flow(se, sys, user.list)
 end
 if ismember('estimate', user.list)
	termianl_measurement_se(se, sys);
 end
 if ismember('error', user.list)
	terminal_error_se(sys, se);
 end

 diary_off(user.list);
%--------------------------------------------------------------------------


%-------------------------------Export Data--------------------------------
if any(ismember({'export', 'exportSlack'}, user.list))
   [data] = produce_Abv(data, sys, se, user.list);
 end
%--------------------------------------------------------------------------