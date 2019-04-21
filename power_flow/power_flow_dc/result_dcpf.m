 function [re] = result_dcpf(sys, pf)

%--------------------------------------------------------------------------
% Forms the result data for the DC power flow.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- pf.bus: bus table results
%	- pf.branch: branch table results
%	- pf.time: time table results
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-13
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Units Conversion and Method------------------------
 todeg = 180/pi;
 tomw  = sys.base;
 
 re.method = pf.method; 
%--------------------------------------------------------------------------


%-------------------------------Bus Results--------------------------------
 re.bus = table(sys.bus(:,15), pf.Va*todeg, pf.Pi*tomw, pf.Pg*tomw, sys.bus(:,5)*tomw, sys.bus(:,7)*tomw);

 re.bus.Properties.VariableNames        = {'Bus' 'Vang' 'Pinj' 'Pgen' 'Pload' 'Psh'};
 re.bus.Properties.VariableDescriptions = {'Bus Indexes' 'Bus Voltage Angles' 'Bus Active Power Injections' 'Active Power of Generation Units' 'Active Power of Load Units' 'Active Power of Shunt Elements'};
 re.bus.Properties.VariableUnits        = {'' 'Degree (deg)' 'Megawatt (MW)' 'Megawatt (MW)' 'Megawatt (MW)' 'Megawatt (MW)'};
%--------------------------------------------------------------------------


%-----------------------------Branch Results-------------------------------
 re.branch = table(sys.branch(:,9), sys.branch(:,10), pf.Pij*tomw);

 re.branch.Properties.VariableNames        = {'From' 'To' 'Pflow'};
 re.branch.Properties.VariableDescriptions = {'From Bus Ends' 'To Bus Ends' 'Branch Active Power Flows'};
 re.branch.Properties.VariableUnits{3}     = 'Megawatt (MW)';
%--------------------------------------------------------------------------


%------------------------------Time Results--------------------------------
 re.time = table(pf.time.pre, pf.time.con, toc);

 re.time.Properties.VariableNames        = {'Preprocess' 'Convergence', 'Postprocess'};
 re.time.Properties.VariableDescriptions = {'Preprocessing Time' 'Convergence Time' 'Postprocessing Time'};
 re.time.Properties.VariableUnits        = {'Second (s)' 'Second (s)' 'Second (s)'};
%--------------------------------------------------------------------------