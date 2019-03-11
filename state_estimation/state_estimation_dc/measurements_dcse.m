 function [data, sys, se] = measurements_dcse(data, sys)

%--------------------------------------------------------------------------
% Builds the measurement data for the DC state estimation, and forms the
% system model.
%
% The function defines measurement data according to available measurements
% (turn off measurements are removed), where the corresponding Jacobian
% matrix is defined, with associated vectors.
%
%  Inputs:
%	- data: input power system data with measurements
%	- sys: power system data
%
%  Outputs:
%	- data.legacy.flow with additional column:
%	  (11)indexes of branches that agree with sys.branch
%	- data.legacy.injection with additional column:
%	  (10)indexes of buses that agree with sys.bus
%	- data.pmu.voltage with additional column:
%	  (10)indexes of buses that agree with sys.bus
%	- se.estimate with columns:
%	  (1)measurement values; (2)measurement variances
%	- sys.b, sys.H: matrix and vector of the system model
%	- sys.Npij: number of power flow measurements
%	- sys.Npi: number of power injection measurements
%	- sys.Nti: number of voltage angle measurements
%	- sys.Nleg: number of legacy measurements
%	- sys.Npmu: number of phasor measurements
%	- sys.Ntot: total number of measurements
%	- sys.true_sv: exact values of state variables (if those exist)
%   - sys.exact: flag for exact values
%
% The local function which is used for the DC state estimation.
%--------------------------------------------------------------------------


%------------------Active Power Flow Legacy Measurements-------------------
 fix = logical(data.legacy.flow(:,5));

 data.legacy.flow(~fix,:) = [];
 data.legacy.flow = [data.legacy.flow sys.branch(fix,1)];

 sys.Npij = size(data.legacy.flow,1);

 o  = (1:sys.Npij)';
 c  = sys.branch(fix,11);
 Hf = sparse([o; o], [sys.branch(fix,2); sys.branch(fix,3)], [c; -c], sys.Npij, sys.Nbu);
% %--------------------------------------------------------------------------


%---------------Active Power Injection Legacy Measurements-----------------
 iix = logical(data.legacy.injection(:,4));

 data.legacy.injection(~iix,:) = [];
 data.legacy.injection = [data.legacy.injection sys.bus(iix,1)];

 sys.Npi = size(data.legacy.injection,1);

 Hi = sys.Ybu(data.legacy.injection(:,10),:);
%--------------------------------------------------------------------------


%---------------------Voltage Angle PMU Measurements-----------------------
 try
  sys.true_sv = data.pmu.voltage(:,9);
  sys.exact = 1;
 catch
  sys.exact = 0;
 end

 data.pmu.voltage(sys.sck(1),4) = 0;

 vix = logical(data.pmu.voltage(:,4));

 data.pmu.voltage(~vix,:) = [];
 data.pmu.voltage = [data.pmu.voltage sys.bus(vix,1)];

 sys.Nti = size(data.pmu.voltage,1);

 Hv = sparse((1:sys.Nti)', data.pmu.voltage(:,10), 1, sys.Nti, sys.Nbu);
%--------------------------------------------------------------------------


%------------------------------System Model--------------------------------
 se.estimate = [data.legacy.flow(:,3); data.legacy.injection(:,2); data.pmu.voltage(:,5)];
 se.estimate(:,2) = [data.legacy.flow(:,4); data.legacy.injection(:,3); data.pmu.voltage(:,6)];

 sys.b = se.estimate(:,1) - [sys.branch(fix,8); sys.bus(iix,16); sys.sck(2) * ones(sys.Nti,1);];
 sys.H = [Hf; Hi; Hv];
%--------------------------------------------------------------------------


%-------------------------Number of Measurements---------------------------
 sys.Nleg = sys.Npij + sys.Npi;
 sys.Npmu = sys.Nti;
 sys.Ntot = sys.Nleg + sys.Npmu;
%--------------------------------------------------------------------------