 function [user] = measurement_set(user, msr)

%--------------------------------------------------------------------------
% Checks input measurement sets.
%
% The function checks legset and pmuset, wherein the expected inputs are
% 'redundancy', 'device' and 'optimal'. If variables are missing or are not
% properly defined, we add default values, which allows to execute a code
% without errors.
%
%  Input:
%	- user: user inputs
%
%  Outputs:
%	- user.redundancy_legset: set according to redundancy for legacy
%	  measurements
%	- user.device_legset: set according to devices for legacy measurements
%	- user.redundancy_pmuset: set according to redundancy for phasor
%	  measurements
%	- user.device_pmuset: set according to devices for phasor measurements
%	- user.device_legset: optimal PMU location to make the entire system 
%     completely observable
%	- user.optimal_pmuset: optimal PMU locations
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%------------------------------Default Sets--------------------------------
 redund_leg = msr.mred(1);
 device_leg = msr.dleg;

 redund_pmu = msr.mred(2);
 device_pmu = msr.dpmu;
%--------------------------------------------------------------------------


%----------------------Check Legacy Measurement Set------------------------
 set = isfield(user, {'redundancy_legset', 'device_legset'});

 if all(~set)
	user.redundancy_legset = redund_leg;
	warning('Set:LegAllowed', ['The variable "legset" requires at least one input argument: ' ...
			'\n\t"legset.redundancy" - randomize legacy measurements according to redundancy'...
			'\n\t"legset.device" - number of active measurement devices over subset of legacy devices [power flow], [current magnitude], [power injection], [voltage magnitude]'...
			'\nThe algorithm proceeds with default option: %1.f.\n', redund_leg])
 end

 if set(1) && (~isvector(user.redundancy_legset) || ~(length(user.redundancy_legset) == 1) || user.redundancy_legset < 0 || user.redundancy_legset > redund_leg)
	user.redundancy_legset = redund_leg;
	warning('Set:LegRedundancy', 'The variable expression "legset.redundancy" has invalid type. The algorithm proceeds with default value: %1.f.\n', redund_leg)
 end
 if set(2)
	dim = size(user.device_legset);
	if dim(1) == 1
	   user.device_legset = user.device_legset';
	end
	if ~isvector(user.device_legset) || ~(length(user.device_legset) == 4) || any(user.device_legset < 0) || any(user.device_legset > device_leg)
	   user.device_legset = device_leg;
	   warning('Set:LegDevice', 'The variable expression "legset.device" has invalid type. The algorithm proceeds with default value: [%1.f %1.f %1.f %1.f].\n', device_leg(1), device_leg(2), device_leg(3), device_leg(4))
	end
 end
%--------------------------------------------------------------------------


%------------------------Check PMU Measurement Set-------------------------
 set = isfield(user, {'redundancy_pmuset', 'device_pmuset', 'optimal_pmuset'});

 if all(~set)
	user.redundancy_pmuset = redund_pmu;
	warning('Set:PmuAllowed', ['The variable "pmuset" requires at least one input argument: ' ...
			'\n\t"pmuset.redundancy" - randomize measurements from PMUs (magnitudes and angles) according to redundancy'...
			'\n\t"pmuset.device" - number of active PMUs placed at buses' ...
            '\n\t"pmuset.optimal" - optimal PMU location to make the entire system completely observable' ...
			'\nThe algorithm proceeds with default option: %1.f.\n', redund_pmu])
 end

 if set(1) && (~isvector(user.redundancy_pmuset) || ~(length(user.redundancy_pmuset) == 1) || user.redundancy_pmuset < 0 || user.redundancy_pmuset > redund_pmu)
	user.redundancy_pmuset = redund_pmu;
	warning('Set:PmuRedundancy', 'The variable expression "pmuset.redundancy" has invalid type. The algorithm proceeds with default value: %1.f.\n', redund_pmu)
 end
 if set(2)
	dim = size(user.device_pmuset);
	if dim(1) == 1
	   user.device_pmuset = user.device_pmuset';
	end
	if ~isvector(user.device_pmuset) || ~(length(user.device_pmuset) == 1) || user.device_pmuset < 0 || user.device_pmuset > device_pmu
	   user.device_pmuset = device_pmu;
	   warning('Set:PmuDevice', 'The variable expression "pmuset.device" has invalid type. The algorithm proceeds with default value: %1.f.\n', device_pmu)
	end
 end
 if set(3) && (~isvector(user.optimal_pmuset) || ~(length(user.optimal_pmuset) == 1) || user.optimal_pmuset ~= 1)
	user.redundancy_pmuset = 0;
	warning('Set:PmuOptimal', 'The variable expression "pmuset.optimal" has invalid type. The algorithm proceeds without PMU set.\n')
 end
%--------------------------------------------------------------------------