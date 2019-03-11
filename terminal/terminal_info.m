 function terminal_info(in, sys, module, grid, flag)



%% Main Information
 disp(' ')
 disp(' ')
 fprintf('\tMethod: %s\n', in.method);
 fprintf('\tPower System: %s\n', grid);
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 disp(' ')
 fprintf('\tPreprocessing time: %2.5f seconds\n', in.time.pre)
 fprintf('\tConvergence time: %2.5f seconds\n', in.time.conv)
 fprintf('\tPostprocessing time: %2.5f seconds\n', in.time.pos)

%% Non-Linear Main Information
 if module == 1
	disp(' ')
	fprintf('\tStopping condition for iterative process: %s\n ', num2str(sys.stop))
	fprintf ('\tNumber of iterations: %d\n', in.No)
 end

%% Violated Limits for the AC Power Flow
 if flag == 1 && module == 1
	if any(in.bus(:,1))
	   fprintf('\tMinimum equality constraint violated at bus: %s\n', sprintf('%d ', in.bus(in.bus(:,1) ~= 0, 1)))
	end
	if any(in.bus(:,2))
	   fprintf('\tMaximum equality constraint violated at bus: %s\n', sprintf('%d ', in.bus(in.bus(:,2) ~= 0, 2)))
	end
 end