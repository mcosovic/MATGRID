 function [re, se] = result_acse(user, sys, se)

%--------------------------------------------------------------------------
% Forms the DC state estimation result data in tables.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- se: DC state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- re.bus: results related with buses
%	- se.branch: results related with branches
%	- re.estimate: estimation results
%	- re.error: error results
%	- re.time: time results
%	- re.bad: bad data results
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-17
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------------Units Conversion------------------------------
 todeg = 180/pi;
 tomw  = sys.base;
%--------------------------------------------------------------------------


%-------------------------------Bus Results--------------------------------
 re.method = se.method;
 re.iteration = se.iteration;
 
 re.bus = table(sys.bus(:,15), abs(se.Vc), (angle(se.Vc))*todeg, real(se.Si)*tomw, imag(se.Si)*tomw, ...
                 real(se.Ssh)*tomw,  imag(se.Ssh)*tomw);

 re.bus.Properties.VariableNames = {'Bus' 'Vmag' 'Vang' 'Pinj' 'Qinj' 'Psh' 'Qsh'};
 
 re.bus.Properties.VariableDescriptions{1} = 'Bus Indexes';

 re.bus.Properties.VariableUnits{2} = 'Per-unit (p.u.)';
 re.bus.Properties.VariableDescriptions{2} = 'Estimated Bus Voltage Magnitudes';

 re.bus.Properties.VariableUnits{3} = 'Degree (deg)';
 re.bus.Properties.VariableDescriptions{3} = 'Estimated Bus Voltage Angles';

 re.bus.Properties.VariableUnits{4} = 'Megawatt (MW)';
 re.bus.Properties.VariableDescriptions{4} = 'Bus Active Power Injections';

 re.bus.Properties.VariableUnits{5} = 'Megavolt-ampere reactive (MVAr)';
 re.bus.Properties.VariableDescriptions{5} = 'Bus Reactive Power Injections';

 re.bus.Properties.VariableUnits{6} = 'Megawatt (MW)';
 re.bus.Properties.VariableDescriptions{6} = 'Active Power of Shunt Elements';

 re.bus.Properties.VariableUnits{7} = 'Megavolt-ampere reactive (MVAr)';
 re.bus.Properties.VariableDescriptions{7} = 'Reactive Power of Shunt Elements';
%--------------------------------------------------------------------------


%-----------------------------Branch Results-------------------------------
 re.branch = table(sys.branch(:,9), sys.branch(:,10), real(se.Sij)*tomw, imag(se.Sij)*tomw, ...
			 real(se.Sji)*tomw, imag(se.Sji)*tomw,  ...
			 (se.Qbi + se.Qbj)*tomw, real(se.Slos)*tomw, imag(se.Slos)*tomw);

 re.branch.Properties.VariableNames = {'From' 'To' 'Pfrom' 'Qfrom' 'Pto' 'Qto' 'Qinj' 'Ploss' 'Qloss'};

 re.branch.Properties.VariableDescriptions{1} = 'From Bus Ends';
 re.branch.Properties.VariableDescriptions{2} = 'To Bus Ends';

 re.branch.Properties.VariableUnits{3} = 'Megawatt (MW)';
 re.branch.Properties.VariableDescriptions{3} = 'Branch Active Power Flows at From Bus Ends';

 re.branch.Properties.VariableUnits{4} = 'Megavolt-ampere reactive (MVAr)';
 re.branch.Properties.VariableDescriptions{4} = 'Branch Reactive Power Flows at From Bus Ends';

 re.branch.Properties.VariableUnits{5} = 'Megawatt (MW)';
 re.branch.Properties.VariableDescriptions{5} = 'Branch Active Power Flows at To Bus Ends';

 re.branch.Properties.VariableUnits{6} = 'Megavolt-ampere reactive (MVAr)';
 re.branch.Properties.VariableDescriptions{6} = 'Branch Reactive Power Flows at To Bus Ends';

 re.branch.Properties.VariableUnits{7} = 'Megavolt-ampere reactive (MVAr)';
 re.branch.Properties.VariableDescriptions{7} = 'Reactive Power Injections from Branch Charging Susceptances';

 re.branch.Properties.VariableUnits{8} = 'Megawatt (MW)';
 re.branch.Properties.VariableDescriptions{8} = 'Active Power Losses at Branch Series Impedances';

 re.branch.Properties.VariableUnits{9} = 'Megavolt-ampere reactive (MVAr)';
 re.branch.Properties.VariableDescriptions{9} = 'Reactive Power Losses at Branch Series Impedances';
