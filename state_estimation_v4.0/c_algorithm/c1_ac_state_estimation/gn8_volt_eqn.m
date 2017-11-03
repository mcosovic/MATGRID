 function [Fvol] = gn8_volt_eqn(V, T, vma, vmp, ti)
 


%-------------------Voltage Magnitude and Angle Function-------------------                                                           
 Fvol = [V(vma.i); V(vmp.i); T(ti.i)]; 
%--------------------------------------------------------------------------