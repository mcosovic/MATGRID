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
% Last revision by Mirsad Cosovic on 2019-04-21
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%% Main Information
 disp(' ')
 disp(' ')
 fprintf('\tMethod: %s\n', in.method);
 fprintf('\tPower System: %s\n', user{end});
 fprintf(['\tDate: ', datestr(now, 'dd.mm.yyyy HH:MM:SS \n')])
 disp(' ')
 fprintf('\tPreprocessing time: %2.5f seconds\n', in.time.Preprocess)
 fprintf('\tConvergence time: %2.5f seconds\n', in.time.Convergence)
 fprintf('\tPostprocessing time: %2.5f seconds\n', in.time.Postprocess)

%% Non-Linear Main Information
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr', 'nonlinear'}, user))
	disp(' ')
	fprintf('\tStopping condition for iterative process: %s\n ', num2str(sys.stop))
	fprintf ('\tNumber of iterations: %d\n', in.iteration)
 end

%% Violated Limits for the AC Power Flow
 if any(ismember({'nr', 'gs', 'dnr', 'fdnr'}, user))
	if any(in.bus.MinLim)
	   fprintf('\tMinimum equality constraint violated at buses: %s\n', sprintf('%d ', in.bus.Bus(logical(in.bus.MinLim))))
	end
	if any(in.bus.MaxLim)
	   fprintf('\tMaximum equality constraint violated at buses: %s\n', sprintf('%d ', in.bus.Bus(logical(in.bus.MaxLim))))
	end
 end