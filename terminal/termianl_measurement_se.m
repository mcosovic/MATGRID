 function termianl_measurement_se(in, sys)



%% Measurement Terminal with Exact Values
 b = in.estimate(:,4);

 if sys.exact == 1
    if sys.Nleg ~= 0
	   disp(' ')
	   disp('   _______________________________________________________________________________________________________________________________________')
	   disp('  |                                                       Legacy Measurement Devices                                                      |')
	   disp('  |                                                                                                                                       |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Exact      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|-----------------------------|------------------|')
	   for i = 1:sys.Nleg
		   fprintf('  |\t    %-8.f   %-12s %-10s %9.2f     | %11.2f %13.2e     | %9.2f %13.2e     | %12.2e     |\n',...
				   i,  in.device{i,1},  in.device{i,2},  in.estimate(i,3)*b(i),  in.estimate(i,1)*b(i),  abs(in.estimate(i,3) - in.estimate(i,1))*b(i), ...
				   in.estimate(i,5)*b(i), abs(in.estimate(i,3) - in.estimate(i,5))*b(i),  in.estimate(i,2)*b(i))
	   end
	   disp('  |______________________________________________________|_______________________________|_____________________________|__________________|')
    end
    if sys.Npmu ~= 0
	   disp(' ')
	   disp('   _______________________________________________________________________________________________________________________________________')
	   disp('  |                                                       Phasor Measurement Devices                                                      |')
	   disp('  |                                                                                                                                       |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Exact      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|-----------------------------|------------------|')
	   for i = (sys.Nleg + 1) : sys.Ntot
		   fprintf('  |\t    %-8.f   %-12s %-10s %9.2f     | %11.2f %13.2e     | %9.2f %13.2e     | %12.2e     |\n',...
				   i - sys.Nleg,  in.device{i,1},  in.device{i,2},  in.estimate(i,3)*b(i),  in.estimate(i,1)*b(i),  abs(in.estimate(i,3) - in.estimate(i,1))*b(i), ...
				   in.estimate(i,5)*b(i), abs(in.estimate(i,3) - in.estimate(i,5))*b(i),  in.estimate(i,2)*b(i))
	   end
	   disp('  |______________________________________________________|_______________________________|_____________________________|__________________|')
    end
 end

%% Measurement Terminal without Exact Values
 if sys.exact == 0
    if sys.Nleg ~= 0
	   disp(' ')
	   disp('   _________________________________________________________________________________________________________')
	   disp('  |                                       Legacy Measurement Devices                                        |')
	   disp('  |                                                                                                         |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|------------------|')
	   for i = 1:sys.Nleg
		   fprintf('  |\t    %-8.f   %-12s %-10s %9.2f     | %11.2f %13.2e     | %12.2e     |\n',...
				   i,  in.device{i,1},  in.device{i,2},  in.estimate(i,3)*b(i),  in.estimate(i,1)*b(i), ...
				   abs(in.estimate(i,3) - in.estimate(i,1))*b(i),  in.estimate(i,2)*b(i))
	   end
	   disp('  |______________________________________________________|_______________________________|__________________|')
    end
	if sys.Npmu ~= 0
	   disp(' ')
	   disp('   _________________________________________________________________________________________________________')
	   disp('  |                                       Legacy Measurement Devices                                        |')
	   disp('  |                                                                                                         |')
	   disp('  |     No.        Type         Unit        Estimate     |     Measure      Residual     |     Variance     |')
	   disp('  |------------------------------------------------------|-------------------------------|------------------|')
	   for i = (sys.Nleg + 1) : sys.Ntot
		   fprintf('  |\t    %-8.f   %-12s %-10s %9.2f     | %11.2f %13.2e     | %12.2e     |\n',...
				   i - sys.Nleg,  in.device{i,1},  in.device{i,2},  in.estimate(i,3)*b(i),  in.estimate(i,1)*b(i), ...
				   abs(in.estimate(i,3) - in.estimate(i,1))*b(i),  in.estimate(i,2)*b(i))
	   end
	   disp('  |______________________________________________________|_______________________________|__________________|')
	end
 end