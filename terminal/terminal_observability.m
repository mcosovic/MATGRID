 function terminal_observability(in, re, user)

%--------------------------------------------------------------------------
% Displays observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input se data
%	- re: result data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-02
% Last revision by Mirsad Cosovic on 2019-04-20
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


 %% Observability Analysis DC State Estimation
 if ismember('dc', user)
	disp(' ')
 if ~ismember('unobservable', user)
	   fprintf('\tObservability analysis: Power system is observable\n');
	else
	   fprintf('\tObservability analysis: Power system is unobservable\n');

	   Ni  = max(in.observe.island(:,2));
	   Nb  = sum(in.observe.branch(:,3) == 0);
	   Np  = length(in.observe.psm);
	   Nm  = max([Ni Nb Np]);

	   Nic    = (1:Ni)';
	   ai     = hist(in.observe.island(:,2), Nic);
	   island = string([Nic ai']);
	   island = [island; strings(Nm-Ni,2)];

	   obs    = ~logical(in.observe.branch(:,3));
	   irr    = ~logical(in.observe.branch(:,4));
	   branch = re.branch(obs|irr,:);
	   Nbc    = (1:Nb)';
	   branch = [string(Nbc) string(branch.From) string(branch.To) branch.Status; strings(Nm-Nb,4)];

	   index    = find(contains(re.estimate.Type,'pseudo-measurement'));
	   mean     = compose('%1.2f', re.estimate.Mean(index));
	   var      = compose('%1.e', re.estimate.Variance(index));
	   restore  = [re.estimate.Device(index) mean var; strings(Nm-Np,3)];

	   ter = [island branch restore]';

	   disp(' ')
	   disp('   ____________________________________________________________________________________________________________________')
	   disp('  |       Island Data       |                Branch Data                 |          Restore Observability Data         |')
	   disp('  |     Island    Buses     |     No.   To Bus   From Bus     Label      |    Pseudo-measurement   Value   Variance    |')
	   disp('  | ------------------------|--------------------------------------------|---------------------------------------------|')
	   fprintf('  |  %6s   %8s      | %5s %8s %9s     %-14s| %12s %16s %9s     | \n', ter{:})
	   disp('  |_________________________|____________________________________________|_____________________________________________|')
	end
 end