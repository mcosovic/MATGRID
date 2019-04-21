 function [se] = processing_dcse(data, se, af, ai, va)

%--------------------------------------------------------------------------
% Computes the DC power flow (active power flows and injections) after DC
% state estimation.
%
% The active power flow for the DC problem is defined as Pij = 1/(tij*xij)
% * (Ti - Tj - fij), and holds Pij = -Pji. Also, the active power injection
% is given as Pi = Ybus*T + Psh + rsh. In general, according to the
% convention, a negative power value indicates the power flow direction in
% a bus, while a positive power value means direction out a bus. Also, the
% function forms estimation data.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input data
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- se.Pi:active power injection
%	- se.Pij: active power flow
%	- se.exact: flag indicator for exact values
%	- se.Nleg: number of legacy measurements
%	- se.Npmu: number of phasor measurements
%	- se.estimate with columns:
%	  (1)measurement values; (2) measurement variances;
%	  (3)estimated measurement values; (4)residual between between
%	  estimated and measurement values; (5)exact values;
%	  (6)residual between estimated and exact values
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Measurement Numbers----------------------------
 se.Nleg = af.n + ai.n;
 se.Npmu = va.n;
%--------------------------------------------------------------------------


%----------------------Active Power Flow at Branches-----------------------
 i = se.branch(:,2);
 j = se.branch(:,3);

 se.Pij = se.branch(:,11) .* (se.Va(i) - se.Va(j) - se.branch(:,8));
%--------------------------------------------------------------------------


%------------------Injection Active Power with Slack Bus-------------------
 se.Pi = se.Ybu * se.Va + se.bus(:,16) + se.bus(:,7);
%--------------------------------------------------------------------------


%--------------------Estimation Data for Measurements----------------------
 Pij = [se.Pij; -se.Pij];

 se.estimate(:,1) = [af.z; ai.z; va.z];
 se.estimate(:,2) = [af.v; ai.v; va.v];
 se.estimate(:,3) = [Pij(af.on); se.Pi(ai.on); se.Va(va.on)];
 se.estimate(:,4) = abs(se.estimate(:,3) - se.estimate(:,1));

 try
	flo = data.legacy.flow(af.on,9);
	inj = data.legacy.injection(ai.on,8);
	ang = data.pmu.voltage(va.on,9);

	se.estimate(:,5) = [flo; inj; ang];
	se.estimate(:,6) = abs(se.estimate(:,3) - se.estimate(:,5));

	se.exact = 1;
 catch
	se.exact = 0;
 end
%--------------------------------------------------------------------------