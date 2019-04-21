 function [se] = processing_acse(sys, se)

%--------------------------------------------------------------------------
% Computes the AC power flow after state estimation, as well as currents
% and losses.
%
% The function computes the apparent power injection into bus, the line
% current at branch, the line current after branch shunt susceptance, the
% apparent power at branch, the apparent power after branch shunt
% susceptance, the reactive power injection from branch shunt susceptances,
% active and reactive power losses at branch, the apparent power at shunt
% elements.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.time.pos: postprocessing time
%	- se.bus with additional columns:
%	(2)apparent power injection into bus(Si);
%	(3)apparent power at shunt elements(Ssh)
%	- se.branch with columns:
%	(1)line current at branch - from bus(Iij);
%	(2)line current at branch - to bus(Iji);
%	(3)line current after branch shunt susceptance - from bus(Iijb);
%	(4)line current after branch shunt susceptance - to bus(Ijib);
%	(5)apparent power at branch - from bus(Sij);
%	(6)apparent power at branch - to bus(Sji);
%	(7)apparent power after branch shunt susceptance - from bus(Sijb);
%	(8)apparent power after branch shunt susceptance - from bus(Sjib);
%	(9)reactive power injection from shunt susceptances - from bus(Qis);
%	(10)reactive power injection from shunt susceptances - to bus(Qjs);
%	(11)apparent power of losses(Sijl)
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-04-08
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%------------------------------Voltage Data--------------------------------
 Vi = se.Vc(sys.branch(:,2));
 Vj = se.Vc(sys.branch(:,3));
 Vp = Vi ./ sys.branch(:,13);
%--------------------------------------------------------------------------


%----------------------Injection Bus Apparent Power------------------------
 se.Si = (conj(sys.Ybu) * conj(se.Vc)) .* se.Vc;
%--------------------------------------------------------------------------


%-----------------------Line Current from/to Buses-------------------------
 se.Iij = Vi .* sys.branch(:,15) + Vj .* sys.branch(:,16);
 se.Iji = Vi .* sys.branch(:,17) + Vj .* sys.branch(:,14);

 se.Iijb = sys.branch(:,11) .* (Vp - Vj);
 se.Ijib = sys.branch(:,11) .* (Vj - Vp);
%--------------------------------------------------------------------------


%----------------------Apparent Power from/to Buses------------------------
 se.Sij = Vi .* conj(se.Iij);
 se.Sji = Vj .* conj(se.Iji);

 se.Sijb = Vp .* conj(se.Iijb);
 se.Sjib = Vj .* conj(se.Ijib);
%--------------------------------------------------------------------------

%
%-------------------------Branch Shunt Injection---------------------------
 se.Qbi = imag(sys.branch(:,12)) .* abs(Vp).^2;
 se.Qbj = imag(sys.branch(:,12)) .* abs(Vj).^2;
%--------------------------------------------------------------------------


%------------------------Active and Reactive Losses------------------------
 Plos = (abs(se.Iijb)).^2 .* sys.branch(:,4);
 Qlos = (abs(se.Iijb)).^2 .* sys.branch(:,5);

 se.Slos = Plos + 1i*Qlos;
%--------------------------------------------------------------------------


%--------------------Apparent Power at Shunt Elements----------------------
 se.Ssh = se.Vc .* conj(se.Vc .* sys.ysh);
%--------------------------------------------------------------------------