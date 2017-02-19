 function [in] = gn1_pre_processing(in)



%---------------------Data for Jacobian Sub-Matrices-----------------------
 bus = in.Bus(:,1);
 [in.Tp, in.Tp1, in.Tq, in.Tq1] = deal(zeros(in.Nbu, in.Nbu));              % preallocation
 [in.J11, in.J12] = deal(zeros(in.Npij, in.Nbu));                           % preallocation
 [in.J21, in.J22] = deal(zeros(in.Nqij, in.Nbu));                           % preallocation
 [in.J31, in.J32] = deal(zeros(in.Niij, in.Nbu));                           % preallocation
   
 I = in.Iij;
 in.a = (I(:,5) + I(:,7)).^2 + (I(:,6) + I(:,8)).^2;  
 in.b = I(:,5).^2 + I(:,6).^2; 
 in.c = I(:,5) .* (I(:,5) + I(:,7)) + I(:,6) .* (I(:,6) + I(:,8));
 in.d = I(:,5) .* I(:,8) - I(:,6) .* I(:,7);

 [r,s]   = meshgrid(in.Pi(:,1), bus);                                       % a meshgrid of bus numbers    
 in.pa   = [r(:) s(:)];                                                     % indexies for sub-matrices (N_bus x N_bus)
 in.pGij = real(in.Y_bus(sub2ind(size(in.Y_bus), in.pa(:,1), in.pa(:,2)))); % conductance Gij pick up from Y_bus according to from bus and to bus
 in.pBij = imag(in.Y_bus(sub2ind(size(in.Y_bus), in.pa(:,1), in.pa(:,2)))); % susceptance Bij pick up from Y_bus according to from bus and to bus
 in.pGii = real(in.Y_bus(sub2ind(size(in.Y_bus), bus, bus)));
 in.pBii = imag(in.Y_bus(sub2ind(size(in.Y_bus), bus, bus)));
 in.pid  = sub2ind(size(in.Tp), in.pa(:,1), in.pa(:,2));                    % linear indexies
 
 [r,s]   = meshgrid(in.Qi(:,1), bus);
 in.qa   = [r(:) s(:)];
 in.qGij = real(in.Y_bus(sub2ind(size(in.Y_bus), in.qa(:,1), in.qa(:,2)))); % conductance Gij pick up from Y_bus according to from bus and to bus
 in.qBij = imag(in.Y_bus(sub2ind(size(in.Y_bus), in.qa(:,1), in.qa(:,2)))); % susceptance Bij pick up from Y_bus according to from bus and to bus
 in.qid  = sub2ind(size(in.Tq), in.qa(:,1), in.qa(:,2));                    % linear indexies% indexies for sub-matrices (N_bus x N_bus)
 
 c      = [(1:in.Npij)'; (1:in.Npij)'];                               
 r      = [in.Pij(:,1); in.Pij(:,2)];
 in.px  = sub2ind(size(in.J11), c, r);
 
 c      = [(1:in.Nqij)'; (1:in.Nqij)'];
 r      = [in.Qij(:,1); in.Qij(:,2)];
 in.qx  = sub2ind(size(in.J21), c, r);
 
 c      = [(1:in.Niij)'; (1:in.Niij)'];
 r      = [in.Iij(:,1); in.Iij(:,2)];
 in.ix  = sub2ind(size(in.J31), c, r);
 
 Vi_vi = diag(ones(in.Nbu, 1)); 
 Vi_vi = Vi_vi(in.Vi(:,1),:);
 Vi_ti = zeros(in.Nvi, in.Nbu - 1);
 Ti_vi = zeros(in.Nti, in.Nbu); 
 Ti_ti = diag(ones(in.Nbu, 1)); 
 Ti_ti = Ti_ti(in.Ti(:,1),:);
 Ti_ti(:, in.slack) = [];

 in.Jvol = [Vi_ti Vi_vi; Ti_ti Ti_vi]; 
%--------------------------------------------------------------------------



