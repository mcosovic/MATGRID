 function [ana, pmu] =  pr2_adjust_data_dc(sys, a, p)
 
 
 
%-------------Turn off Voltage Angle Measurement of Slack Bus--------------
 p.Voltage(sys.slack(1), 3) = 0;
%--------------------------------------------------------------------------

 
%-----------------------Find Turn On Measurements--------------------------              
 f        = a.flow(:,4) == 1;                                               
 ana.Pij  = [a.flow(f,1:2) a.flow(f,3) a.flow(f,5) imag(sys.LiTr(f,3))];
 ana.Npij = size(ana.Pij,1);
  
 i       = a.injection(:,3) == 1;                                          
 ana.Pi  = [a.injection(i,1) a.injection(i,2) a.injection(i,4)];                                       
 ana.Npi = size(ana.Pi,1);
 
 vec_sl  = repmat(sys.slack(2), sys.Nbu, 1);
 a       = p.voltage(:,3) == 1;                                               
 pmu.Ti  = [p.voltage(a,1) (p.voltage(a,2) - vec_sl(a)) p.voltage(a,4)];      
 pmu.Nti = size(pmu.Ti,1);
  
 ana.z = [ana.Pij(:,3); ana.Pi(:,2)];
 pmu.z = pmu.Ti(:,2);
 
 ana.s = [ana.Pij(:,4); ana.Pi(:,3)];
 pmu.s = pmu.Ti(:,3);
 
 ana.on = [f; i];
 pmu.on = a;
 
 ana.Nana = ana.Npij + ana.Npi;
 pmu.Npmu = pmu.Nti;
%--------------------------------------------------------------------------