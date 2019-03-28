 function [se] = name_unit_pmuse(sys, se, data)

%--------------------------------------------------------------------------
% Builds the data of measurement types and units.
%
% Each measurement is associated with an associated name and unit. Also,
% the vector for conversion from per-unit to real unit system is formed.
% Finally, the postprocessing time is obtained here.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- se: state estimation data
%	- data: data corresponding with active phasor measurements
%
%  Outputs:
%	- se.device with columns: (1)measurement type; (2)measurement unit
%	- se.estimate with additional column: (4)unit conversion
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------------Name of Measurements----------------------------
 i   = [sys.branch(:,9); sys.branch(:,10)];
 j   = [sys.branch(:,10); sys.branch(:,9)];

 Vap = repmat({'T'}, [sys.Nv,1]);
 Vmp = repmat({'V'}, [sys.Nv,1]);
 Cmp = repmat({'I'}, [sys.Nc,1]);
 Cap = repmat({'D'}, [sys.Nc,1]);

 Vmpt = strcat(Vmp,strtrim(cellstr(num2str(sys.bus(data.pmu.voltage(:,14),15)))));
 Vapt = strcat(Vap,strtrim(cellstr(num2str(sys.bus(data.pmu.voltage(:,14),15)))));

 a   = strtrim(cellstr(num2str(i(data.pmu.current(:,15)))));
 b   = strtrim(cellstr(num2str(j(data.pmu.current(:,15)))));
 Cmpt = strcat(Cmp,a,{','},b);

 a   = strtrim(cellstr(num2str(i(data.pmu.current(:,15)))));
 b   = strtrim(cellstr(num2str(j(data.pmu.current(:,15)))));
 Capt = strcat(Cap,a,{','},b);

 se.device = [Vmpt; Vapt; Cmpt; Capt];
%--------------------------------------------------------------------------


%---------------------------Unit of Measurements---------------------------
 Vap = repmat({'[deg]'}, [sys.Nv,1]);
 Vmp = repmat({'[pu]'}, [sys.Nv,1]);
 Cmp = repmat({'[pu]'}, [sys.Nc,1]);
 Cap = repmat({'[deg]'}, [sys.Nc,1]);

 se.device(:,2) = [Vmp; Vap; Cmp; Cap];
%--------------------------------------------------------------------------


%------------------------Measurement to Real Units-------------------------
 se.estimate(:,4) = [ones(sys.Nv,1); repmat(180 / pi, sys.Nv, 1);
					ones(sys.Nc,1); repmat(180 / pi, sys.Nc, 1)];
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 se.time.pos = toc;
%--------------------------------------------------------------------------