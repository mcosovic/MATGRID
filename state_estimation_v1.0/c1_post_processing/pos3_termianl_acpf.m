 function pos3_termianl_acpf(in, out)

%--------------------------Name of Measuremnts-----------------------------
 Pij = repmat({'P'}, [1,in.Npij]);
 Qij = repmat({'Q'}, [1,in.Nqij]);
 Iij = repmat({'I'}, [1,in.Niij]);
 Pi  = repmat({'P'}, [1,in.Npi]);
 Qi  = repmat({'Q'}, [1,in.Nqi]);
 Vi  = repmat({'V'}, [1,in.Nvi]);
 Ti  = repmat({'T'}, [1,in.Nti]);

 a = strtrim(cellstr(num2str(in.Pij(:,1))));
 b = strtrim(cellstr(num2str(in.Pij(:,2))));
 tPij = strcat(Pij',a,{','},b);
 
 a = strtrim(cellstr(num2str(in.Qij(:,1))));
 b = strtrim(cellstr(num2str(in.Qij(:,2))));
 tQij = strcat(Qij',a,{','},b);
 
 a = strtrim(cellstr(num2str(in.Iij(:,1))));
 b = strtrim(cellstr(num2str(in.Iij(:,2))));
 tIij = strcat(Iij',a,{','},b);

 tPi = strcat(Pi',strtrim(cellstr(num2str(in.Pi(:,1))))); 
 tQi = strcat(Qi',strtrim(cellstr(num2str(in.Qi(:,1)))));
 tVi = strcat(Vi',strtrim(cellstr(num2str(in.Vi(:,1)))));
 tTi = strcat(Ti',strtrim(cellstr(num2str(in.Ti(:,1)))));

 name = {[tPij; tQij; tIij; tPi; tQi; tVi; tTi]};
%--------------------------------------------------------------------------


%------------------------------Units---------------------------------------
 Pij = repmat({'[MW]'}, [in.Npij,1]);
 Qij = repmat({'[MVar]'}, [in.Nqij,1]);
 Iij = repmat({'[pu]'}, [in.Niij,1]);
 Pi  = repmat({'[MW]'}, [in.Npi,1]);
 Qi  = repmat({'[MVAr]'}, [in.Nqi,1]);
 Vi  = repmat({'[pu]'}, [in.Nvi,1]);
 Ti  = repmat({'[deg]'}, [in.Nti,1]);
 
 unit = {[Pij; Qij; Iij; Pi; Qi; Vi; Ti]};
%--------------------------------------------------------------------------


%-------------------------------Data---------------------------------------
 b = [repmat(in.baseMVA, [1, in.Npij + in.Nqij]), ones([1, in.Niij]), ...
     repmat(in.baseMVA, [1, in.Npi + in.Nqi]), ones([1, in.Nvi]), ...
     repmat( 180/pi, [1, in.Nti])];
 
 Cv = in.C^(1/2) * ones(length(in.C),1);

 V    = abs(out.V);
 teta = angle(out.V);
 
 [Pij, Qij] = gn4_flow_eqn(V, teta, in.Pij, in.Qij);
 [Iij]      = gn5_curr_eqn(V, teta, in.Iij, in.a, in.b, in.c, in.d);
 [Pi, Qi]   = gn6_injc_eqn(V, teta, in);
 [Vi, Ti]   = gn7_volt_eqn(V, teta, in.Vi, in.Ti);
 f          = [Pij; Qij; Iij; Pi; Qi; Vi; Ti];   

 tv = [in.Flow(:,8); in.Flow(:,9); in.Current(:,6); in.Injection(:, 7); ...
      in.Injection(:, 8); in.Magnitude(:, 5); in.Angle(:, 5)]; 
 tv = tv(in.on);
 Nm = size(tv, 1);
%-------------------------------------------------------------------------- 


%---------------------State Estimation Evaluation--------------------------
 MAE1 = sum(abs(in.z - f))/Nm; 
 MAE2 = sum(abs(tv - f .* b'))/Nm;
 MAE3 = sum(abs([in.Magnitude(:, 5); deg2rad(in.Angle(:, 5))] -  ...
        [V; teta]))/(2 * in.Nbu);
 
 RMSE1 = ((sum(in.z - f).^2)/Nm)^1/2; 
 RMSE2 = ((sum(tv - f .* b').^2)/Nm)^1/2; 
 RMSE3 = ((sum([in.Magnitude(:, 5); deg2rad(in.Angle(:, 5))] -  ...
         [V; teta]).^2)/Nm)^1/2;   
     
 WRSS1 =  sum(((in.z - f).^2)./(Cv.^2));
 WRSS2 =  sum(((tv ./ b' - f).^2)./(Cv.^2));
%--------------------------------------------------------------------------

 disp(' ') 
 disp('   ___________________________________________________________________________________________________________________') 
 disp('  |                                                                                                                   |')
 disp('  |  No.  Type     Unit       Measure     Estimate     True State    Residual M-E  Residual T-E   Standard Deviation  |')
 disp('  |-------------------------------------------------------------------------------------------------------------------|')
 for i = 1:Nm
 fprintf('  |%4.f   %-9s%-6s %11.4f %12.4f %12.4f %14.4f %13.4f %18.4e \t  |\n',...
          i,  name{1}{i}, unit{1}{i}, in.z(i) * b(i), f(i) * b(i), tv(i), (in.z(i) - f(i)) * b(i), ...
          tv(i) - f(i)*b(i), Cv(i) * b(i))
 end
 disp('  |___________________________________________________________________________________________________________________|')
 
 disp('   ___________________________________________________________________________________________________________________') 
 disp('  |                                                                                                                   |')
 disp('  |  State Estimation Evaluation            Mesure and Estimate   True State and Estimate    True State and Estimate  |')
 disp('  |                                             Measurements            Measurements             State Variables      |')
 disp('  |-------------------------------------------------------------------------------------------------------------------|')
 fprintf('  |\t Mean absolute error %34.4e %23.4e %26.4e \t\t  |\n', [MAE1 MAE2 MAE3])
 fprintf('  |\t Root Mean square error %31.4e %23.4e %26.4e \t\t  |\n', [RMSE1 RMSE2 RMSE3] )
 fprintf('  |\t Weighted residual sum of squares error %15.4e %23.4e %33s |\n', [WRSS1 WRSS2],[])
 disp('  |___________________________________________________________________________________________________________________|')


 