 function [T, V] = initial_point_acse(user, sys, data)

%--------------------------------------------------------------------------
% Defines the initial point for the Gauss-Newton algorithm.
%
% The function according to user input defines different initial points for
% the Gauss-Newton algorithm: flat start, warm star or start with random
% perturbation.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- sys: power system data
%	- data: power system data with measurement data
%
%  Outputs:
%	- T: vector of initial bus voltage angles
%	- V: vector of initial bus voltage magnitudes
%--------------------------------------------------------------------------
% The local function which is used in the Gauss-Newton algorithm.
%--------------------------------------------------------------------------


%-------------------------------Flat Start---------------------------------
 if user.start == 3
	T = pi/180 * user.flat(1) * ones(sys.Nbu,1);
	T(sys.sck(1)) = sys.sck(2);
	V = user.flat(2) * ones(sys.Nbu,1);
 end
%--------------------------------------------------------------------------


%-------------------------------Warm Start---------------------------------
 if user.start == 2
	try
	  T = data.pmu.voltage(:,9);
	  V = data.pmu.voltage(:,8);
	catch
	  user.start = 1;
	  warning('se:startExact','Exact values were not found. The algorithm proceeds with the same initial point as the one applied in AC power flow.\n')
	end
 end
 if user.start == 1
	[sys] = bus_generator(sys);
	T = sys.bus(:,4);
	V = sys.bus(:,3);
 end
%--------------------------------------------------------------------------


%---------------------Start with Random Perturbation-----------------------
 if user.start == 4
	a = pi/180 * [user.random(1) user.random(2)];
	T = (max(a)-min(a)).*rand(sys.Nbu,1) + min(a);
	T(sys.sck(1)) = sys.sck(2);
	a = [user.random(3) user.random(4)];
	V = (max(a)-min(a)).*rand(sys.Nbu,1) + min(a);
 end
%--------------------------------------------------------------------------