 function [out, alg] = po2_power_flow_dc(sys, ana, pmu, out)



%----------------------------Data with Slack Bus---------------------------
 tic
 pmu.z = sys.slack(2) * ones(pmu.Nti, 1) + pmu.z;
 out.z = [ana.z; pmu.z];
%--------------------------------------------------------------------------


%--------------------Active Power Flow at Branches-------------------------
 iTi = sub2ind([sys.Nbu 1], sys.LiTr(:,1));                                 % indexes on side from bus
 jTj = sub2ind([sys.Nbu 1], sys.LiTr(:,2));                                 % indexes on side to bus                                

 out.Pij = -imag(sys.LiTr(:,3)) .* (out.T(iTi) - out.T(jTj));               % active power flow at transmission lines and transformers
%--------------------------------------------------------------------------


%----------------Injection Active Power with Slack Bus---------------------
 out.Pi = -imag(sys.Ybu) * out.T;                                           % active power injetion into buses
%--------------------------------------------------------------------------
 

%----------------------Vector of Estimated Values--------------------------
 out.f = out.Jfull * out.T;
%--------------------------------------------------------------------------


%-----------------------------Dummy Variable-------------------------------
 alg = [];
%--------------------------------------------------------------------------