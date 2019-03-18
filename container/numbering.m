 function [sys] = numbering(data, sys)

%--------------------------------------------------------------------------
% Builds the new numbering for buses and branches, only if bus numbering
% does not hold adequate form.
%
% The bus numbering is defined in form 1,2,...,sys.Nbu, and according to
% it, we also define the new branch numbering. The new numbering is
% reflected on sys.bus(:,1), sys.branch(:,2:3) and sys.generator(:,1).
%--------------------------------------------------------------------------
%  Inputs:
%	- data: power system data
%	- sys: power system data
%
%  Outputs:
%	- sys.bus with additional or changed columns:
%	  (1)new bus(i); (15)original bus numeration(i)
%	- sys.branch with additional or changed columns:
%	  (2)new indexes from bus(i); (3)new indexes to bus(j)
%	  (9)original indexes from bus(i); (10)original indexes to bus(j)
%	- sys.generator with additional or changed columns:
%	  (1)new bus(i)
%--------------------------------------------------------------------------
% Main function which is used in AC/DC power flow, non-linear and DC state
% estimation, as well as for the state estimation with PMUs.
%--------------------------------------------------------------------------


%---------------------------Original Numbering-----------------------------
 sys.branch(:,9:10) = [sys.branch(:,2) sys.branch(:,3)];
 sys.bus(:,15) = sys.bus(:,1);
%--------------------------------------------------------------------------


%------------------------------New Numbering-------------------------------
 bus = (1:sys.Nbu)';

 if max(bus ~= sys.bus(:,1)) == 1
	[~, b] = ismember(sys.branch(:,2), sys.bus(:,1));
	sys.branch(:,2) = bus(b);

	[~, b] = ismember(sys.branch(:,3), sys.bus(:,1));
	sys.branch(:,3) = bus(b);

	if isfield(data, 'generator')
	   [~, b] = ismember(sys.generator(:,1), sys.bus(:,1));
	   sys.generator(:,1) = bus(b);
	end

	sys.bus(:,1) = bus;
 end
%--------------------------------------------------------------------------