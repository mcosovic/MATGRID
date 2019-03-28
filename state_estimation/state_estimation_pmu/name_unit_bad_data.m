 function [sys] =  name_unit_bad_data(data, sys)

%--------------------------------------------------------------------------
% Builds the data of measurement types for the bad data terminal.
%
% Each measurement is associated with an associated name that we defines
% those here.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- data: data corresponding with active phasor measurements
%
%  Outputs:
%	- sys.device with column: (1)measurement type
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------------Name of Measurements----------------------------
 i = [sys.branch(:,9); sys.branch(:,10)];
 j = [sys.branch(:,10); sys.branch(:,9)];

 V = repmat({'V'}, [sys.Nv,1]);
 C = repmat({'I'}, [sys.Nc,1]);

 V = strcat(V,strtrim(cellstr(num2str(sys.bus(data.pmu.voltage(:,14),15)))));

 a = strtrim(cellstr(num2str(i(data.pmu.current(:,15)))));
 b = strtrim(cellstr(num2str(j(data.pmu.current(:,15)))));
 C = strcat(C,a,{','},b);

 sys.device = [V; C; V; C];
%--------------------------------------------------------------------------