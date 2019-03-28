 function [user] = check_measurement_variance(user)

%--------------------------------------------------------------------------
% Checks input values for measurement variances.
%
% The function checks 'legUnique', 'legRandom', 'legType', 'pmuUnique',
% 'pmuRandom', and 'pmuType' values, given as input arguments of the
% function runse. If variables are missing or are not properly defined, we
% add default values, which allows to execute a code without errors.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%
%  Outputs:
%	- user.legUnique: unique variance for legacy measurements
%	- user.pmuUnique: unique variance for phasor measurements
%	- user.legRandom: random variances for legacy measurements
%	- user.pmuRandom: random variances for phasor measurements
%	- user.legType: variances per type for legacy measurements
%	- user.pmuType: variances per type for phasor measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-01
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------------Default Settings------------------------------
 unique_leg = 10^-12;
 random_leg = [10^-9 10^-8];
 type_leg   = [10^-6 10^-8 10^-8 10^-6 10^-8 10^-8];

 unique_pmu = 10^-12;
 random_pmu = [10^-12; 10^-10];
 type_pmu   = [10^-10 10^-12 10^-10 10^-12];
%--------------------------------------------------------------------------


%--------------------Check Phasor Measurement Variance---------------------
 if ismember('pmuUnique', user.list) && ~isempty(user.pmuUnique) && (~isvector(user.pmuUnique) || ~(length(user.pmuUnique) == 1)  || user.pmuUnique <= 0)
	user.pmuUnique = unique_pmu;
	warning('se:pmuUnique', ['The value pair argument of the '...
	'variable "pmuUnique" has invalid type. The algorithm ' ...
	'proceeds with default value: %1.e.\n'], unique_pmu)
 elseif ismember('pmuUnique', user.list) && isempty(user.pmuUnique)
	user.pmuUnique = unique_pmu;
 end

 if ismember('pmuRandom', user.list) && ~isempty(user.pmuRandom) && (~isvector(user.pmuRandom) || ~(length(user.pmuRandom) == 2)  || any(user.pmuRandom <= 0))
	user.pmuRandom = random_pmu;
	warning('se:pmuRandom', ['The value pair argument of the '...
	'variable "pmuRandom" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e].\n'], random_pmu(1), random_pmu(2))
 elseif ismember('pmuRandom', user.list) && isempty(user.pmuRandom)
	user.pmuRandom = random_pmu;
 end

 if ismember('pmuType', user.list) && ~isempty(user.pmuType)
	dim = size(user.pmuType);
	if dim(1) == 1
	   user.pmuType = user.pmuType';
	end
	if ~isvector(user.pmuType) || ~(length(user.pmuType) == 4) || any(user.pmuType <= 0)
	user.pmuType = type_pmu;
	warning('se:pmuType', ['The value pair argument of the '...
	'variable "pmuType" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e %1.e %1.e].\n'], ...
	type_pmu(1), type_pmu(2), type_pmu(3), type_pmu(4))
	end
 elseif ismember('pmuType', user.list) && isempty(user.pmuType)
	user.pmuType = type_pmu;
 end
%--------------------------------------------------------------------------


%--------------------Check Legacy Measurement Variance---------------------
 if ismember('legUnique', user.list) && ~isempty(user.legUnique) && (~isvector(user.legUnique) || ~(length(user.legUnique) == 1)  || user.legUnique <= 0)
	user.legUnique = unique_leg;
	warning('se:legUnique', ['The value pair argument of the '...
	'variable "legUnique" has invalid type. The algorithm ' ...
	'proceeds with default value: %1.e.\n'], unique_leg)
 elseif ismember('legUnique', user.list) && isempty(user.legUnique)
	user.legUnique = unique_leg;
 end

 if ismember('legRandom', user.list) && ~isempty(user.legRandom) && (~isvector(user.legRandom) || ~(length(user.legUnique) == 2)  || any(user.legRandom <= 0))
	user.legRandom = random_leg;
	warning('se:legRandom', ['The value pair argument of the '...
	'variable "legRandom" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e].\n'], random_leg(1), random_leg(2))
 elseif ismember('legRandom', user.list) && isempty(user.legRandom)
	user.legRandom = random_leg;
 end

 if ismember('legType', user.list) && ~isempty(user.legType)
	dim = size(user.legType);
	if dim(1) == 1
	   user.legType = user.legType';
	end
	if ~isvector(user.legType) || ~(length(user.legType) == 6) || any(user.legType <= 0)
	   user.legType = type_leg;
	   warning('se:legType', ['The value pair argument of the '...
	'variable "legType" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e %1.e %1.e %1.e %1.e].\n'], ...
	type_leg(1), type_leg(2), type_leg(3), type_leg(4), type_leg(5), type_leg(6))
	end
 elseif ismember('legType', user.list) && isempty(user.legType)
	user.legType = type_leg;
 end
%--------------------------------------------------------------------------