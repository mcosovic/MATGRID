 function [data] = rungen(varargin)

%--------------------------------------------------------------------------
% Builds measurement data from the AC power flow analysis.

% The function corrupts the exact solutions by the additive white Gaussian
% noises according to defined variances. Further, the function forms
% measurement set according to predefined inputs.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%
%  Outputs:
%	- data: with additional struct variables:
%	  - data.legacy.flow with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)active power flow measurements;
%		(4)active power flow measurement variances;
%		(5)active power flow measurements turn on/off;
%		(6)reactive power flow measurements;
%		(7)reactive power flow measurement variances;
%		(8)reactive power flow measurement turn on/off;
%		(9)active power flow exact value;
%		(10)reactive power flow exact value;
%	  - data.legacy.current with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurement turn on/off;
%		(6)line current magnitude exact value;
%	  - data.legacy.injection with columns:
%		(1)bus indexes; (2)active power injection measurements;
%		(3)active power injection measurement variances;
%		(4)active power injection measurements turn on/off;
%		(5)reactive power injection measurements;
%		(6)reactive power injection measurement variances;
%		(7)reactive power injection measurements turn on/off;
%		(9)active power injection exact value;
%		(10)reactive power injection exact value;
%	  - data.legacy.voltage with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage magnitude exact value;
%	  - data.pmu.current with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurements turn on/off;
%		(6)line current angle measurements;
%		(7)line current angle measurement variances;
%		(8)line current angle measurements turn on/off;
%		(9)line current magnitude exact value;
%		(10)line current angle exact value;
%	  - data.pmu.voltage with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage angle measurements;
%		(6)bus voltage angle measurement variances;
%		(7)bus voltage angle measurements turn on/off;
%		(8)bus voltage magnitude exact value;
%		(9)bus voltage angle exact value;
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-24
% Last revision by Mirsad Cosovic on 2019-03-28
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------Processing Inputs and Settings-----------------------
 [user, data] = settings_generator(varargin);
 [data] = load_power_system(data, user.list);
%--------------------------------------------------------------------------


%-----------------------------AC Power Flow--------------------------------
 [sys] = container(data);
 [user] = check_maxiter(user);
 [sys]  = ybus_ac(sys);
 [pf] = newton_raphson(user, sys);
 [pf] = processing_acpf(sys, pf);
%--------------------------------------------------------------------------


%-------------------------Measurement Statistics---------------------------
 [msr] = variable_device(sys);
%--------------------------------------------------------------------------


%----------------------------Measurement Sets------------------------------
 [user] = check_measurement_set(user, msr);
 [user, msr] = set_produce(user, msr, sys);
%--------------------------------------------------------------------------


%--------------------------Measurement Variances---------------------------
 [user] = check_measurement_variance(user);
 [msr]  = variance_produce(user, msr);
%--------------------------------------------------------------------------


%---------------------------Export Measurements----------------------------
 [data] = export_measurement(data, user, sys, msr, pf);
%--------------------------------------------------------------------------


%----------------------------Export Info Data------------------------------
 [data] = export_info(data, user, msr);
%--------------------------------------------------------------------------


%--------------------------------Display-----------------------------------
 disp(' Measurment data is successfully generated.')
%--------------------------------------------------------------------------
