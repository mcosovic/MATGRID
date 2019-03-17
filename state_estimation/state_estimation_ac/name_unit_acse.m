 function [se] = name_unit_acse(sys, se)

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
%
%  Outputs:
%	- se.device with columns: (1)measurement type; (2)measurement unit
%	- se.estimate with additional column: (4)unit conversion
%--------------------------------------------------------------------------
% The local function which is used in the non-linear state estimation.
%--------------------------------------------------------------------------


%--------------------------Name of Measurements----------------------------
 i   = [sys.branch(:,9); sys.branch(:,10)];
 j   = [sys.branch(:,10); sys.branch(:,9)];

 Pf  = repmat({'P'}, [sys.Pf.N,1]);
 Qf  = repmat({'Q'}, [sys.Qf.N,1]);
 Cm  = repmat({'I'}, [sys.Cm.N,1]);
 Pi  = repmat({'P'}, [sys.Pi.N,1]);
 Qi  = repmat({'Q'}, [sys.Qi.N,1]);
 Vml = repmat({'V'}, [sys.Vml.N,1]);

 Vap = repmat({'T'}, [sys.Vap.N,1]);
 Vmp = repmat({'V'}, [sys.Vmp.N,1]);
 Cmp = repmat({'I'}, [sys.Cmp.N,1]);
 Cap = repmat({'D'}, [sys.Cap.N,1]);

 a   = strtrim(cellstr(num2str(i(sys.Pf.idx))));
 b   = strtrim(cellstr(num2str(j(sys.Pf.idx))));
 Pft = strcat(Pf,a,{','},b);

 a   = strtrim(cellstr(num2str(i(sys.Qf.idx))));
 b   = strtrim(cellstr(num2str(j(sys.Qf.idx))));
 Qft = strcat(Qf,a,{','},b);

 a   = strtrim(cellstr(num2str(i(sys.Cm.idx))));
 b   = strtrim(cellstr(num2str(j(sys.Cm.idx))));
 Cmt = strcat(Cm,a,{','},b);

 Pit  = strcat(Pi,strtrim(cellstr(num2str(sys.bus(sys.Pi.idx,15)))));
 Qit  = strcat(Qi,strtrim(cellstr(num2str(sys.bus(sys.Qi.idx,15)))));
 Vmlt = strcat(Vml,strtrim(cellstr(num2str(sys.bus(sys.Vml.idx,15)))));

 Vmpt = strcat(Vmp,strtrim(cellstr(num2str(sys.bus(sys.Vmp.idx,15)))));
 Vapt = strcat(Vap,strtrim(cellstr(num2str(sys.bus(sys.Vap.idx,15)))));

 a   = strtrim(cellstr(num2str(i(sys.Cmp.idx))));
 b   = strtrim(cellstr(num2str(j(sys.Cmp.idx))));
 Cmpt = strcat(Cmp,a,{','},b);

 a   = strtrim(cellstr(num2str(i(sys.Cap.idx))));
 b   = strtrim(cellstr(num2str(j(sys.Cap.idx))));
 Capt = strcat(Cap,a,{','},b);

 se.device = [Pft; Qft; Cmt; Pit; Qit; Vmlt; Vmpt; Vapt; Cmpt; Capt];
%--------------------------------------------------------------------------


%---------------------------Unit of Measurements---------------------------
 Pf  = repmat({'[MW]'}, [sys.Pf.N,1]);
 Qf  = repmat({'[MW]'}, [sys.Qf.N,1]);
 Cm  = repmat({'[pu]'}, [sys.Cm.N,1]);
 Pi  = repmat({'[MW]'}, [sys.Pi.N,1]);
 Qi  = repmat({'[MVAr]'}, [sys.Qi.N,1]);
 Vml = repmat({'[pu]'}, [sys.Vml.N,1]);

 Vap = repmat({'[deg]'}, [sys.Vap.N,1]);
 Vmp = repmat({'[pu]'}, [sys.Vmp.N,1]);
 Cmp = repmat({'[pu]'}, [sys.Cmp.N,1]);
 Cap = repmat({'[deg]'}, [sys.Cap.N,1]);

 se.device(:,2) = [Pf; Qf; Cm; Pi; Qi; Vml; Vmp; Vap; Cmp; Cap];
%--------------------------------------------------------------------------


%------------------------Measurement to Real Units-------------------------
 se.estimate(:,4) = [repmat(sys.base, sys.Pf.N+sys.Qf.N, 1);
 ones(sys.Cm.N,1); repmat(sys.base, sys.Pi.N+sys.Qi.N, 1);
 ones(sys.Vml.N,1); ones(sys.Vmp.N,1); repmat(180 / pi, sys.Vap.N, 1);
 ones(sys.Cmp.N,1); repmat(180 / pi, sys.Cap.N, 1)];
%--------------------------------------------------------------------------


%---------------------------Postprocessing Time----------------------------
 se.time.pos = toc;
%--------------------------------------------------------------------------