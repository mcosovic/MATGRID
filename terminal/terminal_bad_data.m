 function terminal_bad_data(in)



%% Bad Data Identification
 if any(in.bad_data(:,1))
    N = size(in.bad_data,1);
    A = [(1:N)' in.bad_data];
    d = in.device(in.bad_data(:,3));
    o = [repmat({'Remove'}, [N-1,1]); ' '];
  
	disp(' ')
	disp('   _______________________________________________________________________________________________________________')
	disp('  |     Gauss-Newton Pass     Number of Iterations      Suspected Bad Data     Normalized Residual     Status     |')
	disp('  | --------------------------------------------------------------------------------------------------------------|')
	for i = 1:N
		   fprintf('  |\t    %10.f    %20.f  %25s      %18.2e   %13s     |\n',...
				    A(i,1),  A(i,2),  d{i,1}, A(i,3),  o{i,1} )
	end
	disp('  |_______________________________________________________________________________________________________________|')
 end
