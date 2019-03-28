 function [se] = name_unit_dcse(data, sys, se)

%--------------------------------------------------------------------------
% Builds the data of measurement types and units.
%
% Each measurement is associated with type, active power flow, active power
% injection, and bus voltage angle with an associated name and unit.
% Finally, the vector for conversion from per-unit to real unit system is
% formed. Finally, the postprocessing time is obtained here.
%--------------------------------------------------------------------------
%  Inputs:
%	- data: input power system data with measurements
%	- sys: power system data
%	- se: state estimation data
%
%  Outputs:
%	- se.device with columns: (1)measurement type; (2)measurement unit
%	- se.estimate with additional column: (4)unit conversion
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------------Measurement Names-----------------------------
 from = data.legacy.flow(:,1);
 to   = data.legacy.flow(:,2);
 busp = data.legacy.injection(:,1);
 bust = data.pmu.voltage(:,1);

 Pij = repmat({'P'}, [sys.Npij,1]);
 Pi  = repmat({'P'}, [sys.Npi,1]);
 Ti  = repmat({'T'}, [sys.Nti,1]);

 a    = strtrim(cellstr(num2str(from)));
 b    = strtrim(cellstr(num2str(to)));
 Pijt = strcat(Pij,a,{','},b);

 Pit  = strcat(Pi,strtrim(cellstr(num2str(busp))));
 Tit = strcat(Ti,strtrim(cellstr(num2str(bust))));

 se.device = [Pijt; Pit; Tit];
%--------------------------------------------------------------------------


%----------------------------Measurement Units-----------------------------
 Pij = repmat({'[MW]'}, [sys.Npij,1]);
 Pi  = repmat({'[MW]'}, [sys.Npi,1]);
 Ti  = repmat({'[deg]'},[sys.Nti,1]);

 se.device(:,2) = [Pij; Pi; Ti];
%--------------------------------------------------------------------------


%------------------------Measurement to Real Units-------------------------
 se.estimate(:,4) = [sys.base * ones(sys.Nleg,1); 180/pi * ones(sys.Npmu,1)];
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 se.time.pos = toc;
%--------------------------------------------------------------------------