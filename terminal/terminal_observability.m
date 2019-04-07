 function terminal_observability(in, user)

%--------------------------------------------------------------------------
% Displays observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-02
% Last revision by Mirsad Cosovic on 2019-04-07
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


 %% Observability Analysis DC State Estimation
 if ismember('dc', user)
	disp(' ')
	if max(in.observe.island(:,2)) == 1
	   fprintf('\tObservability analysis: The system is obesrvalbe\n');
	else
	   fprintf('\tObservability analysis: Power system is unobservable\n');
	   fprintf('\tNumber of observable islands: %1.f \n', max(in.observe.island(:,2)))

	   B = in.observe.branch;
	   B(logical(in.observe.branch(:,3)),:) = [];
	   N = size(B,1);
	   No = (1:N)';

	   l = repmat({'unobservable'}, N,1);
	   l(~logical(B(:,4)),:) =  {'irrelevant'};

	   disp(' ')
	   disp('   __________________________________________________')
	   disp('  |            Observability Branch Data             |')
	   disp('  |     No.      From Bus      To Bus      Label     |')
	   disp('  | -------------------------------------------------|')
	   for i = 1:N
		   fprintf('  |\t    %-8.f %6.f %10.f %16s  |\n',...
				   No(i), B(i,1), B(i,2), l{i,1})
	   end
	   disp('  |__________________________________________________|')
	end
 end