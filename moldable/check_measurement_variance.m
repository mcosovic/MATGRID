 function [user] = check_measurement_variance(user)

%--------------------------------------------------------------------------
% Checks input values for measurement variances.
%
% The function checks 'legUnique', 'legRandom', 'legType', 'pmuUnique',
% 'pmuRandom', and 'pmuType' values, given as input arguments of the
% function leeloo in the 'power_estimation.m'. If variables are missing or
% are not properly defined, we add default values, which allows to execute
% a code without errors.
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
% Check function which is used in state estimation modules.
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
 if user.varpmu == 1 && ~isempty(user.pmuUnique) && (~isvector(user.pmuUnique) || ~(length(user.pmuUnique) == 1)  || user.pmuUnique <= 0)
	user.pmuUnique = unique_pmu;
	warning('se:pmuUnique', ['The value pair argument of the '...
	'variable "pmuUnique" has invalid type. The algorithm ' ...
	'proceeds with default value: %1.e.\n'], unique_pmu)
 elseif user.varpmu == 1 && isempty(user.pmuUnique)
	user.pmuUnique = unique_pmu;
 end

 if user.varpmu == 2 && ~isempty(user.pmuRandom) && (~isvector(user.pmuRandom) || ~(length(user.pmuRandom) == 2)  || any(user.pmuRandom <= 0))
	user.pmuRandom = random_pmu;
	warning('se:pmuRandom', ['The value pair argument of the '...
	'variable "pmuRandom" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e].\n'], random_pmu(1), random_pmu(2))
 elseif user.varpmu == 2 && isempty(user.pmuRandom)
	user.pmuRandom = random_pmu;
 end

 if user.varpmu == 3 && ~isempty(user.pmuType)
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
 elseif user.varpmu == 3 && isempty(user.pmuType)
	user.pmuType = type_pmu;
 end
%--------------------------------------------------------------------------


%--------------------Check Legacy Measurement Variance---------------------
 if user.varleg == 1 && ~isempty(user.legUnique) && (~isvector(user.legUnique) || ~(length(user.legUnique) == 1)  || user.legUnique <= 0)
	user.legUnique = unique_leg;
	warning('se:pmuUnique', ['The value pair argument of the '...
	'variable "legUnique" has invalid type. The algorithm ' ...
	'proceeds with default value: %1.e.\n'], unique_leg)
 elseif user.varleg == 1 && isempty(user.legUnique)
	user.legUnique = unique_leg;
 end

 if user.varleg == 2 && ~isempty(user.legRandom) && (~isvector(user.legRandom) || ~(length(user.legUnique) == 2)  || any(user.legRandom <= 0))
	user.legRandom = random_leg;
	warning('se:pmuRandom', ['The value pair argument of the '...
	'variable "legRandom" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e].\n'], random_leg(1), random_leg(2))
 elseif user.varleg == 2 && isempty(user.legRandom)
	user.legRandom = random_leg;
 end

 if user.varleg == 3 && ~isempty(user.legType)
	dim = size(user.legType);
	if dim(1) == 1
	   user.legType = user.legType';
	end
	if ~isvector(user.legType) || ~(length(user.legType) == 6) || any(user.legType <= 0)
	   user.legType = type_leg;
	   warning('se:pmuType', ['The value pair argument of the '...
	'variable "legType" has invalid type. The algorithm proceeds ' ...
	'with default value: [%1.e %1.e %1.e %1.e %1.e %1.e].\n'], ...
	type_leg(1), type_leg(2), type_leg(3), type_leg(4), type_leg(5), type_leg(6))
	end
 elseif user.varleg == 3 && isempty(user.legType)
	user.legType = type_leg;
 end
%--------------------------------------------------------------------------