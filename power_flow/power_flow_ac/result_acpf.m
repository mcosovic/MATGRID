 function [re] = result_acpf(sys, pf)

%--------------------------------------------------------------------------
% Forms the result data for the AC power flow.
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
% Last revision by Mirsad Cosovic on 2019-04-14
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------Units Conversion, Method and Iterations------------------
 todeg = 180/pi;
 tomw  = sys.base;
 
 re.method    = pf.method;
 re.iteration = pf.iteration;
%--------------------------------------------------------------------------


%-------------------------------Bus Results--------------------------------
 re.bus = table(sys.bus(:,15), abs(pf.Vc), (angle(pf.Vc))*todeg, real(pf.Si)*tomw, imag(pf.Si)*tomw, real(pf.Sg)*tomw, imag(pf.Sg)*tomw, ...
		        real(pf.Sl)*tomw, imag(pf.Sl)*tomw, real(pf.Ssh)*tomw,  imag(pf.Ssh)*tomw, pf.limit(:,1), pf.limit(:,2));

 re.bus.Properties.VariableNames        = {'Bus' 'Vmag' 'Vang' 'Pinj' 'Qinj' 'Pgen' 'Qgen' 'Pload' 'Qload' 'Psh' 'Qsh' 'MinLim' 'MaxLim'};
 re.bus.Properties.VariableDescriptions = {'Bus Indexes' 'Bus Voltage Magnitudes' 'Bus Voltage Angles' 'Bus Active Power Injections' 'Bus Reactive Power Injections' 'Active Power of Generation Units' ...
                                           'Reactive Power of Generation Units' 'Active Power of Load Units' 'Reactive Power of Load Units' 'Active Power of Shunt Elements' 'Reactive Power of Shunt Elements' ...
                                           'Indicator where the Minimum Limits are Violated' 'Indicator where the Maximum Limits are Violated'};
 re.bus.Properties.VariableUnits        = {'' 'Per-unit (p.u.)' 'Degree (deg)' 'Megawatt (MW)' 'Megavolt-ampere reactive (MVAr)' 'Megawatt (MW)' 'Megavolt-ampere reactive (MVAr)' 'Megawatt (MW)' ...
                                           'Megavolt-ampere reactive (MVAr)' 'Megawatt (MW)' 'Megavolt-ampere reactive (MVAr)' '' ''};
%--------------------------------------------------------------------------


%-----------------------------Branch Results-------------------------------
 re.branch = table(sys.branch(:,9), sys.branch(:,10), real(pf.Sij)*tomw, imag(pf.Sij)*tomw, real(pf.Sji)*tomw, imag(pf.Sji)*tomw, (pf.Qis+pf.Qjs)*tomw, real(pf.Slos)*tomw, imag(pf.Slos)*tomw);

 re.branch.Properties.VariableNames        = {'From' 'To' 'Pfrom' 'Qfrom' 'Pto' 'Qto' 'Qinj' 'Ploss' 'Qloss'};
 re.branch.Properties.VariableDescriptions = {'From Bus Ends' 'To Bus Ends' 'Branch Active Power Flows at From Bus Ends' 'Branch Reactive Power Flows at From Bus Ends' 'Branch Active Power Flows at To Bus Ends' ...
                                              'Branch Reactive Power Flows at To Bus Ends' 'Reactive Power Injections from Branch Charging Susceptances' 'Active Power Losses at Branch Series Impedances' ...
                                              'Reactive Power Losses at Branch Series Impedances'};
 re.branch.Properties.VariableUnits        = {'' '' 'Megawatt (MW)' 'Megavolt-ampere reactive (MVAr)' 'Megawatt (MW)' 'Megavolt-ampere reactive (MVAr)' 'Megavolt-ampere reactive (MVAr)' 'Megawatt (MW)' ...
                                              'Megavolt-ampere reactive (MVAr)'};
%--------------------------------------------------------------------------


%------------------------------Time Results--------------------------------
 re.time = table(pf.time.pre, pf.time.con, toc);

 re.time.Properties.VariableNames        = {'Preprocess' 'Convergence', 'Postprocess'};
 re.time.Properties.VariableDescriptions = {'Preprocessing Time' 'Convergence Time' 'Postprocessing Time'};
 re.time.Properties.VariableUnits        = {'Second (s)' 'Second (s)' 'Second (s)'};
%--------------------------------------------------------------------------