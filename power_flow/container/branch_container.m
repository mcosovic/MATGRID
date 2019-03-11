 function [sys] = branch_container(data)

%--------------------------------------------------------------------------
% Builds the branch data container according to lines and transformers.
%
% According to status, outage branches are removed from outputs variables.
% Using a unified branch model, for transmission lines tap ratio magnitude
% is equal to one, while the phase shift angle is equal to zero, also,
% shift angle is equal to zero for in-phase transformers. Further, branch
% charging susceptances for in-phase and phase-shifting transformers are
% zeros. Finally, preprocessing time is initialized here.
%
%  Input:
%	- data: input power system data that contains lines and/or transformers
%
%  Outputs:
%	- sys.Nbr: number of branches
%	- sys.branch with columns:
%	  (1)branch number; (2)indexes from bus(i); (3)indexes to bus(j);
%	  (4)branch resistance(rij); (5)branch reactance(xij);
%	  (6)branch charging susceptance(bsi); (7)tap ratio magnitude(tij);
%	  (8)phase shift angle(fij)
%
% Main function which is used in AC/DC power flow, non-linear and DC state
% estimation, as well as for the state estimation with PMUs.
%--------------------------------------------------------------------------


%-------------------------Transmission Line Data---------------------------
 tic
 if isfield(data, 'line')
	status  = logical(data.line(:,6));
	Nli = nnz(status);

	Li = [data.line(status,1:5) ones(Nli,1) zeros(Nli,1)];
 else
	Li  = [];
	Nli = 0;
 end
%--------------------------------------------------------------------------


%------------------------In-Phase Transformer Data-------------------------
 if isfield(data, 'inTransformer')
	status = logical(data.inTransformer(:,7));
	Ntri = nnz(status);
	Tri = [data.inTransformer(status,1:6) zeros(Ntri,1)];
 else
	Tri  = [];
	Ntri = 0;
 end
%--------------------------------------------------------------------------


%---------------------Phase-Shifting Transformer Data----------------------
 if isfield(data, 'shiftTransformer')
	status = logical(data.shiftTransformer(:,8));
    Ntrp = nnz(status);
	Trp = data.shiftTransformer(status,1:7);
 else
	Trp  = [];
	Ntrp = 0;
 end
%--------------------------------------------------------------------------


%-------------------------------Branch Data--------------------------------
 sys.Nbr = Nli + Ntri + Ntrp;
 sys.branch = [(1:sys.Nbr)' [Li; Tri; Trp]];

 sys.branch(:,8) = pi/180 * sys.branch(:,8);
%--------------------------------------------------------------------------