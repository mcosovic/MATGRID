 function [msr] = variance_produce(user, msr)

%--------------------------------------------------------------------------
% Forms vector of measurement variances.
%
% The function forms measurement variances according to user inputs and
% options. Variances are defined as struct variables 'legvariance' for
% legacy measurements and 'pmuvariance' for phasor measurements, with three
% different options: 'unique', random' and 'type'.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- msr: measurement data
%
%  Outputs:
%	- msr.var{1}: variances for legacy measurements
%	- msr.var{2}: variances for phasor measurements
%--------------------------------------------------------------------------
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%-----------------------------Unique Variance------------------------------
 if user.varleg == 1
	var = user.legUnique;
	msr.var{1} = var * ones(msr.total(1),1);
 end

 if user.varpmu == 1
	var = user.pmuUnique;
	msr.var{2} = var * ones(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%----------------------------Random Variances------------------------------
 if user.varleg == 2
	std_min = min(user.legRandom);
	std_max = max(user.legRandom);
	msr.var{1} = std_min + (std_max - std_min) .* rand(msr.total(1),1);
 end

 if user.varpmu == 2
	std_min = min(user.pmuRandom);
	std_max = max(user.pmuRandom);
	msr.var{2} = std_min + (std_max - std_min) .* rand(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%-----------------------------Type Variances-------------------------------
 if user.varleg == 3
	var = user.legType;
	msr.var{1} = repelem(var, msr.tleg,1);
 end

 if user.varpmu == 3
	var = user.pmuType;
	msr.var{2} = repelem(var, msr.tpmu,1);
 end
%--------------------------------------------------------------------------