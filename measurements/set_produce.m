 function [user, msr] = set_produce(user, msr, sys)

%--------------------------------------------------------------------------
% Forms vector of measurement sets.
%
% The function forms measurement set according to predefined inputs. Sets
% are defined as struct variables 'legset' for legacy measurements and
% 'pmuset' for phasor measurements, with two options 'redundancy' and
% 'device'.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- msr: measurement data
%
%  Outputs:
%	- msr.set{1}: set for legacy measurements
%	- msr.set{2}: set for phasor measurements
%--------------------------------------------------------------------------
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%--------------------------Redundancy Legacy Set---------------------------
 if user.setleg == 1
	meas = round((msr.state) * user.legRedundancy);
	idxn = randperm(msr.total(1));
	idx  = idxn(1:meas);

	msr.set{1} = zeros(msr.total(1),1);
	msr.set{1}(idx) = 1;
 end
%--------------------------------------------------------------------------


%----------------------------Device Legacy Set-----------------------------
 if user.setleg == 2
	t = cell(4,1);
	set = user.legDevice;
	for i = 1:4
		idx  = randperm(msr.dleg(i), set(i));
		t{i} = zeros(msr.dleg(i),1);
		t{i}(idx) = 1;
	end
	msr.set{1} = vertcat([t{1}; t{1}; t{2}; t{3}; t{3}; t{4}]);
 end
%--------------------------------------------------------------------------


%---------------------------Redundancy PMU Set-----------------------------
 if user.setpmu == 1
	meas = round((msr.state) * user.pmuRedundancy);
	idxn = randperm(msr.total(2));
	idx  = idxn(1:meas);

	msr.set{2} = zeros(msr.total(2),1);
	msr.set{2}(idx) = 1;
 end
%--------------------------------------------------------------------------


%--------------------------Optimal PMU Placement---------------------------
 if user.setpmu == 3
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
	   user.pmuDevice = msr.dpmu;
       user.setpmu = 2;
    end
 end
%--------------------------------------------------------------------------


%-----------------------------Device PMU Set-------------------------------
 if user.setpmu == 2
	set = user.pmuDevice;
	idx = randperm(msr.dpmu, set);
	bus = zeros(msr.dpmu,1);
	bus(idx) = 1;
	bra = ismember([sys.branch(:,2); sys.branch(:,3)], find(bus));
	msr.set{2} = [bra; bra; bus; bus];
 end
%--------------------------------------------------------------------------


%---------------------One Set Active, Other Turn Off-----------------------
 if user.setleg ~= 0 && user.setpmu == 0
    user.setpmu = 4;
    msr.set{2} = zeros(msr.total(2),1);  
 end
 if user.setleg == 0 && user.setpmu ~= 0
    user.setleg = 4;
	msr.set{1} = zeros(msr.total(1),1);
 end
%--------------------------------------------------------------------------