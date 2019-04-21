 function [pf] = processing_acpf(sys, pf)

%--------------------------------------------------------------------------
% Computes the AC power flow, as well as currents and losses.
%
% The function computes the apparent power injection into bus, the active
% and reactive power generation, the line current at branch, the line
% current after branch shunt susceptance, the apparent power at branch, the
% apparent power after branch shunt susceptance, the reactive power
% injection from branch shunt susceptances, active and reactive power
% losses at branch, the apparent power at shunt elements. Finally, the
% postprocessing time is obtained here.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- pf.Si: apparent power injection
%	- pf.Sg: generation apparent power
%   - pf.Sl: load apparent power
%   - pf.Ssh: apparent power at shunt elements(Ssh)
%   - pf.Iij: line current at branch - from bus
%   - pf.Iji: line current at branch - to bus
%   - pf.Iijb: line current after branch shunt susceptance - from bus
%   - pf.Ijib: line current after branch shunt susceptance - to bus
%   - pf.Sij: apparent power at branch - from bus
%   - pf.Sji: apparent power at branch - to bus
%   - pf.Sijb: apparent power after branch shunt susceptance - from bus
%   - pf.Sjib: apparent power after branch shunt susceptance - from bus
%   - pf.Qis: reactive power injection from shunt susceptances - from bus
%   - pf.Qjs: reactive power injection from shunt susceptances - to bus
%   - pf.Slos: apparent power of losses
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-04-21
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------------Voltage Data--------------------------------
 Vi = pf.Vc(sys.branch(:,2));
 Vj = pf.Vc(sys.branch(:,3));
 Vp = Vi ./ sys.branch(:,13);
%--------------------------------------------------------------------------


%----------------------Injection Bus Apparent Power------------------------
 pf.Si = (conj(sys.Ybu) * conj(pf.Vc)) .* pf.Vc;
%--------------------------------------------------------------------------


%--------------------Power of the Generators and Loads---------------------
 Pref = real(pf.Si(sys.sck(1)));

 Pg = sys.bus(:,11);
 Pg(sys.sck(1)) = abs(abs(Pref) - sys.bus(sys.sck(1),5));
 Qg = imag(pf.Si) + sys.bus(:,6);

 pf.Sg = Pg + 1i*Qg;
 pf.Sl = sys.bus(:,5) + 1i*sys.bus(:,6);
%--------------------------------------------------------------------------


%-----------------------Line Current from/to Buses-------------------------
 pf.Iij = Vi .* sys.branch(:,15) + Vj .* sys.branch(:,16);
 pf.Iji = Vi .* sys.branch(:,17) + Vj .* sys.branch(:,14);

 pf.Iijb = sys.branch(:,11) .* (Vp - Vj);
 pf.Ijib = sys.branch(:,11) .* (Vj - Vp);
%--------------------------------------------------------------------------


%----------------------Apparent Power from/to Buses------------------------
 pf.Sij = Vi .* conj(pf.Iij);
 pf.Sji = Vj .* conj(pf.Iji);

 pf.Sijb = Vp .* conj(pf.Iijb);
 pf.Sjib = Vj .* conj(pf.Ijib);
%--------------------------------------------------------------------------


%-------------------------Branch Shunt Injection---------------------------
 pf.Qis = imag(sys.branch(:,12)) .* abs(Vp).^2;
 pf.Qjs = imag(sys.branch(:,12)) .* abs(Vj).^2;
%--------------------------------------------------------------------------


%-----------------------Active and Reactive Losses-------------------------
 Plos = (abs(pf.Iijb)).^2 .* sys.branch(:,4);
 Qlos = (abs(pf.Iijb)).^2 .* sys.branch(:,5);
 
 pf.Slos = Plos + 1i*Qlos;
%--------------------------------------------------------------------------


%--------------------Apparent Power at Shunt Elements----------------------
 pf.Ssh = pf.Vc .* conj(pf.Vc .* sys.ysh);
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 pf.time.pos = toc;
%--------------------------------------------------------------------------