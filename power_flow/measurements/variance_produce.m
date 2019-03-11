 function [msr] = variance_produce(user, msr)

%--------------------------------------------------------------------------
% Forms vector of measurement variances.
%
% The function forms measurement variances according to user inputs and
% options. Variances are defined as struct variables 'legvariance' for
% legacy measurements and 'pmuvariance' for phasor measurements, with three
% different options: 'unique', random' and 'type'.
%
%  Inputs:
%	- user: user inputs
%	- msr: measurement data
%
%  Outputs:
%	- msr.var{1}: variances for legacy measurements
%	- msr.var{2}: variances for phasor measurements
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%-----------------------------Unique Variance------------------------------
 if isfield(user, 'unique_legvariance')
	var = user.unique_legvariance;
	msr.var{1} = var * ones(msr.total(1),1);
 end

 if isfield(user, 'unique_pmuvariance')
	var = user.unique_pmuvariance;
	msr.var{2} = var * ones(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%----------------------------Random Variances------------------------------
 if isfield(user, 'random_legvariance')
	std_min = min(user.random_legvariance);
	std_max = max(user.random_legvariance);
	msr.var{1} = std_min + (std_max - std_min) .* rand(msr.total(1),1);
 end

 if isfield(user, 'random_pmuvariance')
	std_min = min(user.random_pmuvariance);
	std_max = max(user.random_pmuvariance);
	msr.var{2} = std_min + (std_max - std_min) .* rand(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%-----------------------------Type Variances-------------------------------
 if isfield(user, 'type_legvariance')
	var = user.type_legvariance;
	msr.var{1} = repelem(var, msr.tleg,1);
 end

 if isfield(user, 'type_pmuvariance')
	var = user.type_pmuvariance;
	msr.var{2} = repelem(var, msr.tpmu,1);
 end
%--------------------------------------------------------------------------