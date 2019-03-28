 function [msr] = variance_produce(user, msr)

%--------------------------------------------------------------------------
% Forms vector of measurement variances.
%
% The function forms measurement variances according to user inputs and
% options. 
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- msr: measurement data
%
%  Outputs:
%	- msr.var{1}: variances for legacy measurements
%	- msr.var{2}: variances for phasor measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-24
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Unique Variance------------------------------
 if ismember('legUnique', user.list)
	var = user.legUnique;
	msr.var{1} = var * ones(msr.total(1),1);
 end

 if ismember('pmuUnique', user.list)
	var = user.pmuUnique;
	msr.var{2} = var * ones(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%----------------------------Random Variances------------------------------
 if ismember('legRandom', user.list)
	std_min = min(user.legRandom);
	std_max = max(user.legRandom);
	msr.var{1} = std_min + (std_max - std_min) .* rand(msr.total(1),1);
 end

 if ismember('pmuRandom', user.list)
	std_min = min(user.pmuRandom);
	std_max = max(user.pmuRandom);
	msr.var{2} = std_min + (std_max - std_min) .* rand(msr.total(2),1);
 end
%--------------------------------------------------------------------------


%-----------------------------Type Variances-------------------------------
 if ismember('legType', user.list)
	var = user.legType;
	msr.var{1} = repelem(var, msr.tleg,1);
 end

 if ismember('pmuType', user.list)
	var = user.pmuType;
	msr.var{2} = repelem(var, msr.tpmu,1);
 end
%--------------------------------------------------------------------------