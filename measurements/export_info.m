 function [data] = export_info(data, user, msr)

%--------------------------------------------------------------------------
% Forms the info data for generated measurement set.
%--------------------------------------------------------------------------
%  Input:
%	- user: user inputs
%	- data: input power system data
%	- msr: measurement data
%
%  Output:
%	- data.info: info data for generated measurement set
%--------------------------------------------------------------------------
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%---------------------Measurement Sets and Variances-----------------------
 Aflo = data.legacy.flow(:,4);
 Rflo = data.legacy.flow(:,7); 
 Cmag = data.legacy.current(:,4);
 Ainj = data.legacy.injection(:,3);
 Rinj = data.legacy.injection(:,6); 
 Vmag = data.legacy.voltage(:,3); 
 Cpm  = data.pmu.current(:,4);
 Cpa  = data.pmu.current(:,7);
 Vpm  = data.pmu.voltage(:,3);
 Vpa  = data.pmu.voltage(:,6); 

 Afs  = data.legacy.flow(:,5);
 Rfs  = data.legacy.flow(:,8); 
 Cms  = data.legacy.current(:,5);
 Ais  = data.legacy.injection(:,4);
 Ris  = data.legacy.injection(:,7);
 Vms  = data.legacy.voltage(:,4); 
 Cpms = data.pmu.current(:,5);
 Cpas = data.pmu.current(:,8);
 Vpms = data.pmu.voltage(:,4);
 Vpas = data.pmu.voltage(:,7);
 
 setl = [Afs; Rfs; Cms; Ais; Ris; Vms];
 setp = [Cpms; Cpas; Vpms; Vpas];
%--------------------------------------------------------------------------


