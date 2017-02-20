 function pos5_termianl_dcpf(in, out)

%--------------------------Name of Measuremnts-----------------------------
 Pij = repmat({'P'}, [1,in.Npij]);
 Pi  = repmat({'P'}, [1,in.Npi]);
 Ti  = repmat({'T'}, [1,in.Nti]);

 a = strtrim(cellstr(num2str(in.Pij(:,1))));
 b = strtrim(cellstr(num2str(in.Pij(:,2))));
 tPij = strcat(Pij',a,{','},b);

 tPi = strcat(Pi',strtrim(cellstr(num2str(in.Pi(:,1))))); 
 tTi = strcat(Ti',strtrim(cellstr(num2str(in.Ti(:,1)))));

 name = {[tPij; tPi; tTi]};
%--------------------------------------------------------------------------


%------------------------------Units---------------------------------------
 Pij = repmat({'[MW]'}, [in.Npij,1]);
 Pi  = repmat({'[MW]'}, [in.Npi,1]);
 Ti  = repmat({'[deg]'}, [in.Nti,1]);
 
 unit = {[Pij; Pi; Ti]};
%--------------------------------------------------------------------------


%-------------------------------Data---------------------------------------
 b = [repmat(in.baseMVA, [1, in.Npij + in.Npi]), ...
     repmat( 180/pi, [1, in.Nti])];
 
 Cv = in.C^(1/2) * ones(length(in.C),1);
 
 tv = [in.Flow(:,6); in.Injection(:, 5); in.Angle(:, 5)]; 
 tv = tv(in.on);
 Nm = size(tv, 1);
%-------------------------------------------------------------------------- 

 disp(' ') 
 disp('   ___________________________________________________________________________________________________________________') 
 disp('  |                                                                                                                   |')
 disp('  |  No.  Type     Unit       Measure     Estimate     True State    Residual M-E  Residual T-E   Standard Deviation  |')
 disp('  |-------------------------------------------------------------------------------------------------------------------|')
 for i = 1:Nm
 fprintf('  |%4.f   %-9s%-6s %11.4f %12.4f %12.4f %14.4f %13.4f %18.4e \t  |\n',...
          i,  name{1}{i}, unit{1}{i}, in.z(i) * b(i), out.f(i) * b(i), tv(i), (in.z(i) - out.f(i)) * b(i), ...
          tv(i) - out.f(i)*b(i), Cv(i) * b(i))
 end
 disp('  |___________________________________________________________________________________________________________________|')
 


 