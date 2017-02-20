 function [out] = dc2_estimation(in)



%-----------------------Active Power Flow Jacobian-------------------------
 J_pij = zeros(in.Npij, in.Nbu);                                          
 
 c   = [(1:in.Npij)'; (1:in.Npij)'];                               
 r   = [in.Pij(:,1); in.Pij(:,2)];
 px  = sub2ind(size(J_pij), c, r);
 
 J_pij(px) = [-in.Pij(:,5); in.Pij(:,5)];
%--------------------------------------------------------------------------
 
 
%--------------------Active Power Injection Jacobian-----------------------
 J_pi = -imag(in.Y_bus(in.Pi(:,1),:));
%--------------------------------------------------------------------------


%--------------------------Voltage Angle Jacobian--------------------------
 J_t = diag(ones(in.Nbu, 1)); 
 J_t = J_t(in.Ti(:,1),:);
%--------------------------------------------------------------------------


%----------------------------Jacobian Matrix-------------------------------
 J_full = [J_pij; J_pi; J_t];
 J = J_full;
 J(:,in.slack) = [];
%--------------------------------------------------------------------------


%---------------------------Bus Voltage Angles-----------------------------
 Hti = (in.C^(1/2) \ eye(size(in.C))) * J;                                                      
 rti = (in.C^(1/2) \ eye(size(in.C))) * in.z;     
    
 [Q,R,P] = qr(Hti);                                                         
 [~,n]   = size(Hti);
 r       = rank(Hti);   
 
 Qn = Q(:,1:r);                                                           
 U  = R(1:r,1:r);    
 
 Tetas = P * [U \ (Qn' * rti); zeros(n - r, 1)];  
%--------------------------------------------------------------------------


%-----------------------Voltage Phases with Slack Bus----------------------
 insert   = @(a, x, n) cat(2, x(1:n), a, x(n + 1:end));                     % insert the slack bus voltage angle    
 out.Teta = (insert(0, Tetas', in.slack - 1))';                             % the bus voltage angle vector
 out.Teta = repmat(in.valsl, in.Nbu, 1) + out.Teta;                         % solution acording to the slack bus
%--------------------------------------------------------------------------


%--------------------Active Power Flow at Branches-------------------------
 iTi = sub2ind(size(out.Teta), in.Br_f(:,1));                               % indexes on side from bus
 jTj = sub2ind(size(out.Teta), in.Br_f(:,2));                               % indexes on side to bus                                

 out.Pbch = -imag(in.Br_f(:,3)) .* (out.Teta(iTi) - out.Teta(jTj));         % active power flow at transmission lines and transformers
%--------------------------------------------------------------------------


%----------------Injection Active Power with Slack Bus---------------------
 out.Pbus = -imag(in.Y_bus) * out.Teta;                                     % active power injetion into buses
%--------------------------------------------------------------------------
 

%----------------------Vector of Estimated Values--------------------------
 out.f = J_full  * out.Teta;
%--------------------------------------------------------------------------