%--------------------------------------------------------------------------


 
%----------------------------Estimate Results------------------------------
 se.estimate = se.estimate .* se.estimate(:,4);
 Resudial = abs(se.estimate(:,3) - se.estimate(:,1));
 Device  = se.device(:,1);
 Unit   = se.device(:,2);

 re.estimate = [table(Device, Unit) array2table([se.estimate(:,1:3) Resudial])];

 re.estimate.Properties.VariableDescriptions{1} = 'Type of Measurement Devices';
 re.estimate.Properties.VariableDescriptions{2} = 'Measurement Units';

 re.estimate.Properties.VariableNames{1} = 'Device';
 re.estimate.Properties.VariableNames{2} = 'Unit';

 re.estimate.Properties.VariableNames{3} = 'Mean';
 re.estimate.Properties.VariableDescriptions{3} = 'Measurement Values';

 re.estimate.Properties.VariableNames{4} = 'Variance';
 re.estimate.Properties.VariableDescriptions{4} = 'Measurement Variances';

 re.estimate.Properties.VariableNames{5} = 'Estimate';
 re.estimate.Properties.VariableDescriptions{5} = 'Estimated Values';

 re.estimate.Properties.VariableNames{6} = 'Residual';
 re.estimate.Properties.VariableDescriptions{6} = 'Residual between estimated and measurement values';

 if se.exact 
    Resudial2 = abs(se.estimate(:,3) - se.estimate(:,5));
    Exact = se.estimate(:,5);
    
    re.estimate = [re.estimate, array2table([Exact Resudial2])];
    re.estimate.Properties.VariableNames{7} = 'Exact';
	re.estimate.Properties.VariableDescriptions{7} = 'Exact Values';

	re.estimate.Properties.VariableNames{8} = 'Residual2';
	re.estimate.Properties.VariableDescriptions{8} = 'Residual between estimated and exact values';
 end
 
 se.Nleg = sys.Nleg;
 se.Npmu = sys.Npmu;
%--------------------------------------------------------------------------


%------------------------------Error Results-------------------------------
 re.error = array2table(se.error);

 re.error.Properties.VariableNames{1} = 'EstimateMean';
 re.error.Properties.RowNames = {'MAE' 'RMSE' 'WRSS'};
 re.error.Properties.VariableDescriptions{1} = 'mean absolute, root mean square and weighted residual sum of squares errors between estimated and measurement values';

 if se.exact
	re.error.Properties.VariableNames{2} = 'EstimateExact';
	re.error.Properties.VariableDescriptions{2} = 'mean absolute, root mean square and weighted residual sum of squares errors between estimated and exact values';

	re.error.Properties.VariableNames{3} = 'EstimateExactState';
	re.error.Properties.VariableDescriptions{3} = 'mean absolute and root mean square errors between estimated state variables and exact values';
 end
%--------------------------------------------------------------------------


%------------------------------Time Results--------------------------------
 re.time = table(se.time.pre, se.time.con, toc);

 re.time.Properties.VariableNames = {'Preprocess' 'Convergence', 'Postprocess'};

 re.time.Properties.VariableUnits{1} = 'Second (s)';
 re.time.Properties.VariableDescriptions{1} = 'Preprocessing Time';

 re.time.Properties.VariableUnits{2} = 'Second (s)';
 re.time.Properties.VariableDescriptions{2} = 'Convergence Time';

 re.time.Properties.VariableUnits{3} = 'Second (s)';
 re.time.Properties.VariableDescriptions{3} = 'Postprocessing Time';
%--------------------------------------------------------------------------