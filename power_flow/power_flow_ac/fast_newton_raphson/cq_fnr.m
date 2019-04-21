 function [sys, pf, V, T, Qgl, pq, Npq, Bppi] = cq_fnr(sys, pf, V, T, Qgl, Vc, Pgl, pq, Npq, Bp2, Bppi)

%--------------------------------------------------------------------------
% Checks the bus reactive power constraints.
%
% If constraint Qmin or Qmax is violated, the type of buses is changed from
% PV bus to PQ bus, and then a generator has the new reactive power, where
% we compute a new complex voltage for the bus where reactive power is
% violated. The function saves a bus number when the constraint is
% violated.
%--------------------------------------------------------------------------
%  Inputs:
%	- sys: power system data
%	- pf: power flow data
%	- V, T: bus voltage magnitude and angle vector
%	- Qgl: reactive power at bus
%	- Vc: complex bus voltages
%	- Pgl: active power at bus
%	- pq: PQ bus indexes
%	- Npq: number of PQ buses
%	- Bppi: inverse of Bprime2
%
%  Outputs:
%	- sys.bus with changed columns
%	  (2)bus type; (12)generator reactive power(Qg);
%	- pf.limit with columns:
%	  (1)bus indicator where minimum limits violated;
%	  (2)bus indicator where maximum limits violated;
%	- V, T: bus voltage magnitude and angle vector
%	- Qgl: reactive power at bus
%	- pq: PQ bus indexes
%	- Npq: number of PQ buses
%   - Bp2: full matrix Bp2 
%	- Bppi: inverse of Bprime2
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%--------------------Check Reactive Power Constraints----------------------
 Q   = -imag(conj(Vc) .* (sys.Ybu * Vc));
 mnq = find(Q < sys.Qcon(:,1) & sys.Qcon(:,3) == 1);
 mxq = find(Q > sys.Qcon(:,2) & sys.Qcon(:,3) == 1);
%--------------------------------------------------------------------------


%-------------------------------Check Qmin---------------------------------
 if ~isempty(mnq)
	sys.bus(mnq,2)  = 1;
	sys.Qcon(mnq,3) = 0;

	sys.bus(mnq,12) = sys.Qcon(mnq,1) + sys.bus(mnq,6);

	diago   = sub2ind(size(sys.Ybu), mnq, mnq);
	Vc(mnq) = (1 ./ sys.Ybu(diago)) .* ((Pgl(mnq) - 1i * ...
			  sys.Qcon(mnq,1)) ./ conj(Vc(mnq)) - sys.Yij(mnq,:) * Vc);
 end
%--------------------------------------------------------------------------


%-------------------------------Check Qmax---------------------------------
 if ~isempty(mxq)
	sys.bus(mxq,2)  = 1;
	sys.Qcon(mxq,3) = 0;

	sys.bus(mxq,12) = sys.Qcon(mxq,2) + sys.bus(mxq,6);

	diago   = sub2ind(size(sys.Ybu), mxq, mxq);
	Vc(mxq) = (1 ./ sys.Ybu(diago)) .* ((Pgl(mxq) - 1i * ...
			  sys.Qcon(mxq,2)) ./ conj(Vc(mxq)) - sys.Yij(mxq,:) * Vc);
 end
%--------------------------------------------------------------------------


%------------------------Indexes, Parameters, Data-------------------------
 if ~isempty(mnq) || ~isempty(mxq)
	pq  = find(sys.bus(:,2) == 1);
	Npq = length(pq); 
 
	Bpp  = Bp2;
	Bpp  = Bpp(:,pq);
	Bpp  = Bpp(pq, :);
	Bppi = Bpp \ speye([Npq, Npq]);

	V = abs(Vc);
	T = angle(Vc);

	Qgl = sys.bus(:,12) - sys.bus(:,6);

	pf.limit(mnq,1) = 1;
	pf.limit(mxq,2) = 1;
 end
%--------------------------------------------------------------------------