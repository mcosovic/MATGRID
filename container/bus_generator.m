 function [sys] = bus_generator(sys)

%--------------------------------------------------------------------------
% Expands sys.bus variable with generators data.
%
% If there are more generators on the one bus, it is first necessary to sum
% up active and reactive powers of generators, also for generator buses the
% voltage magnitude is given. Finally, if corresponding bus is PV type, and
% generators are disconnected, we change that bus to PQ. Ultimately the
% generator data is added to sys.bus variable.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- sys.bus with additional or changed columns:
%	  (3)initial voltage magnitude(Vo);
%	  (11)generator active power(Pg); (12)generator reactive power(Qg);
%	  (13)bus reactive power limit(Qmin);
%	  (14)bus reactive power limit(Qmax)
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2018-06-05
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------------------Generation per Bus-----------------------------
 if isfield(sys, 'generator')
	Nge = size(sys.generator,1);
	A = sparse(sys.generator(:,1), (1:Nge)', 1, sys.Nbu, Nge);

	sys.bus(:,11) = A * sys.generator(:,2);
	sys.bus(:,12) = A * sys.generator(:,3);
	sys.bus(:,13) = A * sys.generator(:,4);
	sys.bus(:,14) = A * sys.generator(:,5);

	sys.bus(sys.generator(:,1),3) = sys.generator(:,6);

	sys.bus(:,2) = 1;
	sys.bus(sys.generator(:,1),2) = 2;
	sys.bus(sys.sck(1),2) = 3;
 end
%--------------------------------------------------------------------------