 function [sys] = preprocessing_dcse(sys)

%--------------------------------------------------------------------------
% Expands sys.branch variable.
%
% The function runs "ybus_shift_dc", and expands the sys.branch variable
% to the form (from-bus to-bus ij) and (to-bus from-bus ji).
%
%  Input:
%	- sys: power system data
%
%  Output:
%	- sys.branch: expands sys.branch, to get form [ij; ji]
%
% The local function which is used in the DC state estimation.
%--------------------------------------------------------------------------


%-----------------------------Expand Branches------------------------------
 sys.branch = sys.branch(:,1:10);
 
 [sys] = ybus_shift_dc(sys);

 expand = [(sys.Nbr+1:2*sys.Nbr)' sys.branch(:,3) sys.branch(:,2) ...
		   sys.branch(:,4:7) -sys.branch(:,8) sys.branch(:,10) ...
		   sys.branch(:,9) sys.branch(:,11)];

 sys.branch = [sys.branch; expand];
%--------------------------------------------------------------------------