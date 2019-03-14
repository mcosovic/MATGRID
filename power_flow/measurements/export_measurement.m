 function [data] = export_measurement(data, user, sys, msr, pf)

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


%-----------------------------Initialization-------------------------------
 rng('shuffle');
%--------------------------------------------------------------------------


%-------------------------------Mean Values--------------------------------
 Aflo_mean = real([pf.branch(:,5); pf.branch(:,6)]);
 Rflo_mean = imag([pf.branch(:,5); pf.branch(:,6)]);
 Cmag_mean = abs([pf.branch(:,1); pf.branch(:,2)]);
 Cang_mean = angle([pf.branch(:,1); pf.branch(:,2)]);

 Ainj_mean = real(pf.bus(:,4));
 Rinj_mean = imag(pf.bus(:,4));
 Vmag_mean = abs(pf.bus(:,3));
 Vang_mean = angle(pf.bus(:,3));
%--------------------------------------------------------------------------


%--------------------------Gaussian White Noise----------------------------
 Aflo_gwn = randn(2*msr.w,1);
 Rflo_gwn = randn(2*msr.w,1);
 Cmag_gwn = randn(2*msr.w,1);
 Cang_gwn = randn(2*msr.w,1);
 Ainj_gwn = randn(sys.Nbu,1);
 Rinj_gwn = randn(sys.Nbu,1);
 Vmag_gwn = randn(sys.Nbu,1);
 Vang_gwn = randn(sys.Nbu,1);
%--------------------------------------------------------------------------


%--------------------------------Variances---------------------------------
 Aflo_ana_var = msr.var{1}(1:2*msr.w);
 Rflo_ana_var = msr.var{1}(2*msr.w+1:4*msr.w);
 Cmag_ana_var = msr.var{1}(4*msr.w+1:6*msr.w);
 Ainj_ana_var = msr.var{1}(6*msr.w+1:6*msr.w+sys.Nbu);
 Rinj_ana_var = msr.var{1}(6*msr.w+sys.Nbu+1:6*msr.w+2*sys.Nbu);
 Vmag_ana_var = msr.var{1}(6*msr.w+2*sys.Nbu+1:end);

 Cmag_pmu_var = msr.var{2}(1:2*msr.w);
 Cang_pmu_var = msr.var{2}(2*msr.w+1:4*msr.w);
 Vmag_pmu_var = msr.var{2}(4*msr.w+1:4*msr.w+sys.Nbu);
 Vang_pmu_var = msr.var{2}(4*msr.w+sys.Nbu+1:end);
%--------------------------------------------------------------------------


%---------------------------Measurement Values-----------------------------
 Aflo_ana_mv = Aflo_mean + Aflo_ana_var.^(1/2) .* Aflo_gwn;
 Rflo_ana_mv = Rflo_mean + Rflo_ana_var.^(1/2) .* Rflo_gwn;
 Cmag_ana_mv = Cmag_mean + Cmag_ana_var.^(1/2) .* Cmag_gwn;
 Ainj_ana_mv = Ainj_mean + Ainj_ana_var.^(1/2) .* Ainj_gwn;
 Rinj_ana_mv = Rinj_mean + Rinj_ana_var.^(1/2) .* Rinj_gwn;
 Vmag_ana_mv = Vmag_mean + Vmag_ana_var.^(1/2) .* Vmag_gwn;

 Cmag_pmu_mv = Cmag_mean + Cmag_pmu_var.^(1/2) .* Cmag_gwn;
 Cang_pmu_mv = Cang_mean + Cang_pmu_var.^(1/2) .* Cang_gwn;
 Vmag_pmu_mv = Vmag_mean + Vmag_pmu_var.^(1/2) .* Vmag_gwn;
 Vang_pmu_mv = Vang_mean + Vang_pmu_var.^(1/2) .* Vang_gwn;
%--------------------------------------------------------------------------


%-------------------------Measurement Turn on/off--------------------------
 Aflo_ana_set = msr.set{1}(1:2*msr.w);
 Rflo_ana_set = msr.set{1}(2*msr.w+1:4*msr.w);
 Cmag_ana_set = msr.set{1}(4*msr.w+1:6*msr.w);
 Ainj_ana_set = msr.set{1}(6*msr.w+1:6*msr.w+sys.Nbu);
 Rinj_ana_set = msr.set{1}(6*msr.w+sys.Nbu+1:6*msr.w+2*sys.Nbu);
 Vmag_ana_set = msr.set{1}(6*msr.w+2*sys.Nbu+1:end);

 Cmag_pmu_set = msr.set{2}(1:2*msr.w);
 Cang_pmu_set = msr.set{2}(2*msr.w+1:4*msr.w);
 Vmag_pmu_set = msr.set{2}(4*msr.w+1:4*msr.w+sys.Nbu);
 Vang_pmu_set = msr.set{2}(4*msr.w+sys.Nbu+1:end);
%--------------------------------------------------------------------------


%----------------------Export Measurement Info Data------------------------
 [data] = export_info(data, user, pf, msr, Aflo_ana_var, Rflo_ana_var, ...
                      Cmag_ana_var, Ainj_ana_var, Rinj_ana_var, ...
                      Vmag_ana_var, Cmag_pmu_var, Cang_pmu_var, ...
                      Vmag_pmu_var, Vang_pmu_var, Aflo_ana_set, ...
                      Rflo_ana_set, Cmag_ana_set, Ainj_ana_set, ...
                      Rinj_ana_set, Vmag_ana_set, Cmag_pmu_set, ...
                      Cang_pmu_set, Vmag_pmu_set, Vang_pmu_set);
%--------------------------------------------------------------------------


%--------------------Collect Data and Define Structure---------------------
 bra = [sys.branch(:,9:10); sys.branch(:,10) sys.branch(:,9)];
 bus = sys.bus(:,15);

 data.legacy.flow = [bra Aflo_ana_mv Aflo_ana_var Aflo_ana_set ...
					Rflo_ana_mv Rflo_ana_var Rflo_ana_set ...
					Aflo_mean Rflo_mean];

 data.legacy.current = [bra Cmag_ana_mv Cmag_ana_var Cmag_ana_set Cmag_mean];

 data.legacy.injection = [bus Ainj_ana_mv Ainj_ana_var Ainj_ana_set ...
						 Rinj_ana_mv Rinj_ana_var Rinj_ana_set ...
						 Ainj_mean Rinj_mean];

 data.legacy.voltage = [bus Vmag_ana_mv Vmag_ana_var Vmag_ana_set Vmag_mean];

 data.pmu.current = [bra Cmag_pmu_mv Cmag_pmu_var Cmag_pmu_set ...
					Cang_pmu_mv Cang_pmu_var Cang_pmu_set ...
					Cmag_mean Cang_mean];

 data.pmu.voltage = [bus Vmag_pmu_mv Vmag_pmu_var Vmag_pmu_set ...
					Vang_pmu_mv Vang_pmu_var Vang_pmu_set ...
					Vmag_mean Vang_mean];
%--------------------------------------------------------------------------