 function [data] = export_measurement(data, user, sys, msr, pf)

%--------------------------------------------------------------------------
% Builds measurement data.
%
% The function produces measurement data according to user inputs and
% options. The function corrupts the exact solutions from power flow
% analysis by the additive white Gaussian noises according to defined
% variances. Further, the function forms measurement set according to
% predefined inputs.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data
%	- sys: power system data
%	- msr: measurement data
%	- pf: power flow data

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
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-24
% Last revision by Mirsad Cosovic on 2019-03-28
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------
 rng('shuffle');
%--------------------------------------------------------------------------


%-------------------------------Mean Values--------------------------------
 Aflo_mean = real([pf.branch(:,5); pf.branch(:,6)]);
 Rflo_mean = imag([pf.branch(:,5); pf.branch(:,6)]);
 Cmag_mean = abs([pf.branch(:,1); pf.branch(:,2)]);
 Cang_mean = angle([pf.branch(:,1); pf.branch(:,2)]);

 Ainj_mean = real(pf.bus(:,2));
 Rinj_mean = imag(pf.bus(:,2));
 Vmag_mean = abs(pf.bus(:,1));
 Vang_mean = angle(pf.bus(:,1));
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
 Afv = msr.var{1}(1:2*msr.w);
 Rfv = msr.var{1}(2*msr.w+1:4*msr.w);
 Cmv = msr.var{1}(4*msr.w+1:6*msr.w);
 Aiv = msr.var{1}(6*msr.w+1:6*msr.w+sys.Nbu);
 Riv = msr.var{1}(6*msr.w+sys.Nbu+1:6*msr.w+2*sys.Nbu);
 Vmv = msr.var{1}(6*msr.w+2*sys.Nbu+1:end);

 Cpmv = msr.var{2}(1:2*msr.w);
 Cpav = msr.var{2}(2*msr.w+1:4*msr.w);
 Vpmv = msr.var{2}(4*msr.w+1:4*msr.w+sys.Nbu);
 Vpav = msr.var{2}(4*msr.w+sys.Nbu+1:end);
%--------------------------------------------------------------------------


%---------------------------Measurement Values-----------------------------
 Af = Aflo_mean + Afv.^(1/2) .* Aflo_gwn;
 Rf = Rflo_mean + Rfv.^(1/2) .* Rflo_gwn;
 Cm = Cmag_mean + Cmv.^(1/2) .* Cmag_gwn;
 Ai = Ainj_mean + Aiv.^(1/2) .* Ainj_gwn;
 Ri = Rinj_mean + Riv.^(1/2) .* Rinj_gwn;
 Vm = Vmag_mean + Vmv.^(1/2) .* Vmag_gwn;

 Cpm = Cmag_mean + Cpmv.^(1/2) .* Cmag_gwn;
 Cpa = Cang_mean + Cpav.^(1/2) .* Cang_gwn;
 Vpm = Vmag_mean + Vpmv.^(1/2) .* Vmag_gwn;
 Vpa = Vang_mean + Vpav.^(1/2) .* Vang_gwn;
%--------------------------------------------------------------------------


%--------------------Collect Data and Define Structure---------------------
 br = [sys.branch(:,9:10); sys.branch(:,10) sys.branch(:,9)];
 bs = sys.bus(:,15);

 z1 = zeros(2*sys.Nbr,1);
 z2 = zeros(sys.Nbu,1);

 data.legacy.flow      = [br Af Afv z1 Rf Rfv z1 Aflo_mean Rflo_mean];
 data.legacy.current   = [br Cm Cmv z1 Cmag_mean];
 data.legacy.injection = [bs Ai Aiv z2 Ri Riv z2 Ainj_mean Rinj_mean];
 data.legacy.voltage   = [bs Vm Vmv z2 Vmag_mean];
 data.pmu.current      = [br Cpm Cpmv z1 Cpa Cpav z1 Cmag_mean Cang_mean];
 data.pmu.voltage      = [bs Vpm Vpmv z2 Vpa Vpav z2 Vmag_mean Vang_mean];

 [data] = play_set(user, data, sys, msr);
%--------------------------------------------------------------------------