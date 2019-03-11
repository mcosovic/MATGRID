 function [data] = run_measurement_generator(user, data, sys, pf)

%--------------------------------------------------------------------------
% Builds measurement data.

% The function corrupts the exact solutions from power flow analysis by the
% additive white Gaussian noises according to defined variances. Variances
% are defined as struct variables 'legvariance' for legacy measurements and
% 'pmuvariance' for phasor measurements, with three different options:
% 'unique', random' and 'type'.
%
% Option unique, e.g:
%    legvariance.unique = 10^-3;
%    pmuvariance.unique = 10^-6;
% Option 'unique' applied unique variance over all legacy or phasor
% measurements.
%
% Option random, e.g:
%    legvariance.random = [10^-4 10^-3;
%    pmuvariance.random = [10^-5 10^-6];
% Option 'random' randomized variances within limits [min max] applied over
% all legacy or phasor measurements. Note that for phasor measurements,
% option is applied over all possible measurements from PMUs (Iij, Dij, Vi,
% Ti) independently.
%
% Option type, e.g:
%    legvariance.type = [10^-3 10^-2 10^-2 10^-1 10^-2 10^-3];
%    pmuvariance.type = [10^-5 10^-4 10^-5 10^-4];
% Option 'type' enables defining variances over the subset of legacy
% measurements (Pij, Qij, Iij, Pi, Qi, Vi), or subset of measurements from
% PMUs (Iij, Dij, Vi, Ti).
%
% Further, the function forms measurement set according to predefined
% inputs. Sets are defined as struct variables 'legset' for legacy
% measurements and 'pmuset' for phasor measurements, with two options:
% 'redundancy' and 'device', and one additional option for PMUs: 'optimal'.
%
% Option redundancy, e.g:
%    legset.redundancy = 2.5;
%    pmuset.redundancy = 1.8;
% Option 'redundancy' randomize legacy measurements according to
% redundancy, as well as phasor measurements. Note that for phasor
% measurements, option is applied over all possible measurements from PMUs
% (Iij, Dij, Vi, Ti) independently.

% Option type, e.g:
%    legset.device = [10 14 5 5];
%    legset.device = 5;
% Option 'device' enables defining sets over the subset of legacy
% measurements [(Pij,Qij), (Iij), (Pi,Qi), (Vi)], or enables phasor
% measurements according to number of measurement devices placed on buses
% and automatically turns on all measurements that corresponding with PMU
% at that bus.
%
% Option optimal, e.g:
%    pmuset.optimal = 1;
% Option finds optimal PMU location to make the entire system completely
% observable only by phasor measurements.

%  Inputs:
%	- user: user inputs
%	- data: input power system data
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- data: with additional struct variables:
%	  - data.legacy.flow: power flow measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)active power flow measurements;
%		(4)active power flow measurement variances;
%		(5)active power flow measurements turn on/off;
%		(6)reactive power flow measurements;
%		(7)reactive power flow measurement variances;
%		(8)reactive power flow measurement turn on/off;
%		(9)active power flow exact value;
%		(10)reactive power flow exact value;
%	  - data.legacy.current: line current magnitude measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurement turn on/off;
%		(6)line current magnitude exact value;
%	  - data.legacy.injection: power injection measurements with columns:
%		(1)bus indexes; (2)active power injection measurements;
%		(3)active power injection measurement variances;
%		(4)active power injection measurements turn on/off;
%		(5)reactive power injection measurements;
%		(6)reactive power injection measurement variances;
%		(7)reactive power injection measurements turn on/off;
%		(9)active power injection exact value;
%		(10)reactive power injection exact value;
%	  - data.legacy.voltage: bus voltage magnitude measurements with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage magnitude exact value;
%	  - data.pmu.current: phasor current measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurements turn on/off;
%		(6)line current angle measurements;
%		(7)line current angle measurement variances;
%		(8)line current angle measurements turn on/off;
%		(9)line current magnitude exact value;
%		(10)line current angle exact value;
%	  - data.pmu.voltage: phasor voltage measurements with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage angle measurements;
%		(6)bus voltage angle measurement variances;
%		(7)bus voltage angle measurements turn on/off;
%		(8)bus voltage magnitude exact value;
%		(9)bus voltage angle exact value;
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%--------------------------Measurement Generator---------------------------
 [msr]  = variable_device(sys);
 [user] = measurement_variance(user);
 [msr]  = variance_produce(user, msr);
 [user] = measurement_set(user, msr);
 [msr]  = set_produce(user, msr, sys);
 [data] = export_measurement(data, user, sys, msr, pf);
%--------------------------------------------------------------------------