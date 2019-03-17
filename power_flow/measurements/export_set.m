 function [data] = export_set(user, data, sys, msr)

%--------------------------------------------------------------------------
% Builds measurement data.
%
% The function produces measurement data according to user inputs and
% options. The function corrupts the exact solutions from power flow
% analysis by the additive white Gaussian noises according to defined
% variances. Further, the function forms measurement set according to
% predefined inputs.
%
%  Input:
%	- data: input power system data
%	- sys: power system data
%	- msr: measurement data
%	- pf: power flow data
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


%-------------------------Legacy Measurement Set---------------------------
 if user.setleg ~= 0
    Aflo_ana_set = msr.set{1}(1:2*msr.w);
    Rflo_ana_set = msr.set{1}(2*msr.w+1:4*msr.w);
    Cmag_ana_set = msr.set{1}(4*msr.w+1:6*msr.w);
    Ainj_ana_set = msr.set{1}(6*msr.w+1:6*msr.w+sys.Nbu);
    Rinj_ana_set = msr.set{1}(6*msr.w+sys.Nbu+1:6*msr.w+2*sys.Nbu);
    Vmag_ana_set = msr.set{1}(6*msr.w+2*sys.Nbu+1:end); 
     
    data.legacy.flow(:,5) = Aflo_ana_set;
    data.legacy.flow(:,8) = Rflo_ana_set;
    
    data.legacy.current(:,5) = Cmag_ana_set;
    
    data.legacy.injection(:,4) = Ainj_ana_set;
    data.legacy.injection(:,7) = Rinj_ana_set;
    
    data.legacy.voltage(:,4) = Vmag_ana_set;
 end
%--------------------------------------------------------------------------


%-------------------------Phasor Measurement Set---------------------------
 if user.setpmu ~= 0
    Cmag_pmu_set = msr.set{2}(1:2*msr.w);
    Cang_pmu_set = msr.set{2}(2*msr.w+1:4*msr.w);
    Vmag_pmu_set = msr.set{2}(4*msr.w+1:4*msr.w+sys.Nbu);
    Vang_pmu_set = msr.set{2}(4*msr.w+sys.Nbu+1:end);
 
    data.pmu.current(:,5) = Cmag_pmu_set;
    data.pmu.current(:,8) = Cang_pmu_set;

    data.pmu.voltage(:,4) = Vmag_pmu_set;
    data.pmu.voltage(:,7) = Vang_pmu_set;
 end
%--------------------------------------------------------------------------