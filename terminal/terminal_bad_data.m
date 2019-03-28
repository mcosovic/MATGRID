 function terminal_bad_data(in, sys, user)

%--------------------------------------------------------------------------
% Displays bad data processing.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-19
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%% Bad Data Identification Non-linear State Estimation
 if ismember('nonlinear', user)
	N = size(in.bad, 1);
	A = [(1:N)' in.bad];
	d = in.device(in.bad(:,3));
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

 %% Bad Data Identification DC State Estimation
 if ismember('dc', user)
	N = size(in.bad, 1);
	A = [(1:N)' in.bad];
	d = in.device(in.bad(:,2));
	o = [repmat({'Remove'}, [N-1,1]); ' '];

	disp(' ')
	disp('   ____________________________________________________________________________')
	disp('  |     WLS Pass     Suspected Bad Data     Normalized Residual     Status     |')
	disp('  | ---------------------------------------------------------------------------|')
	for i = 1:N
		   fprintf('  |\t    %4.f    %17s      %18.2e   %14s     |\n',...
				    A(i,1), d{i,1}, A(i,2),  o{i,1} )
	end
	disp('  |____________________________________________________________________________|')
 end

  %% Bad Data Identification PMU State Estimation
 if ismember('pmu', user)
	N = size(in.bad,1 );
	A = [(1:N)' in.bad];
	d = sys.device(in.bad(:,2));
	o = [repmat({'Remove'}, [N-1,1]); ' '];

	disp(' ')
	disp('   ___________________________________________________________________________________')
	disp('  |     WLS Pass     Suspected Phasor Bad Data     Normalized Residual     Status     |')
	disp('  | ----------------------------------------------------------------------------------|')
	for i = 1:N
		   fprintf('  |\t    %4.f    %20s      %22.2e   %14s     |\n',...
				    A(i,1), d{i,1}, A(i,2),  o{i,1} )
	end
	disp('  |___________________________________________________________________________________|')
 end