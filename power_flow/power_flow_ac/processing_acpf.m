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
%
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%
%  Outputs:
%	- pf.bus with additional columns:
%	  (4)apparent power injection (Si);
%	  (5)generation apparent power(Sg); (6)load apparent power(Sl);
%	  (7)apparent power at shunt elements(Ssh)
%	- pf.branch with columns:
%	  (1)line current at branch - from bus(Iij);
%	  (2)line current at branch - to bus(Iji);
%	  (3)line current after branch shunt susceptance - from bus(Iijb);
%	  (4)line current after branch shunt susceptance - to bus(Ijib);
%	  (5)apparent power at branch - from bus(Sij);
%	  (6)apparent power at branch - to bus(Sji);
%	  (7)apparent power after branch shunt susceptance - from bus(Sijb);
%	  (8)apparent power after branch shunt susceptance - from bus(Sjib);
%	  (9)reactive power injection from shunt susceptances - from bus(Qis);
%	  (10)reactive power injection from shunt susceptances - to bus(Qjs);
%	  (11)apparent power of losses(Sijl)
%
% The local function which is used in the AC power flow and non-linear
% state estimation.
%--------------------------------------------------------------------------


%------------------------------Voltage Data--------------------------------
 Vc = pf.bus(:,3);
 Vi = Vc(sys.branch(:,2));
 Vj = Vc(sys.branch(:,3));
 Vp = Vi ./ sys.branch(:,13);
%--------------------------------------------------------------------------


%----------------------Injection Bus Apparent Power------------------------
 pf.bus(:,4) = (conj(sys.Ybu) * conj(Vc)) .* Vc;
%--------------------------------------------------------------------------


%--------------------Power of the Generators and Loads---------------------
 Pref = real(pf.bus(sys.sck(1),4));

 Pg = sys.bus(:,11);
 Pg(sys.sck(1)) = abs(abs(Pref) - sys.bus(sys.sck(1),5));
 Qg = imag(pf.bus(:,4)) + sys.bus(:,6);

 pf.bus(:,5) = Pg + 1i*Qg;
 pf.bus(:,6) = sys.bus(:,5) + 1i*sys.bus(:,6);
%--------------------------------------------------------------------------


%-----------------------Line Current from/to Buses-------------------------
 pf.branch(:,1) = Vi .* sys.branch(:,15) + Vj .* sys.branch(:,16);
 pf.branch(:,2) = Vi .* sys.branch(:,17) + Vj .* sys.branch(:,14);

 pf.branch(:,3) = sys.branch(:,11) .* (Vp - Vj);
 pf.branch(:,4) = sys.branch(:,11) .* (Vj - Vp);
%--------------------------------------------------------------------------


%----------------------Apparent Power from/to Buses------------------------
 pf.branch(:,5) = Vi .* conj(pf.branch(:,1));
 pf.branch(:,6) = Vj .* conj(pf.branch(:,2));

 pf.branch(:,7) = Vp .* conj(pf.branch(:,3));
 pf.branch(:,8) = Vj .* conj(pf.branch(:,4));
%--------------------------------------------------------------------------


%-------------------------Branch Shunt Injection---------------------------
 pf.branch(:,9)  = imag(sys.branch(:,12)) .* abs(Vp).^2;
 pf.branch(:,10) = imag(sys.branch(:,12)) .* abs(Vj).^2;
%--------------------------------------------------------------------------


%-----------------------Active and Reactive Losses-------------------------
 Plos = (abs(pf.branch(:,3))).^2 .* sys.branch(:,4);
 Qlos = (abs(pf.branch(:,3))).^2 .* sys.branch(:,5);

 pf.branch(:,11) = Plos + 1i*Qlos;
%--------------------------------------------------------------------------


%--------------------Apparent Power at Shunt Elements----------------------
 pf.bus(:,7) = Vc .* conj(Vc .* sys.ysh);
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 pf.time.pos = toc;
%--------------------------------------------------------------------------