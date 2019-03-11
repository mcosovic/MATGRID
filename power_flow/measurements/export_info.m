 function [data] = export_info(data, user, pf, msr, Aflo , Rflo, Cmag, Ainj, Rinj, Vmag, Cpm, Cpa, Vpm, Vpa, Afs, Rfs, Cms, Ais, Ris, Vms, Cpms, Cpas, Vpms, Vpas)

%--------------------------------------------------------------------------
% Forms the info data for generated measurement set.
%
%  Input:
%	- too much inputs
%
%  Output:
%	- data.info: info data for generated measurement set
%
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%--------------------------Measurement Info Data---------------------------
 if isfield(user, 'unique_legvariance')
	varLeg = 'Unique Variance';
	varLegv = sprintf(' %1.e ', user.unique_legvariance');
 elseif isfield(user, 'random_legvariance')
	varLeg = 'Randomized Variances within Limits';
	varLegv = sprintf(' [minimum value %1.e], [maximum value %1.e]', ...
			  user.random_legvariance(1), user.random_legvariance(2));
 elseif isfield(user, 'type_legvariance')
	varLeg = 'Variances by Type';
	varLegv = sprintf(' [active flow %1.e], [reactive flow %1.e], [current magnitude %1.e], [active injection %1.e], [reactive injection %1.e], [voltage magnitude %1.e]', ...
			  user.type_legvariance(1), user.type_legvariance(2), user.type_legvariance(3), user.type_legvariance(4), user.type_legvariance(5), user.type_legvariance(6));
 end

 if isfield(user, 'unique_pmuvariance')
	varPmu = 'Unique Variance';
	varPmuv = sprintf(' %1.e', user.unique_pmuvariance');
 elseif isfield(user, 'random_pmuvariance')
	varPmu = 'Randomized Variances within Limits';
	varPmuv = sprintf(' [minimum value %1.e], [maximum value %1.e]', ...
			  user.random_pmuvariance(1), user.random_pmuvariance(2));
 elseif isfield(user, 'type_pmuvariance')
	varPmu = 'Variances by Type';
	varPmuv = sprintf(' [current magnitude %1.e], [current angle %1.e], [voltage magnitude %1.e], [voltage angle %1.e]', ...
			  user.type_pmuvariance(1), user.type_pmuvariance(2), user.type_pmuvariance(3), user.type_pmuvariance(4));
 end

 if isfield(user, 'redundancy_legset')
	setLeg = 'Redundancy';
	setLegv = sprintf(' %1.2f', user.redundancy_legset');
 elseif isfield(user, 'device_legset')
	setLeg = 'Active Devices';
	setLegv = sprintf(' [power flow %1.f], [current magnitude %1.f], [power injection %1.f], [voltage magnitude %1.f]', ...
			  user.device_legset(1), user.device_legset(2), user.device_legset(3), user.device_legset(4));
 end

 if isfield(user, 'redundancy_pmuset')
	setPmu = 'Redundancy';
	setPmuv = sprintf(' %1.2f', user.redundancy_pmuset');
 elseif isfield(user, 'device_pmuset')
	setPmu = 'Active Devices';
	setPmuv = sprintf(' PMU %1.2f', user.device_pmuset');
  elseif isfield(user, 'optimal_pmuset')
	setPmu = 'Optimal PMUs placed to make the entire system observable - ';
	setPmuv = sprintf(' PMU %1.f', sum(Vpms)');
 end
%--------------------------------------------------------------------------


%----------------------Export Measurement Info Data------------------------
 l1 = repmat('-',1,190);
 l2 = repmat('-',1,18);
 l3 = repmat('-',1,27);
 l4 = repmat('-',1,34);
 l5 = repmat('-',1,32);

 t1 = ' General Data';
 t2 = ['  Maximum Legacy Redundancy: ', sprintf('%1.4f',msr.mred(1)), ' (number of the legacy measurements divided by the number of state variables)'];
 t3 = ['  Maximum PMU Redundancy: ', sprintf('%1.4f',msr.mred(2)), ' (number of the measurements from PMUs (magnitudes and angles) divided by the number of state variables)'];
 t4 = ['  Number of Measurements by Legacy: ', sprintf('%1.f',msr.total(1)), ' (number of the active and reactive power flow, active and reactive power injection, line current magnitude and bus voltage magnitude measurements)'];
 t5 = ['  Number of Measurements by PMUs: ', sprintf('%1.f',msr.total(2)), ' (number of the magnitude and angle line current, and magnitude and angle bus voltage measurements)'];

 t6 = ['  Number of Legacy Devices: ',sprintf('%1.f',sum(msr.dleg)), ' (number of the power flow, power injection, line current magnitude and bus voltage magnitude devices)'];
 t7 = ['  Number of PMUs: ', sprintf('%1.f',sum(msr.dpmu)), ' (number of the PMUs placed at buses)'];

 g1 = ' Measurement Settings';
 g2 = ['  Measurements Generated: ', pf.method];
 g3 = ['  Legacy Variance: ', strcat(varLeg, ' ', varLegv)];
 g4 = ['  PMU Variance: ', strcat(varPmu, ' ', varPmuv)];
 g5 = ['  Legacy Set: ', strcat(setLeg, ' ', setLegv)];
 g6 = ['  PMU Set: ', strcat(setPmu, ' ', setPmuv)];

 h1 = ' Legacy Variance and Set Data';
 h2 = [ blanks(30), 'Minimum Variance  Maximum Variance  Active Measurement  Inactive Measurement'];
 h3 = ['  Active Power Flow',       sprintf('%23.2e',min(Aflo)), sprintf('%18.2e',max(Aflo)), sprintf('%15.f',sum(Afs)), sprintf('%21.f',sum(~Afs))];
 h4 = ['  Reactive Power Flow',     sprintf('%21.2e',min(Rflo)), sprintf('%18.2e',max(Rflo)), sprintf('%15.f',sum(Rfs)), sprintf('%21.f',sum(~Rfs))];
 h5 = ['  Line Current Magnitude',  sprintf('%18.2e',min(Cmag)), sprintf('%18.2e',max(Cmag)), sprintf('%15.f',sum(Cms)), sprintf('%21.f',sum(~Cms))];
 h6 = ['  Active Power Injection',  sprintf('%18.2e',min(Ainj)), sprintf('%18.2e',max(Ainj)), sprintf('%15.f',sum(Ais)), sprintf('%21.f',sum(~Ais))];
 h7 = ['  Reactive Power Injection',sprintf('%16.2e',min(Rinj)), sprintf('%18.2e',max(Rinj)), sprintf('%15.f',sum(Ris)), sprintf('%21.f',sum(~Ris))];
 h8 = ['  Bus Voltage Magnitude',   sprintf('%19.2e',min(Vmag)), sprintf('%18.2e',max(Vmag)), sprintf('%15.f',sum(Vms)), sprintf('%21.f',sum(~Vms))];
 h9 = ['  Total',sprintf('%68.f',sum(msr.set{1})), sprintf('%21.f',sum(~msr.set{1}))];

 s1 = ' PMU Variance and Set Data';
 s2 = [ blanks(30), 'Minimum Variance  Maximum Variance  Active Measurement  Inactive Measurement'];
 s3 = ['  Line Current Magnitude', sprintf('%18.2e',min(Cpm)), sprintf('%18.2e',max(Cpm)), sprintf('%15.f',sum(Cpms)), sprintf('%21.f',sum(~Cpms))];
 s4 = ['  Line Current Angle',     sprintf('%22.2e',min(Cpa)), sprintf('%18.2e',max(Cpa)), sprintf('%15.f',sum(Cpas)), sprintf('%21.f',sum(~Cpas))];
 s5 = ['  Bus Voltage Magnitude',  sprintf('%19.2e',min(Vpm)), sprintf('%18.2e',max(Vpm)), sprintf('%15.f',sum(Vpms)), sprintf('%21.f',sum(~Vpms))];
 s6 = ['  Bus Voltage Angle',      sprintf('%23.2e',min(Vpa)), sprintf('%18.2e',max(Vpa)), sprintf('%15.f',sum(Vpas)), sprintf('%21.f',sum(~Vpas))];
 s7 = ['  Total',sprintf('%68.f',sum(msr.set{2})), sprintf('%21.f',sum(~msr.set{2}))];

 n1  = ' Notes';
 n2  = '  Example: legvariance.unique = 10^-10 or pmuvariance.unique = 10^-12';
 n3  = '           unique variance applied over all legacy measurements or measurements from PMUs';
 n4  = '  Example: legvariance.random = [10^-8 10^-6] or pmuvariance.random = [10^-8 10^-6]';
 n5  = '           randomized variances within limits [10^-8 10^-6] applied over all legacy measurements or measurements from PMUs';
 n6  = '  Example: legvariance.type = [1e-06 1e-08 1e-08 1e-08 1e-06 1e-06]';
 n7  = '           variances applied over subset of legacy measurements [active flow], [reactive flow], [current magnitude], [active injection], [reactive injection], [voltage magnitude]';
 n8  = '  Example: pmuvariance.type = [1e-12 1e-10 1e-12 1e-10]';
 n9  = '           variances applied over subset of measurements from PMUs [current magnitude], [current angle], [voltage magnitude], [voltage angle]';
 n10 = '  Example: legset.redundancy = 2.5 or pmuset.redundancy = 1.5';
 n11 = '           randomized active legacy measurements or measurements from PMUs (magnitudes and angles) according to redundancy';
 n12 = '  Example: legset.device = [20 10 5 6]';
 n13 = '           number of active measurement devices over subset of legacy devices [power flow], [current magnitude], [power injection], [voltage magnitude]';
 n14 = '  Example: pmuset.device = 10';
 n15 = '           number of active PMUs placed at buses';
 n16 = '  Example: pmuset.optimal = 1';
 n17 = '           optimal PMUs placed to make the entire system observable';

data.info = char(l1,t1,l2,t2,t3,t4,t5,t6,t7,l1, '', '', ...
				 l1,g1,l3,g2,g3,g4,g5,g6,l1, '', '', ...
				 l1,h1,l4,h2,h3,h4,h5,h6,h7,h8,h9,l1, '', ...
				 l1,s1,l5, s2,s3,s4,s5,s6,s7,l1, '','', ...
				 l1,n1,l2,n2,n3,'',n4,n5,'',n6,n7,'',n8,n9,'','', ...
				 n10,n11,'',n12,n13,'',n14,n15,'',n16,n17,l1);
%--------------------------------------------------------------------------