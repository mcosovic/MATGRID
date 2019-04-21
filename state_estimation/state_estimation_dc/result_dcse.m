 function [re] = result_dcse(user, se, af, ai, va)

%--------------------------------------------------------------------------
% Forms the DC state estimation result data in tables.
%--------------------------------------------------------------------------
%  Inputs:
%	- se: state estimation system data
%	- af: active power flow measurement data
%	- ai: active power injection measurement data
%	- va: voltage angle measurement data
%
%  Outputs:
%	- re.bus: results related with buses
%	- se.branch: results related with branches
%	- re.estimate: estimation results
%	- re.error: error results
%	- re.time: time results
%	- re.bad: bad data results
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2017-08-04
% Last revision by Mirsad Cosovic on 2019-04-17
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-----------------------Units Conversion and Method------------------------
 todeg = 180/pi;
 tomw  = se.base;
 
 re.method = se.method; 
%--------------------------------------------------------------------------


%-----------------------Measurement Names and Units------------------------
 fromOrg = [se.branch(:,9); se.branch(:,10)];
 toOrg   = [se.branch(:,10); se.branch(:,9)];
 from    = string(fromOrg(af.on));
 to      = string(toOrg(af.on));
 
 Pijd = join([repmat({'P'}, [af.n,1]), from, to],["",","]);
 Piju = repmat({'(MW)'}, [af.n,1]);

 Pid = join([repmat({'P'}, [ai.n,1]), string(se.bus(ai.on,15))], "");
 Piu = repmat({'(MW)'}, [ai.n,1]);

 Vad = join([repmat({'T'}, [va.n,1]), string(se.bus(va.on,15))], "");
 Vau = repmat({'(deg)'}, [va.n,1]);
%--------------------------------------------------------------------------


%-------------------------------Bus Results--------------------------------
 re.bus = table(se.bus(:,15), se.Va*todeg, se.Pi*tomw, -se.bus(:,7)*tomw);

 re.bus.Properties.VariableNames        = {'Bus' 'Vang' 'Pinj' 'Psh'};
 re.bus.Properties.VariableDescriptions = {'Bus Indexes' 'Estimated Bus Voltage Angles' 'Bus Active Power Injections' 'Active Power of Shunt Elements'};
 re.bus.Properties.VariableUnits        = {'' 'Degree (deg)' 'Megawatt (MW)' 'Megawatt (MW)'};

 if ismember('unobservable', user.list)
	re.bus = [re.bus, array2table(se.observe.island(:,2))];
    
	re.bus.Properties.VariableNames{5}        = 'Island';
	re.bus.Properties.VariableDescriptions{5} = 'Island Indexes';
 end
%--------------------------------------------------------------------------


%-----------------------------Branch Results-------------------------------
 re.branch = table(se.branch(:,9), se.branch(:,10), se.Pij*tomw);

 re.branch.Properties.VariableNames        = {'From' 'To' 'Pflow'};
 re.branch.Properties.VariableDescriptions = {'From Bus Ends' 'To Bus Ends' 'Branch Active Power Flows'};
 re.branch.Properties.VariableUnits        = {'' '' 'Megawatt (MW)'};

 if ismember('unobservable', user.list)
	obs = repmat({'observable'}, [se.Nbr,1]);
	obs(~se.observe.branch(:,3)) = {'unobservable'};
	obs(~se.observe.branch(:,4)) = {'irrelevant'};

	re.branch = [re.branch table(obs)];
    
	re.branch.Properties.VariableNames{4}        = 'Status';
	re.branch.Properties.VariableDescriptions{4} = 'Branch Status: observable, unobservable or irrelevant';
 end
%--------------------------------------------------------------------------


