 function [out] = po4_name_unit_ac(sys, ana, pmu, out)

  
 
%---------------------Name of Analog Measuremnts---------------------------
 Pij  = repmat({'P'}, [ana.Npij, 1]);
 Pi   = repmat({'P'}, [ana.Npi, 1]);
 Ti   = repmat({'T'}, [pmu.Nti, 1]);
 Qij  = repmat({'Q'}, [ana.Nqij, 1]);
 Iij  = repmat({'I'}, [ana.Nimij, 1]);
 Qi   = repmat({'Q'}, [ana.Nqi, 1]);
 Via  = repmat({'V'}, [ana.Nvi, 1]);
 Vip  = repmat({'V'}, [pmu.Nvi, 1]);
 Imij = repmat({'I'}, [pmu.Nicij, 1]);
 Iaij = repmat({'D'}, [pmu.Nicij, 1]);
 
 a    = strtrim(cellstr(num2str(ana.Pij(:,1))));
 b    = strtrim(cellstr(num2str(ana.Pij(:,2))));
 Pijt = strcat(Pij,a,{','},b);
 
 a    = strtrim(cellstr(num2str(ana.Qij(:,1))));
 b    = strtrim(cellstr(num2str(ana.Qij(:,2))));
 Qijt = strcat(Qij,a,{','},b);
 
 a    = strtrim(cellstr(num2str(ana.Imij(:,1))));
 b    = strtrim(cellstr(num2str(ana.Imij(:,2))));
 Iijt = strcat(Iij,a,{','},b);
    
 a     = strtrim(cellstr(num2str(pmu.Icij(:,1))));
 b     = strtrim(cellstr(num2str(pmu.Icij(:,2))));
 Imijt = strcat(Imij,a,{','},b);
 Iaijt = strcat(Iaij,a,{','},b);

 Pit  = strcat(Pi,strtrim(cellstr(num2str(ana.Pi(:,1)))));
 Tit  = strcat(Ti,strtrim(cellstr(num2str(pmu.Ti(:,1)))));
 Qit  = strcat(Qi,strtrim(cellstr(num2str(ana.Qi(:,1)))));
 Viat = strcat(Via,strtrim(cellstr(num2str(ana.Vi(:,1)))));
 Vipt = strcat(Vip,strtrim(cellstr(num2str(pmu.Vi(:,1)))));
    
 out.name = [Pijt; Qijt; Iijt; Pit; Qit; Viat; Vipt; Tit; Imijt; Iaijt];
%--------------------------------------------------------------------------


%---------------------Unit of Analog Measuremnts---------------------------
 Pij  = repmat({'[MW]'},     [ana.Npij, 1]);
 Pi   = repmat({'[MW]'},     [ana.Npi, 1]);
 Ti   = repmat({'[deg/rad]'},[pmu.Nti, 1]);
 Qij  = repmat({'[MVar]'},   [ana.Nqij, 1]);
 Iij  = repmat({'[pu]'},     [ana.Nimij, 1]);
 Qi   = repmat({'[MVAr]'},   [ana.Nqi, 1]);
 Via  = repmat({'[pu]'},     [ana.Nvi,1]);
 Vip  = repmat({'[pu]'},     [pmu.Nvi, 1]);
 Imij = repmat({'[pu]'},     [pmu.Nicij, 1]);
 Iaij = repmat({'[deg/rad]'},[pmu.Nicij, 1]);
    
 out.unit = [Pij; Qij; Iij; Pi; Qi; Via; Vip; Ti; Imij; Iaij];
%--------------------------------------------------------------------------


%----------------------Data Analog Measuremnts-----------------------------
 out.b = [repmat(sys.baseMVA, [1, ana.Npij + ana.Nqij]), ...
         ones([1, ana.Nimij]), repmat(sys.baseMVA, ...
         [1, ana.Npi + ana.Nqi]), ones([1, ana.Nvi]), ...
         ones([1, pmu.Nvi]), repmat(180 / pi, [1, pmu.Nti]), ...
         ones([1, pmu.Nicij]), repmat(180 / pi, [1, pmu.Nicij])];
%--------------------------------------------------------------------------

