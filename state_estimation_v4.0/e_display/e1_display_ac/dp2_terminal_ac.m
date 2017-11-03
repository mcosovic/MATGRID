 function dp2_terminal_ac(sys, out)
 
 

%% Main Information

 disp(' ')
 disp(' ')
 disp(' ....................:::::::::::::::::::::::::::   State Estimation   :::::::::::::::::::::::::::....................');
 disp(' ')
 fprintf('\tMethod: AC State Estimation\n');
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 fprintf('\tStopping condition for iterative process: %s\n ', num2str(sys.stop))
 fprintf ('\tNumber of iterations: %d\n', out.No)
 disp(' ')
 fprintf('\tPreprocessing time: %2.5f seconds\n', out.pre_time)
 fprintf('\tIterations time: %2.5f seconds\n', out.iter_time)
 fprintf('\tPostprocessing time: %2.5f seconds\n', out.pos_time)
 