 function [in] =  dc1_pre_processing(in)
   


%---------------------------Forming Brancehs-------------------------------
 in.Bus = [(1:in.Nbu)' zeros(in.Nbu,4)];
 [in] = pre1_pi_model(in);                                                    
 in.Br(:,4:5) = zeros(in.Nbr, 2);                                            
 [in] = pre2_ybus(in);                                                      
%--------------------------------------------------------------------------


%----------------------Read Variable from Workspace------------------------
 sc = zeros(1,3);
 for i = 1:3
     if strcmp(in.unit{i}, 'mega')
        sc(i) = 100;
     elseif strcmp(in.unit{i}, 'deg')
        sc(i) = pi/180;
     else
        sc(i) = 1;
     end
 end
%--------------------------------------------------------------------------


%---------------Initial Voltage and Voltage of Slack Bus-------------------
 in.valsl = in.slack(2) * sc(3);
 in.slack = in.slack(1);
 in.Angle(in.slack, 3) = 0;
 %--------------------------------------------------------------------------

 
%-----------------------Find Turn On Measurements--------------------------              
 fp      = in.Flow(:,4) == 1;                                               
 in.Pij  = [in.Flow(fp, 1:2) in.Flow(fp, 3)/sc(1) in.Flow(fp, 5)/sc(1) ...
            imag(in.Br_f(fp,3))];
 in.Npij = size(in.Pij,1);
  
 ip     = in.Injection(:,3) == 1;                                          
 in.Pi  = [in.Injection(ip,1) in.Injection(ip,2)/sc(2) ...
           in.Injection(ip,4)/sc(2)];                                       
 in.Npi = size(in.Pi,1);
 
 vec_sl = repmat(in.valsl, in.Nbu, 1);
 an     = in.Angle(:,3) == 1;                                               
 in.Ti  = [in.Angle(an,1) (in.Angle(an,2)*sc(3) - vec_sl(an)) ...
           in.Angle(an,4)*sc(3)];      
 in.Nti = size(in.Ti,1);
  
 in.z = [in.Pij(:,3); in.Pi(:,2); in.Ti(:,2)];                                          
      
 in.C  = diag([in.Pij(:,4); in.Pi(:,3); in.Ti(:,3)].^2);
 
 in.on = [fp; ip; an];
%--------------------------------------------------------------------------