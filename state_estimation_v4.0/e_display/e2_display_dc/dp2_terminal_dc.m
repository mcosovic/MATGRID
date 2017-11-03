 function dp2_terminal_dc(out)


 
%% Main Information

 disp(' ')
 disp(' ')
 disp(' ....................:::::::::::::::::::::::::::   State Estimation   :::::::::::::::::::::::::::....................');
 disp(' ')
 fprintf('\tMethod: DC State Estimation\n');
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 disp(' ')
 fprintf('\tPreprocessing time: %2.5f seconds\n', out.pre_time)
 fprintf('\tConvergence time: %2.5f seconds\n', out.conv_time)
 fprintf('\tPostprocessing time: %2.5f seconds\n', out.pos_time)