 function [T, V] = initial_point_acse(user, sys, data)

%--------------------------------------------------------------------------
% Defines the initial point for the Gauss-Newton algorithm.
%
% The function according to user input defines different initial points for
% the Gauss-Newton algorithm: flat start, warm star or start with random
% perturbation.
%
%  Inputs:
%	- user: user inputs
%	- sys: power system data
%	- data: power system data with measurement data
%
%  Outputs:
%	- T: vector of initial bus voltage angles
%	- V: vector of initial bus voltage magnitudes
%
% The local function which is used in the Gauss-Newton algorithm.
%--------------------------------------------------------------------------


%-------------------------------Flat Start---------------------------------
 if isfield(user, 'flat_estimate')
	T = pi/180 * user.flat_estimate(1) * ones(sys.Nbu,1);
	T(sys.sck(1)) = sys.sck(2);
	V = user.flat_estimate(2) * ones(sys.Nbu,1);
 end
%--------------------------------------------------------------------------


%-------------------------------Warm Start---------------------------------
 if isfield(user, 'warm_estimate') && user.warm_estimate == 2
	try
	  T = data.pmu.voltage(:,9);
	  V = data.pmu.voltage(:,8);
	catch
	  user.warm_estimate = 1;
	  warning('se:startExact','Exact values were not found. The algorithm proceeds with the same initial point as the one applied in AC power flow.\n')
	end
 end
 if isfield(user, 'warm_estimate') && user.warm_estimate == 1
	[sys] = bus_generator(sys);
	T = sys.bus(:,4);
	V = sys.bus(:,3);
 end
%--------------------------------------------------------------------------


%---------------------Start with Random Perturbation-----------------------
 if isfield(user, 'random_estimate')
	a = pi/180 * [user.random_estimate(1) user.random_estimate(2)];
	T = (max(a)-min(a)).*rand(sys.Nbu,1) + min(a);
	T(sys.sck(1)) = sys.sck(2);
	a = [user.random_estimate(3) user.random_estimate(4)];
	V = (max(a)-min(a)).*rand(sys.Nbu,1) + min(a);
 end
%--------------------------------------------------------------------------