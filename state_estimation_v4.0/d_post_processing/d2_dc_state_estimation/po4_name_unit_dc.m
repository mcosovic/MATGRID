 function [out] = po4_name_unit_dc(sys, ana, pmu, out)

  
 
%----------------------------Measuremnt Names------------------------------
 Pij = repmat({'P'}, [ana.Npij, 1]);
 Pi  = repmat({'P'}, [ana.Npi, 1]);
 Ti  = repmat({'T'}, [pmu.Nti, 1]);
 
 a    = strtrim(cellstr(num2str(ana.Pij(:,1))));
 b    = strtrim(cellstr(num2str(ana.Pij(:,2))));
 Pijt = strcat(Pij,a,{','},b);
 
 Pit  = strcat(Pi,strtrim(cellstr(num2str(ana.Pi(:,1)))));
 Tit = strcat(Ti,strtrim(cellstr(num2str(pmu.Ti(:,1)))));
 
 out.name = [Pijt; Pit; Tit];
%--------------------------------------------------------------------------


%---------------------------Measuremnt Units-------------------------------
 Pij = repmat({'[MW]'},     [ana.Npij, 1]);
 Pi  = repmat({'[MW]'},     [ana.Npi, 1]);
 Ti  = repmat({'[deg/rad]'},[pmu.Nti, 1]);
 
 out.unit = [Pij; Pi; Ti]; 
%--------------------------------------------------------------------------


%-----------------------Measuremnt to Real Units---------------------------
 out.b = [repmat(sys.baseMVA, [1, ana.Npij + ana.Npi]), ... 
         repmat(180/pi, [1, pmu.Nti])];
%--------------------------------------------------------------------------