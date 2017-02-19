 function [in] = pre3_adjust_data(in)
   

 
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
 para = [in.Br_f(:,3:4); in.Br_f(:,3) in.Br_f(:,5)];               

 fp      = in.Flow(:,4) == 1;                                               % find where is active power flow measurements turn on 
 in.Pij  = [in.Flow(fp, 1:2) in.Flow(fp, 3)/sc(1) in.Flow(fp, 7)/sc(1) ...
           real(para(fp,1)) imag(para(fp,1))  real(para(fp,2))];
 in.Npij = size(in.Pij,1);
  
 fq      = in.Flow(:,6) == 1;                                               % reactive power flow turn on
 in.Qij  = [in.Flow(fq,1:2)  in.Flow(fq,5)/sc(1) in.Flow(fq,7)/sc(1) ...
           real(para(fq,1)) imag(para(fq,1))  imag(para(fq,2))];            % reactive power flow measurements
 in.Nqij = size(in.Qij,1);
 
 ip     = in.Injection(:,3) == 1;                                           % injection active power turn on
 in.Pi  = [in.Injection(ip,1) in.Injection(ip,2)/sc(2) ...
          in.Injection(ip,6)/sc(2)];                                        % injection active power measurements
 in.Npi = size(in.Pi,1);

 iq     = in.Injection(:,5) == 1;                                           % injection active power turn on
 in.Qi  = [in.Injection(iq,1) in.Injection(iq,4)/sc(2) ...
          in.Injection(iq,6)/sc(2)];                                        % injection active power measurements
 in.Nqi = size(in.Qi,1);
 
 cu      = in.Current(:,4) == 1;                                            % current magnitude turn on
 in.Iij  = [in.Current(cu,1:3) in.Current(cu,5)...
           real(para(cu,1)) imag(para(cu,1)) ... 
           real(para(cu,2)) imag(para(cu,2))];                              % current magnitude measurements
 in.Niij = size(in.Iij,1);
 
 ma     = in.Magnitude(:,3) == 1;                                           % voltage magnitude turn on
 in.Vi  = [in.Magnitude(ma,1:2) in.Magnitude(ma,4)];                        % voltage magnitude measurements
 in.Nvi = size(in.Vi,1);

 an     = in.Angle(:,3) == 1;                                               % voltage phain turn on
 in.Ti  = [in.Angle(an,1) in.Angle(an,2)*sc(3) in.Angle(an,4)*sc(3)];       % voltage phase measurements
 in.Nti = size(in.Ti,1);
 
 in.z = [in.Pij(:,3); in.Qij(:,3); in.Iij(:,3); in.Pi(:,2); in.Qi(:,2); ...
         in.Vi(:,2); in.Ti(:,2)];                                           % vector of measurements
      
 in.C  = diag([in.Pij(:,4); in.Qij(:,4); in.Iij(:,4);  ...
               in.Pi(:,3); in.Qi(:,3); in.Vi(:,3); in.Ti(:,3)].^2);
 
 in.on = [fp; fq; cu; ip; iq; ma; an];
%--------------------------------------------------------------------------

