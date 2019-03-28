 function [se] = info_acse(user, se)

%--------------------------------------------------------------------------
% Forms the info data for the nonlinear and PMU state estimation.
%--------------------------------------------------------------------------
%  Input:
%	- se: state estimation data
%
%  Output:
%	- se.info: the nonlinear and PMU state estimation info data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%---------------Info Nonlinear or PMU State Estimation Data----------------
 l1 = repmat('-',1,120);

 if ismember('pmu', user)
    r1 = ' The PMU State Estimation Result Variable Description';
 end
 
 if ismember('nonlinear', user)
    r1 = ' The Non-linear State Estimation Result Variable Description';
 end 

 t0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 t1  =  '   | Variable: result.bus                                                                                          |';
 t2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 t3  =  '   |        Column        |                                      Description                                       |';
 t4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 t5  =  '   |           1          |  estimated bus complex voltages                                                        |';
 t6  =  '   |           2          |  bus apparent power injections                                                         |';
 t7  =  '   |           3          |  shunt apparent powers                                                                 |'; 
 t8  =  '   |----------------------|----------------------------------------------------------------------------------------|';

 s0 =   '   |---------------------------------------------------------------------------------------------------------------|'; 
 s1 =   '   | Variable: result.branch                                                                                       |';
 s2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 s3  =  '   |        Column        |                                      Description                                       |';
 s4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 s5  =  '   |           1          |  branch line currents at from bus end                                                  |';
 s6  =  '   |           2          |  branch line currents at to bus end                                                    |';
 s7  =  '   |           3          |  branch line currents after charging susceptance at from bus end                       |';
 s8  =  '   |           4          |  branch line currents after charging susceptance at to bus end                         |';
 s9  =  '   |           5          |  branch apparent powers at from bus end                                                |';
 s10 =  '   |           6          |  branch apparent powers at to bus end                                                  |';
 s11 =  '   |           7          |  branch apparent powers after charging susceptance at from bus end                     |';
 s12 =  '   |           8          |  branch apparent powers after charging susceptance at to bus end                       |';
 s13 =  '   |           9          |  charging susceptance reactive power injections at from bus end                        |';
 s14 =  '   |          10          |  charging susceptance reactive power injections at to bus end                          |';
 s15 =  '   |          11          |  branch apparent power losses at series impedance                                      |';
 s16 =  '   |----------------------|----------------------------------------------------------------------------------------|'; 
 
 h0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 h1  =  '   | Variable: result.estimate                                                                                     |';
 h2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 h3  =  '   |        Column        |                                      Description                                       |';
 h4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 h5  =  '   |           1          |  measurement values                                                                    |';
 h6  =  '   |           2          |  measurement variances                                                                 |';
 h7  =  '   |           3          |  estimated measurement values                                                          |';
 h8  =  '   |           4          |  units conversion                                                                      |';
 h9  =  '   |           5          |  exact values (if exist)                                                               |';
 h10 =  '   |----------------------|----------------------------------------------------------------------------------------|';

 g0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 g1  =  '   | Variable: result.device                                                                                       |';
 g2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 g3  =  '   |        Column        |                                      Description                                       |';
 g4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 g5  =  '   |           1          |  measurement types                                                                     |';
 g6  =  '   |           2          |  measurement units                                                                     |';
 g7  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 
 k0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 k1  =  '   | Variable: result.bad (from bad data routine)                                                                  |';
 k2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 k3  =  '   |        Column        |                                      Description                                       |';
 k4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 k5  =  '   |           1          |  largest normalized residuals                                                          |';
 k6  =  '   |           2          |  index of suspected bad data measurements                                              |';
 k7  =  '   |----------------------|----------------------------------------------------------------------------------------|';

 p0  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 p1  =  '   |       Variable       |                                      Description                                       |';
 p2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 p3  =  '   |  result.iteration    |  number of iterations                                                                  |';
 p4  =  '   |  result.method       |  name of the solving method                                                            |';
 p5  =  '   |  result.time.pre     |  preprocessing time                                                                    |';
 p6  =  '   |  result.time.con     |  convergence time                                                                      |';
 p7  =  '   |  result.time.pos     |  postprocessing time                                                                   |';
 p8  =  '   |  result.error.mae1   |  mean absolute error between estimated and measurement values                          |';
 p9  =  '   |  result.error.rmse1  |  root mean square error between estimated and measurement values                       |';
 p10 =  '   |  result.error.wrss1  |  weighted residual sum of squares error between estimated and measurement values       |';
 p11 =  '   |  result.error.mae2   |  mean absolute error between estimated and exact values (if exist)                     |';
 p12 =  '   |  result.error.rmse2  |  root mean square error between estimated and exact values (if exist)                  |';
 p13 =  '   |  result.error.wrss2  |  weighted residual sum of squares error estimated and exact values (if exist)          |';
 p14 =  '   |  result.error.mae3   |  mean absolute error between estimated state variables and exact values (if exist)     |';
 p15 =  '   |  result.error.rmse3  |  root mean square error between estimated state variables and exact values (if exist)  |'; 
 p16 =  '   |----------------------|----------------------------------------------------------------------------------------|';

 if ismember('pmu', user)
    se.info = char(l1, '', r1, '', t0, t1, t2, t3, t4, t5, t6, t7, t8, '', ...
                   s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, '', ...
                   h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, '', ...
                   g0, g1, g2, g3, g4, g5, g6, g7, '', ...
                   k0, k1, k2, k3, k4, k5, k6, k7, '', ...
                   p0, p1, p2, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, '', l1);
 end
 
 if ismember('nonlinear', user)
    se.info = char(l1, '', r1, '', t0, t1, t2, t3, t4, t5, t6, t7, t8, '', ...
                   s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, '', ...
                   h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, '', ...
                   g0, g1, g2, g3, g4, g5, g6, g7, '', ...
                   k0, k1, k2, k3, k4, k5, k6, k7, '', ...
                   p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, '', l1);
 end
%--------------------------------------------------------------------------