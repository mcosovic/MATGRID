 function [delta_x] = gn3_increment(C, z, H, No, f)

 
 
 warning ('off', 'MATLAB:nearlySingularMatrix')

 testC = cond(C);
 testG = cond(H' * (C \ eye(size(C))) * H);

 if testC > 10^14 || testG > 10^14
    if testC > 10^14
       fprintf('\tThe covariance matrix is nearly ill-conditioned: The QR algorithm is used in iteration:%3.f\n', No); 
    end
    if testG > 10^14
       fprintf('\tThe gain matrix is nearly ill-conditioned: The QR algorithm is used in iteration:%3.f\n', No);
    end
    
    testQR = cond(C^(1/2));
    if testQR > 10^14
       fprintf('\tThe QR algorithm is a numerically unstable. Check input data.\n');
    end
    
    Hti = (C^(1/2) \ eye(size(C))) * H;                                                      
    rti = (C^(1/2) \ eye(size(C))) * (z - f);     
    
    [Q,R,P] = qr(Hti);                                                         
    [~,n]   = size(Hti);
    r       = rank(Hti);                                                       
    Qn = Q(:,1:r);                                                           
    U  = R(1:r,1:r);    

    delta_x = P * [U \ (Qn' * rti); zeros(n - r, 1)]; 
 else  
    G = H' * (C \ eye(size(C))) * H;
    G = G \ eye(size(G));
    delta_x = G * H' * (C \ eye(size(C))) * (z - f);
 end
 
 warning ('on', 'MATLAB:nearlySingularMatrix')