 function terminal_observability(in, user)

%--------------------------------------------------------------------------
% Displays observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-02
% Last revision by Mirsad Cosovic on 2019-04-03
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


 %% Observability Analysis DC State Estimation
 if ismember('dc', user)
	disp(' ')
	if isempty(in.observe.notBranch)
	   fprintf('\tObservability analysis: The system is obesrvalbe\n');
	else
	   fprintf('\tObservability analysis: Power system is unobservable\n');
	   N = size(in.observe.notBranch,1);
	   No = (1:N)';

	  disp(' ')
	  disp('   _______________________________________')
	  disp('  |          Unobservable Branch          |')
	  disp('  |     No.      From Bus      To Bus     |')
	  disp('  | --------------------------------------|')
	  for i = 1:N
		  fprintf('  |\t    %-8.f %6.f %10.f    \t  |\n',...
				   No(i), in.observe.notBranch(i,1), in.observe.notBranch(i,2)  )
	  end
	  disp('  |_______________________________________|')
	end
 end