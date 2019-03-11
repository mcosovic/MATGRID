 function [user] = measurement_variance(user)

%--------------------------------------------------------------------------
% Checks input measurement variances.
%
% The function checks legvariance and pmuvariance, wherein the expected
% inputs are 'unique', 'random' and 'type'. If variables are missing or are
% not properly defined, we add default values, which allows to execute a
% code without errors.
%
%  Input:
%	- user: user inputs
%
%  Output:
%	- user.unique_legvariance: unique variance for legacy measurements
%	- user.unique_pmuvariance: unique variance for phasor measurements
%	- user.random_legvariance: random variances for legacy measurements
%	- user.random_pmuvariance: random variances for phasor measurements
%	- user.type_legvariance: variances per type for legacy measurements
%	- user.type_legvariance: variances per type for phasor measurements
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%----------------------------Default Variances-----------------------------
 unique_leg = 10^-8;
 random_leg = [10^-8; 10^-6];
 type_leg   = [10^-6; 10^-8; 10^-8; 10^-8; 10^-6; 10^-6];

 unique_pmu = 10^-12;
 random_pmu = [10^-12; 10^-10];
 type_pmu   = [10^-12; 10^-10; 10^-12; 10^-10];
%--------------------------------------------------------------------------


%-------------------------Check Legacy Variances---------------------------
 vari = isfield(user, {'unique_legvariance', 'random_legvariance', 'type_legvariance'});

 if all(~vari)
    user.unique_legvariance = unique_leg;
    warning('Variance:LegAllowed', ['The variable "legvariance" requires at least one input argument: ' ...
            '\n\t"legvariance.unique" - unique variance applied over all legacy measurements'...
            '\n\t"legvariance.random" - randomize variances within limits [min max] applied over all legacy measurements'...
            '\n\t"legvariance.type" - variances applied over subset of legacy measurements [active flow], [reactive flow], [current magnitude], [active injection], [reactive injection], [voltage magnitude]'...
            '\nThe algorithm proceeds with unique variance: %1.e'], unique_leg)
 end

 if vari(1) && (~isvector(user.unique_legvariance) || ~(length(user.unique_legvariance) == 1) || any(user.unique_legvariance <= 0))
    user.unique_legvariance = unique_leg;
    warning('Variance:LegUnique', 'The variable expression "legvariance.unique" has invalid type. The algorithm proceeds with default value: %1.e.\n', unique_leg)
 end
 if vari(2) && (~isvector(user.random_legvariance) || ~(length(user.random_legvariance) == 2) || any(user.random_legvariance <= 0))
    user.random_legvariance = random_leg;
    warning('Variance:LegUnique', 'The variable expression "legvariance.unique" has invalid type. The algorithm proceeds with default value: [%1.e %1.e].\n', random_leg(1), random_leg(2))
 end
 if vari(3)
    dim = size(user.type_legvariance);
    if dim(1) == 1
       user.type_legvariance = user.type_legvariance';
    end
    if ~isvector(user.type_legvariance) || ~(length(user.type_legvariance) == 6) || any(user.type_legvariance <= 0)
       user.type_legvariance = type_leg;
       warning('Variance:LegTypeAC', 'The variable expression "legvariance.type" has invalid type. The algorithm proceeds with default value: [%1.e %1.e %1.e %1.e %1.e %1.e].\n', type_leg(1), type_leg(2), type_leg(3), type_leg(4), type_leg(5), type_leg(6))
    end
 end
%--------------------------------------------------------------------------


%---------------------------Check PMU Variances----------------------------
 vari = isfield(user, {'unique_pmuvariance', 'random_pmuvariance', 'type_pmuvariance'});

 if all(~vari)
    user.unique_pmuvariance = unique_pmu;
    warning('Variance:PmuAllowed', ['The variable "pmuvariance" requires at least one input argument: ' ...
            '\n\t"pmuvariance.unique" - unique variance applied over all measurements from PMUs '...
            '\n\t"pmuvariance.random" - randomize variances within limits [min max] applied over measurements from PMUs '...
            '\n\t"pmuvariance.type" - variances applied over subset of measurements from PMUs [current magnitude], [current angle], [voltage magnitude], [voltage angle]'...
            '\nThe algorithm proceeds with unique variance: %1.e'], unique_pmu)
 end

 if vari(1) && (~isvector(user.unique_pmuvariance) || ~(length(user.unique_pmuvariance) == 1) || any(user.unique_pmuvariance <= 0))
    user.unique_pmuvariance = unique_pmu;
    warning('Variance:PmuUnique', 'The variable expression "pmuvariance.unique" has invalid type. The algorithm proceeds with default value: %1.e.\n', unique_pmu)
 end
 if vari(2) && (~isvector(user.random_pmuvariance) || ~(length(user.random_pmuvariance) == 2) || any(user.random_pmuvariance <= 0))
    user.random_pmuvariance = random_pmu;
    warning('Variance:PmuUnique', 'The variable expression "pmuvariance.unique" has invalid type. The algorithm proceeds with default value: [%1.e %1.e].\n', random_pmu(1), random_pmu(2))
 end
 if vari(3)
    dim = size(user.type_pmuvariance);
    if dim(1) == 1
       user.type_pmuvariance = user.type_pmuvariance';
    end
    if ~isvector(user.type_pmuvariance) || ~(length(user.type_pmuvariance) == 4) || any(user.type_pmuvariance <= 0)
       user.type_pmuvariance = type_pmu;
       warning('Variance:PmuTypeAC', 'The variable expression "pmuvariance.type" has invalid type. The algorithm proceeds with default value: [%1.e %1.e %1.e %1.e].\n', type_pmu(1), type_pmu(2), type_pmu(3), type_pmu(4))
    end
 end
%--------------------------------------------------------------------------