%----------------------------Estimate Results------------------------------
 Device   = [Pijd; Pid; Vad];
 Unit     = [Piju; Piu; Vau];
 leg      = se.estimate(1:se.Nleg,:);
 pmu      = se.estimate(se.Nleg+1:se.Nleg+se.Npmu,:);
 Critical = repmat({'unknown'}, [af.n+ai.n+va.n,1]);
 
 re.estimate = leg*tomw;
 re.estimate = [re.estimate; pmu*todeg];

 mask1 = strings(2*se.Nbr + 2*se.Nbu,1);
 
 mask1([af.on; ai.on; va.on]) = {'measurement'};

 if ismember('bad', user.list)
    if ismember('unobservable', user.list) 
       se.observe.psm(ismember(se.observe.psm, se.bad(:,7))) = [];
    end
    Critical = repmat({'non-critical'}, [af.n+ai.n+va.n,1]);
    Critical(se.criti) = {'critical'};
 end  
 
 if ismember('unobservable', user.list)
	mask1(se.observe.psm) = {'pseudo-measurement'};
 end

 mask1(cellfun('isempty',mask1)) = [];

 re.estimate = [table(Device, Unit, mask1, Critical) array2table(re.estimate)];

 re.estimate.Properties.VariableDescriptions{1} = 'Type of Measurement Devices';
 re.estimate.Properties.VariableDescriptions{2} = 'Measurement Units';
 re.estimate.Properties.VariableDescriptions{3} = 'Measurement or Pseudo-Measurement';
 re.estimate.Properties.VariableDescriptions{4} = 'Critical or Non-Critical Measurement';
 re.estimate.Properties.VariableNames{3}        = 'Type';
 re.estimate.Properties.VariableNames{4}        = 'Critical';
 re.estimate.Properties.VariableNames{5}        = 'Mean';
 re.estimate.Properties.VariableDescriptions{5} = 'Measurement Values';
 re.estimate.Properties.VariableNames{6}        = 'Variance';
 re.estimate.Properties.VariableDescriptions{6} = 'Measurement Variances';
 re.estimate.Properties.VariableNames{7}        = 'Estimate';
 re.estimate.Properties.VariableDescriptions{7} = 'Estimated Values';
 re.estimate.Properties.VariableNames{8}        = 'Residual';
 re.estimate.Properties.VariableDescriptions{8} = 'Residual between estimated and measurement values';

 if se.exact
	re.estimate.Properties.VariableNames{9}         = 'Exact';
	re.estimate.Properties.VariableDescriptions{9}  = 'Exact Values';
	re.estimate.Properties.VariableNames{10}        = 'Residual2';
	re.estimate.Properties.VariableDescriptions{10} = 'Residual between estimated and exact values';
 end
%--------------------------------------------------------------------------


%------------------------------Error Results-------------------------------
 re.error = array2table(se.error);

 re.error.Properties.VariableNames{1}        = 'EstimateMean';
 re.error.Properties.RowNames                = {'MAE' 'RMSE' 'WRSS'};
 re.error.Properties.VariableDescriptions{1} = 'mean absolute, root mean square and weighted residual sum of squares errors between estimated and measurement values';

 if se.exact
	re.error.Properties.VariableNames{2}        = 'EstimateExact';
	re.error.Properties.VariableDescriptions{2} = 'mean absolute, root mean square and weighted residual sum of squares errors between estimated and exact values';
	re.error.Properties.VariableNames{3}        = 'EstimateExactState';
	re.error.Properties.VariableDescriptions{3} = 'mean absolute and root mean square errors between estimated state variables and exact values';
 end
%--------------------------------------------------------------------------


%------------------------------Time Results--------------------------------
 re.time = table(se.time.pre, se.time.con, toc);

 re.time.Properties.VariableNames        = {'Preprocess' 'Convergence', 'Postprocess'};
 re.time.Properties.VariableDescriptions = {'Preprocessing Time' 'Convergence Time' 'Postprocessing Time'};
 re.time.Properties.VariableUnits        = {'Second (s)' 'Second (s)' 'Second (s)'};
%--------------------------------------------------------------------------



%----------------------------Bad Data Results------------------------------
 if ismember('bad', user.list)
	Device = strings(size(se.bad,1),1);
	Status = repmat({'non-remove'}, [size(se.bad,1),1]);
	Status(logical(se.bad(:,2))) = {'remove'};

	flo = se.bad(:,4) == 1;
	bad = se.bad(flo,:);
	num = size(bad,1);
	fromOrg = string(fromOrg(bad(:,3)));
	toOrg   = string(toOrg(bad(:,3)));
	device  = join([repmat({'P'}, [num,1]), fromOrg, toOrg],["",","]);
	Device(bad(:,5)) = device;

	inj = se.bad(:,4) == 2;
	bad = se.bad(inj,:);
	num = size(bad,1);
	device = join([repmat({'P'}, [num,1]), string(se.bus(bad(:,3),1))], "");
	Device(bad(:,5)) = device;

	vol = se.bad(:,4) == 3;
	bad = se.bad(vol,:);
	num = size(bad,1);
	device = join([repmat({'T'}, [num,1]), string(se.bus(bad(:,3),1))], "");
	Device(bad(:,5)) = device;

	re.bad = [table(Device, Status) array2table(se.bad(:,1))];

    re.bad.Properties.VariableNames{3}        = 'Residual';
	re.bad.Properties.VariableDescriptions{1} = 'Type of Measurement Devices';
	re.bad.Properties.VariableDescriptions{2} = 'Measurement Status';
	re.bad.Properties.VariableDescriptions{3} = 'Largest Normalized Residual';
 end
%--------------------------------------------------------------------------