%--------------------------Measurement Info Data---------------------------
 if user.varleg == 1
	varLeg = 'Unique Variance';
	varLegv = sprintf(' %1.e ', user.legUnique');
 elseif user.varleg == 2
	varLeg = 'Randomized Variances within Limits';
	varLegv = sprintf(' [minimum value %1.e], [maximum value %1.e]', ...
			  user.legRandom(1), user.legRandom(2));
 elseif user.varleg == 3
	varLeg = 'Variances by Type';
	varLegv = sprintf(' [active flow %1.e], [reactive flow %1.e], [current magnitude %1.e], [active injection %1.e], [reactive injection %1.e], [voltage magnitude %1.e]', ...
			  user.legType(1), user.legType(2), user.legType(3), user.legType(4), user.legType(5), user.legType(6));
 elseif user.varleg == 0 
    varLeg = 'Variances are Predefined';
	varLegv = sprintf(' ');
 end

 if user.varpmu == 1
	varPmu = 'Unique Variance';
	varPmuv = sprintf(' %1.e', user.pmuUnique');
 elseif user.varpmu == 2
	varPmu = 'Randomized Variances within Limits';
	varPmuv = sprintf(' [minimum value %1.e], [maximum value %1.e]', ...
			  user.pmuRandom(1), user.pmuRandom(2));
 elseif user.varpmu == 3
	varPmu = 'Variances by Type';
	varPmuv = sprintf(' [current magnitude %1.e], [current angle %1.e], [voltage magnitude %1.e], [voltage angle %1.e]', ...
			  user.pmuType(1), user.pmuType(2), user.pmuType(3), user.pmuType(4));
 elseif user.varpmu == 0 
    varPmu = 'Variances are Predefined';
	varPmuv = sprintf(' ');          
 end

 if user.setleg == 1
	setLeg = 'Redundancy';
	setLegv = sprintf(' %1.2f', user.legRedundancy');
 elseif user.setleg == 2
	setLeg = 'Active Devices';
	setLegv = sprintf(' [power flow %1.f], [current magnitude %1.f], [power injection %1.f], [voltage magnitude %1.f]', ...
			  user.legDevice(1), user.legDevice(2), user.legDevice(3), user.legDevice(4));
elseif user.setleg == 4
    setLeg = 'No Active Legacy Measurements';
	setLegv = sprintf(' ');
 elseif user.setleg == 0
    setLeg = 'Legacy Measurement Set is Predefined';
	setLegv = sprintf(' ');
 end

 if user.setpmu == 1
	setPmu = 'Redundancy';
	setPmuv = sprintf(' %1.2f', user.pmuRedundancy');
 elseif user.setpmu == 2
	setPmu = 'Active Devices';
	setPmuv = sprintf(' PMU [%1.2f]', user.pmuDevice');
  elseif user.setpmu == 3
	setPmu = 'Optimal PMUs placed to make the entire system observable - ';
	setPmuv = sprintf(' Number of PMUs [%1.f]', sum(Vpms)');
 elseif user.setpmu == 4
    setPmu = 'No Active PMUs';
	setPmuv = sprintf(' ');
 elseif user.setpmu == 0
    setPmu = 'PMUs Set is Predefined';
	setPmuv = sprintf(' ');
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
 h9 = ['  Total',sprintf('%68.f',sum(setl)), sprintf('%21.f',sum(~setl))];

 s1 = ' PMU Variance and Set Data';
 s2 = [ blanks(30), 'Minimum Variance  Maximum Variance  Active Measurement  Inactive Measurement'];
 s3 = ['  Line Current Magnitude', sprintf('%18.2e',min(Cpm)), sprintf('%18.2e',max(Cpm)), sprintf('%15.f',sum(Cpms)), sprintf('%21.f',sum(~Cpms))];
 s4 = ['  Line Current Angle',     sprintf('%22.2e',min(Cpa)), sprintf('%18.2e',max(Cpa)), sprintf('%15.f',sum(Cpas)), sprintf('%21.f',sum(~Cpas))];
 s5 = ['  Bus Voltage Magnitude',  sprintf('%19.2e',min(Vpm)), sprintf('%18.2e',max(Vpm)), sprintf('%15.f',sum(Vpms)), sprintf('%21.f',sum(~Vpms))];
 s6 = ['  Bus Voltage Angle',      sprintf('%23.2e',min(Vpa)), sprintf('%18.2e',max(Vpa)), sprintf('%15.f',sum(Vpas)), sprintf('%21.f',sum(~Vpas))];
 s7 = ['  Total',sprintf('%68.f',sum(setp)), sprintf('%21.f',sum(~setp))];

 n1  = ' Notes';
 n2  = '  Example: leeloo(DATA, "legRedundancy", 2.5, "pmuRedundancy", 1.5)';
 n3  = '           randomized active legacy measurements and measurements from PMUs (magnitudes and angles) according to redundancy';
 n4  = '  Example: leeloo(DATA, "legDevice", [20 10 5 6], "pmuDevice", 10)';
 n5  = '           number of active measurement devices over subset of legacy devices [power flow], [current magnitude], [power injection], [voltage magnitude], and active PMUs placed at buses';
 n6  = '  Example: leeloo(DATA, "pmuOptimal")';
 n7  = '           optimal PMUs placed to make the entire system observable';
 
 n8  = '  Example: leeloo(DATA, "legUnique", 10^-10, "pmuUnique", 10^-12)';
 n9  = '           unique variance applied over all legacy measurements and measurements from PMUs';
 n10 = '  Example: leeloo(DATA, "legRandom", [10^-8 10^-6], "pmuRandom", [10^-12 10^-10])';
 n11 = '           randomized variances within limits applied over all legacy measurements and measurements from PMUs';
 n12 = '  Example: leeloo(DATA, "legType", [1e-06 1e-08 1e-08 1e-08 1e-06 1e-06], "pmuType", [1e-12 1e-10 1e-12 1e-10])';
 n13 = '           variances applied over subset of legacy measurements [active flow], [reactive flow], [current magnitude], [active injection], [reactive injection], [voltage magnitude], and';
 n14 = '           variances applied over subset of measurements from PMUs [current magnitude], [current angle], [voltage magnitude], [voltage angle]';

data.info = char(l1,t1,l2,t2,t3,t4,t5,t6,t7,l1, '', '', ...
				 l1,g1,l3,g3,g4,g5,g6,l1, '', '', ...
				 l1,h1,l4,h2,h3,h4,h5,h6,h7,h8,h9,l1, '', ...
				 l1,s1,l5, s2,s3,s4,s5,s6,s7,l1, '','', ...
				 l1,n1,l2,n2,n3,'',n4,n5,'',n6,n7,'', '', ...
				 n8,n9, '',n10,n11, '', n12,n13,n14,l1);
%--------------------------------------------------------------------------