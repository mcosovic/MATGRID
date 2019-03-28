 function terminal_info(in, sys, user)

%--------------------------------------------------------------------------
% Displays info data.
%--------------------------------------------------------------------------
%  Inputs:
%	- in: input result data
%	- sys: power system data
%	- user: user input list
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-01-10
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%% Main Information
 disp(' ')
 disp(' ')
 fprintf('\tMethod: %s\n', in.method);
 fprintf('\tPower System: %s\n', user{end});
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 disp(' ')
 fprintf('\tPreprocessing time: %2.5f seconds\n', in.time.pre)
 fprintf('\tConvergence time: %2.5f seconds\n', in.time.con)
 fprintf('\tPostprocessing time: %2.5f seconds\n', in.time.pos)

%% Non-Linear Main Information
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr', 'nonlinear'}, user))
	disp(' ')
	fprintf('\tStopping condition for iterative process: %s\n ', num2str(sys.stop))
	fprintf ('\tNumber of iterations: %d\n', in.iteration)
 end

%% Violated Limits for the AC Power Flow
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr'}, user))
	if any(in.bus(:,6))
	   fprintf('\tMinimum equality constraint violated at bus: %s\n', sprintf('%d ', in.bus(in.bus(:,6) ~= 0, 6)))
	end
	if any(in.bus(:,7))
	   fprintf('\tMaximum equality constraint violated at bus: %s\n', sprintf('%d ', in.bus(in.bus(:,7) ~= 0, 7)))
	end
 end