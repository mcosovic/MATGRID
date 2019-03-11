 function [msr] = set_produce(user, msr, sys)

%--------------------------------------------------------------------------
% Forms vector of measurement sets.
%
% The function forms measurement set according to predefined inputs. Sets
% are defined as struct variables 'legset' for legacy measurements and
% 'pmuset' for phasor measurements, with two options 'redundancy' and
% 'device'.
%
%  Inputs:
%	- user: user inputs
%	- msr: measurement data
%
%  Outputs:
%	- msr.set{1}: set for legacy measurements
%	- msr.set{2}: set for phasor measurements
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%--------------------------Redundancy Legacy Set---------------------------
 if isfield(user, 'redundancy_legset')
	meas = round((msr.state) * user.redundancy_legset);
	idxn = randperm(msr.total(1));
	idx  = idxn(1:meas);

	msr.set{1} = zeros(msr.total(1),1);
	msr.set{1}(idx) = 1;
 end
%--------------------------------------------------------------------------


%---------------------------Redundancy PMU Set-----------------------------
 if isfield(user, 'redundancy_pmuset')
	meas = round((msr.state) * user.redundancy_pmuset);
	idxn = randperm(msr.total(2));
	idx  = idxn(1:meas);

	msr.set{2} = zeros(msr.total(2),1);
	msr.set{2}(idx) = 1;
 end
%--------------------------------------------------------------------------


%-----------------------------Type Legacy Set------------------------------
 if isfield(user, 'device_legset')
	t = cell(4,1);
	set = user.device_legset;
	for i = 1:4
		idx  = randperm(msr.dleg(i), set(i));
		t{i} = zeros(msr.dleg(i),1);
		t{i}(idx) = 1;
	end
	msr.set{1} = vertcat([t{1}; t{1}; t{2}; t{3}; t{3}; t{4}]);
 end
%--------------------------------------------------------------------------


%--------------------------Optimal PMU Placement---------------------------
 if isfield(user, 'optimal_pmuset') && user.optimal_pmuset == 1
	A = sys.Ybu ~= 0;
	f  = ones(sys.Nbu,1);
	lb = zeros(sys.Nbu,1);
	ub = ones(sys.Nbu,1);
	intcon = 1:sys.Nbu;

	disp(' Mixed-integer linear programming is running to find an optimal PMU set.')
	options = optimoptions('intlinprog','Display','off');
	[bus, ~, flag] = intlinprog(f,intcon,-A,-f,[],[],lb,ub,[],options);

	if any(flag == [1 2])
	   disp(' Optimal solution found.')
	   bra = ismember([sys.branch(:,2); sys.branch(:,3)], find(bus));
	   msr.set{2} = [bra; bra; bus; bus];
	else
	   warning('set:noFeasible', 'No integer feasible point found. The algorithm proceeds with complete PMU set.\n')
	   user.device_pmuset = msr.dpmu;
    end
 end
%--------------------------------------------------------------------------


%------------------------------Type PMU Set--------------------------------
 if isfield(user, 'device_pmuset')
	set = user.device_pmuset;
	idx = randperm(msr.dpmu, set);
	bus = zeros(msr.dpmu,1);
	bus(idx) = 1;
	bra = ismember([sys.branch(:,2); sys.branch(:,3)], find(bus));
	msr.set{2} = [bra; bra; bus; bus];
 end
%--------------------------------------------------------------------------