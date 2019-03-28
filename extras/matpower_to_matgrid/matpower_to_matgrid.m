 clc
 clearvars

%--------------------------------------------------------------------------
% Builds the power system data from Matpower case format Version 2.
%
% Load Matpower test case as the variable 'mpc' (see line 21), where
% Matpower m.file is in the same directory as this function.
%--------------------------------------------------------------------------
%  Input:
%	- load Matpower test case
%
%  Output:
%	- data: power system data compatible with the package
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-14
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Load Matpower Case-----------------------------
 mpc = case14;
%--------------------------------------------------------------------------


%-------------------------------Description--------------------------------
 data.case      = 'case';
 data.reference = 'reference';
 data.grid      = 'Transmission';
%--------------------------------------------------------------------------


%--------------------------------Bus Data----------------------------------
data.system.bus = [mpc.bus(:,1:2) mpc.bus(:,8:9) mpc.bus(:,3:4) ...
				   mpc.bus(:,5:6) mpc.bus(:,13) mpc.bus(:,12)];
%--------------------------------------------------------------------------


%-----------------------------Generator Data-------------------------------
 data.system.generator = [mpc.gen(:,1:3) mpc.gen(:,5) mpc.gen(:,4) ...
						  mpc.gen(:,6) mpc.gen(:,8)];
%--------------------------------------------------------------------------


%--------------------------------Line Data---------------------------------
 idxl = mpc.branch(:,9) == 0 & mpc.branch(:,10) == 0;
 data.system.line = [mpc.branch(idxl,1:5) mpc.branch(idxl,11)];
%--------------------------------------------------------------------------


%------------------------In-Phase Transformer Data-------------------------
 idxit = mpc.branch(:,9) ~= 0 & mpc.branch(:,10) == 0;
 data.system.inTransformer = [mpc.branch(idxit,1:5)  ...
							  mpc.branch(idxit,9) mpc.branch(idxit,11)];
%--------------------------------------------------------------------------


%---------------------Phase-Shifting Transformer Data----------------------
 idxpt = mpc.branch(:,10) ~= 0;
 data.system.shiftTransformer = [mpc.branch(idxpt,1:5) ...
								 mpc.branch(idxpt,9:11)];

 tap = data.system.shiftTransformer(:,6) == 0;
 data.system.shiftTransformer(tap,6) = 1;
%--------------------------------------------------------------------------


%-------------------------Remove Empty Variables---------------------------
 fn = fieldnames(data.system);
 tf = cellfun(@(c) isempty(data.system.(c)), fn);
 data.system = rmfield(data.system, fn(tf));
%--------------------------------------------------------------------------


%---------------Base Power and Iterative Stopping Threshold----------------
 data.system.baseMVA = mpc.baseMVA;
 data.stop = 10^-8;
%--------------------------------------------------------------------------