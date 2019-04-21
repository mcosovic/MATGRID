 function termianl_measurement_se(in, se)

%--------------------------------------------------------------------------
% Displays measurement data after state estimation algorithms.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-26
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%% Measurement Terminal with Exact Values
 if se.exact == 1
	if se.Nleg ~= 0
	   leg      = 1:se.Nleg;
	   num      = string(leg');
	   estimate = compose('%1.2f', in.estimate.Estimate(leg));
	   measure  = compose('%1.2f', in.estimate.Mean(leg));
	   residu1  = compose('%1.2e', in.estimate.Residual(leg));
	   exact    = compose('%1.2f', in.estimate.Exact(leg));
	   residu2  = compose('%1.2e', in.estimate.Residual2(leg));
	   variance = compose('%1.2e', in.estimate.Variance(leg));
	   legacy   = [num in.estimate.Device(leg) in.estimate.Unit(leg) estimate measure residu1 exact residu2 variance]';

	   disp(' ')
	   disp('   _______________________________________________________________________________________________________________________________________')
	   disp('  |                                                       Legacy Measurement Devices                                                      |')
	   disp('  |                                                                                                                                       |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Exact      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|-----------------------------|------------------|')
	   fprintf('  |     %-8s   %-11s %6s %14s     | %11s %13s     | %9s %13s     | %12s     | \n', legacy{:})

	   disp('  |______________________________________________________|_______________________________|_____________________________|__________________|')
	end
	if se.Npmu ~= 0
	   pmu      = se.Nleg + 1: se.Nleg+se.Npmu;
	   num      = string(pmu');
	   estimate = compose('%1.2f',in.estimate.Estimate(pmu));
	   measure  = compose('%1.2f', in.estimate.Mean(pmu));
	   residu1  = compose('%1.2e', in.estimate.Residual(pmu));
	   exact    = compose('%1.2f', in.estimate.Exact(pmu));
	   residu2  = compose('%1.2e', in.estimate.Residual2(pmu));
	   variance = compose('%1.2e', in.estimate.Variance(pmu));
	   pmu      = [num in.estimate.Device(pmu) in.estimate.Unit(pmu) estimate measure residu1 exact residu2 variance]';

	   disp(' ')
	   disp('   _______________________________________________________________________________________________________________________________________')
	   disp('  |                                                       Phasor Measurement Devices                                                      |')
	   disp('  |                                                                                                                                       |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Exact      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|-----------------------------|------------------|')
	   fprintf('  |     %-8s   %-11s %5s %15s     | %11s %13s     | %9s %13s     | %12s     | \n', pmu{:})

	   disp('  |______________________________________________________|_______________________________|_____________________________|__________________|')
	end
 end

%% Measurement Terminal without Exact Values
 if se.exact == 0
	if se.Nleg ~= 0
	   leg      = 1:se.Nleg;
	   num      = string(leg');
	   estimate = compose('%1.2f', in.estimate.Estimate(leg));
	   measure  = compose('%1.2f', in.estimate.Mean(leg));
	   residu1  = compose('%1.2e', in.estimate.Residual(leg));
	   variance = compose('%1.2e', in.estimate.Variance(leg));
	   legacy   = [num in.estimate.Device(leg) in.estimate.Unit(leg) estimate measure residu1 variance]';

	   disp(' ')
	   disp('   _________________________________________________________________________________________________________')
	   disp('  |                                        Legacy Measurement Devices                                       |')
	   disp('  |                                                                                                         |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|------------------|')
	   fprintf('  |     %-8s   %-11s %5s %15s     | %11s %13s     | %12s     | \n', legacy{:})

	   disp('  |______________________________________________________|_______________________________|__________________|')
	end
	if se.Npmu ~= 0
	   pmu      = se.Nleg + 1: se.Nleg+se.Npmu;
	   num      = string(pmu');
	   estimate = compose('%1.2f',in.estimate.Estimate(pmu));
	   measure  = compose('%1.2f', in.estimate.Mean(pmu));
	   residu1  = compose('%1.2e', in.estimate.Residual(pmu));
	   variance = compose('%1.2e', in.estimate.Variance(pmu));
	   pmu      = [num in.estimate.Device(pmu) in.estimate.Unit(pmu) estimate measure residu1 variance]';

	   disp(' ')
	   disp('   _________________________________________________________________________________________________________')
	   disp('  |                                        Phasor Measurement Devices                                       |')
	   disp('  |                                                                                                         |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|------------------|')
	   fprintf('  |     %-8s   %-11s %5s %15s     | %11s %13s     | %12s     | \n', pmu{:})

	   disp('  |______________________________________________________|_______________________________|__________________|')
	end
 end