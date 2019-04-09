 function terminal_observability(in, user)

%--------------------------------------------------------------------------
% Displays observability analysis.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-04-02
% Last revision by Mirsad Cosovic on 2019-04-09
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


 %% Observability Analysis DC State Estimation
 if ismember('dc', user)
	disp(' ')
	if max(in.observe.island(:,2)) == 1
	   fprintf('\tObservability analysis: The system is observable\n');
	else
	   fprintf('\tObservability analysis: Power system is unobservable\n');

	   Ni  = max(in.observe.island(:,2));
	   Nb  = sum(in.observe.branch(:,3) == 0);
	   Npi = size(in.observe.injection,1);
	   Npf = size(in.observe.flow,1);
	   Np  = Npi + Npf;
	   Nm  = max([Ni Nb Np]);

	   Nic = (1:Ni)';
	   ai  = hist(in.observe.island(:,2), Nic);
	   island = cellstr(string([Nic ai']));
	   island = [[island; repmat({' '}, Nm-Ni,2)] repmat({'|'}, Nm,1)];

	   B = in.observe.branch;
	   B(logical(in.observe.branch(:,3)),:) = [];
	   Nbc = (1:Nb)';
	   branch = cellstr(string([Nbc B(:,1:2)]));
	   label = repmat({'unobservable'}, Nb,1);
	   label(~logical(B(:,4)),:) =  {'irrelevant'};
	   branch = [[branch label; repmat({' '}, Nm-Nb,4)] repmat({'|'}, Nm,1)];

	   from = in.observe.flow(:,1);
	   to   = in.observe.flow(:,2);
	   busp = in.observe.injection(:,1);
	   Pij = repmat({'P'}, [Npf,1]);
	   Pi  = repmat({'P'}, [Npi,1]);

	   a    = strtrim(cellstr(num2str(from)));
	   b    = strtrim(cellstr(num2str(to)));
	   Pijt = strcat(Pij,a,{','},b);
	   Pit  = strcat(Pi,strtrim(cellstr(num2str(busp))));

	   Pijm = strtrim(cellstr(num2str(in.observe.flow(:,3), '%1.4f')));
	   Pim  = strtrim(cellstr(num2str(in.observe.injection(:,2), '%1.4f')));
	   Pijv = strtrim(cellstr(num2str(in.observe.flow(:,4), '%1.e')));
	   Piv  = strtrim(cellstr(num2str(in.observe.injection(:,3), '%1.e')));

	   devi = [Pijt; Pit];
	   mean = [Pijm; Pim];
	   vari = [Pijv; Piv];
       mean(strcmp('',mean)) = [];
       vari(strcmp('',vari)) = [];
	   restore = [[devi mean vari; repmat({' '}, Nm-Np,3)] repmat({'|'}, Nm,1)];

	   ter = [island branch restore]';

	   disp(' ')
	   disp('   ____________________________________________________________________________________________________________________')
	   disp('  |       Island Data       |                Branch Data                 |          Restore Observability Data         |')
	   disp('  |     Island    Buses     |     No.   To Bus   From Bus     Label      |    Pseudo-measurement   Value   Variance    |')
	   disp('  | ------------------------|--------------------------------------------|---------------------------------------------|')
	   fprintf('  |\t    %4s %8s %7s %5s %7s %10s %15s %3s %14s %15s %8s %5s\n', ter{:})
	   disp('  |_________________________|____________________________________________|_____________________________________________|')
	end
 end