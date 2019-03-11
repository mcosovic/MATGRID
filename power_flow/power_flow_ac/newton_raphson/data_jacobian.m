 function [alg] = data_jacobian(T, V, alg, Nbu)

%--------------------------------------------------------------------------
% Computes elements used for Jacobian matrices.
%
% The function computes Ti - Tj; Gij*sin(Ti-Tj) - Bij*cos(Ti-Tj);
% Gij*cos(Ti-Tj) + Bij*sin(Ti-Tj); Vi*Vj, and forms corresponding
% summations.
%
%  Input:
%	- V, T: bus voltage magnitude and angle vector
%	- alg: algorithm data
%	- Nbu: number of buses
%
%  Outputs:
%	- alg: algorithm data
%
% The local function which is used in the Newton-Raphson algorithm.
%--------------------------------------------------------------------------


%------------------------------Jacobian Data-------------------------------
 Tij = T(alg.i) - T(alg.j);

 alg.Te1 = alg.Gij .* sin(Tij) - alg.Bij .* cos(Tij);
 alg.Te2 = alg.Gij .* cos(Tij) + alg.Bij .* sin(Tij);

 alg.fD1 = sparse(alg.fd1i, alg.j, -alg.Te1, Nbu - 1, Nbu) * V;
 alg.fD2 = sparse(alg.fdi, alg.fdj, alg.Te2(alg.fij), alg.Npq, Nbu) * V;
 alg.fD3 = sparse(alg.fdi, alg.fdj, alg.Te1(alg.fij), alg.Npq, Nbu) * V;

 alg.Vpq = V(alg.pq);
 alg.Vij = V(alg.i) .* V(alg.j);
%--------------------------------------------------------------------------