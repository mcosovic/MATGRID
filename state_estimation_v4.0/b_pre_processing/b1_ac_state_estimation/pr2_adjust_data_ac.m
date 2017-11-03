 function [ana, pmu] = pr2_adjust_data_ac(sys, a, p)
   

 
%--------------------Find Turn On Analog Measurements----------------------
 para = [sys.LiTr(:,3:4); sys.LiTr(:,3) sys.LiTr(:,5)];               

 pf       = a.flow(:,4) == 1;                                            
 ana.Pij  = [a.flow(pf, 1:2) a.flow(pf, 3) a.flow(pf, 7) ...
            real(para(pf,1)) imag(para(pf,1)) real(para(pf,2))];
 ana.Npij = size(ana.Pij,1);
  
 qf       = a.flow(:,6) == 1;                                            
 ana.Qij  = [a.flow(qf,1:2) a.flow(qf,5) a.flow(qf,7) ...
            real(para(qf,1)) imag(para(qf,1)) imag(para(qf,2))];            
 ana.Nqij = size(ana.Qij,1);
 
 pi      = a.injection(:,3) == 1;                                        
 ana.Pi  = [a.injection(pi,1) a.injection(pi,2) a.injection(pi,6)];                                   
 ana.Npi = size(ana.Pi,1);

 qi      = a.injection(:,5) == 1;                                        
 ana.Qi  = [a.injection(qi,1) a.injection(qi,4) a.injection(qi,6)];                                        
 ana.Nqi = size(ana.Qi,1);
 
 cm        = a.current(:,4) == 1;                                         
 ana.Imij  = [a.current(cm,1:3) a.current(cm,5) real(para(cm,1)) ...   
             imag(para(cm,1)) real(para(cm,2)) imag(para(cm,2))];                              
 ana.Nimij = size(ana.Imij,1);
 
 vm      = a.voltage(:,3) == 1;                                          
 ana.Vi  = [a.voltage(vm,1:2) a.voltage(vm,4)];                       
 ana.Nvi = size(ana.Vi,1);
 
 ana.Nana = ana.Npij + ana.Nqij + ana.Npi + ana.Nqi + ana.Nimij + ana.Nvi;
%--------------------------------------------------------------------------


%----------------------Find Turn On PMU Measurements-----------------------
 vmp     = p.voltage(:,4) == 1;                                          
 pmu.Vi  = [p.voltage(vmp,1) p.voltage(vmp,2) p.voltage(vmp,5)];                          
 pmu.Nvi = size(pmu.Vi,1);
 
 vap               = vmp;
 vap(sys.slack(1)) = 0;
 pmu.Ti            = [p.voltage(vap,1) p.voltage(vap,3) p.voltage(vap,5)];                          
 pmu.Nti           = size(pmu.Ti,1);

 cp        = p.current(:,5) == 1;                                         
 pmu.Icij  = [p.current(cp,1:2) p.current(cp,3) .* cos(p.current(cp,4)) ...
             p.current(cp,3) .* sin(p.current(cp,4)) p.current(cp,6) ...
             real(para(cp,1)) imag(para(cp,1)) real(para(cp,2)) ....
             imag(para(cp,2))];        
 pmu.Nicij = size(pmu.Icij,1);
 
 pmu.Npmu = pmu.Nvi + pmu.Nti + 2 * pmu.Nicij;
%--------------------------------------------------------------------------


%---------------------------------Vectors----------------------------------
 ana.z = [ana.Pij(:,3); ana.Qij(:,3); ana.Imij(:,3); ana.Pi(:,2);          
         ana.Qi(:,2); ana.Vi(:,2)]; 
 pmu.z = [pmu.Vi(:,2); pmu.Ti(:,2); pmu.Icij(:,3); pmu.Icij(:,4)];      
 
 ana.s  = [ana.Pij(:,4); ana.Qij(:,4); ana.Imij(:,4); ana.Pi(:,3); 
          ana.Qi(:,3); ana.Vi(:,3)];
 pmu.s  = [pmu.Vi(:,3); pmu.Ti(:,3); pmu.Icij(:,5); pmu.Icij(:,5)];    
 
 ana.on = [pf; qf; cm; pi; qi; vm];
 pmu.on = [vmp; vap; cp; cp];
%--------------------------------------------------------------------------
 
