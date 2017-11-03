 function [dx] = gn10_increment(C, z, H, f, Ntot, Nbu)

 
 
%----------------------------QR Factorization------------------------------  
 E = speye(Ntot, Ntot);
 W = C.^(1/2) \ E;
    
 Hti = W * H;                                                      
 rti = W * (z - f);     
    
 [Q,R,P] = qr(Hti);
 r       = sprank(Hti);                                                       
 Qn      = Q(:,1:r);                                                           
 U       = R(1:r,1:r);
    
 dx = P * [U \ (Qn' * rti); sparse(2 * Nbu - 1 - r, 1)]; 
%--------------------------------------------------------------------------