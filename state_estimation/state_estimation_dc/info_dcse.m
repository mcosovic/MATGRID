 function [se] = info_dcse(se)

%--------------------------------------------------------------------------
% Forms the info data for the DC state estimation.
%--------------------------------------------------------------------------
%  Input:
%	- se: state estimation data
%
%  Output:
%	- se.info: the DC state estimation info data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-04-09
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%----------------------Info DC State Estimation Data-----------------------
 l1 = repmat('-',1,120);

 r1 = ' The DC State Estimation Result Variable Description';

 t0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 t1  =  '   | Variable: result.bus                                                                                          |';
 t2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 t3  =  '   |        Column        |                                      Description                                       |';
 t4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 t5  =  '   |           1          |  estimated bus voltage angles                                                          |';
 t6  =  '   |           2          |  bus active power injections                                                           |';
 t7  =  '   |----------------------|----------------------------------------------------------------------------------------|';

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
 k1  =  '   | Variable: result.bad (bad data processing routine)                                                            |';
 k2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 k3  =  '   |        Column        |                                      Description                                       |';
 k4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 k5  =  '   |           1          |  largest normalized residuals                                                          |';
 k6  =  '   |           2          |  index of suspected bad data measurements                                              |';
 k7  =  '   |----------------------|----------------------------------------------------------------------------------------|';

 q0  =  '   |---------------------------------------------------------------------------------------------------------------|';
 q1  =  '   | Variable: result.observe.{island, branch, injection, flow} (observability analysis routine)                   |';
 q2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 q3  =  '   |        Column        |                                      Description                                       |';
 q4  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 q5  =  '   |           1          |  bus indexes                                                                           |';
 q6  =  '   |           2          |  island indexes                                                                        |';
 q7  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 q8  =  '   |           1          |  from bus ends                                                                         |';
 q9  =  '   |           2          |  to bus ends                                                                           |';
 q10 =  '   |           3          |  indicators: observable branches (1); unobservable branches (0)                        |';
 q11 =  '   |           4          |  indicators: relevant branches (1); irrelevant branches (0)                            |';
 q12 =  '   |----------------------|----------------------------------------------------------------------------------------|';
 q13 =  '   |           1          |  bus numbers                                                                           |';
 q14 =  '   |           2          |  active power injection pseudo-measurements                                            |';
 q15 =  '   |           3          |  active power injection pseudo-measurement variances                                   |';
 q16 =  '   |----------------------|----------------------------------------------------------------------------------------|';
 q17 =  '   |           1          |  from bus ends                                                                         |';
 q18 =  '   |           2          |  to bus ends                                                                           |';
 q19 =  '   |           2          |  active power flow pseudo-measurements                                                 |';
 q20 =  '   |           3          |  active power flow pseudo-measurement variances                                        |';
 q21 =  '   |----------------------|----------------------------------------------------------------------------------------|';


 p0  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 p1  =  '   |       Variable       |                                      Description                                       |';
 p2  =  '   |----------------------|----------------------------------------------------------------------------------------|';
 p3  =  '   |  result.branch       |  branch active power flows                                                             |';
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

 se.info = char(l1, '', r1, '', t0, t1, t2, t3, t4, t5, t6, t7, '', ...
				h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, '', ...
				g0, g1, g2, g3, g4, g5, g6, g7, '', ...
                k0, k1, k2, k3, k4, k5, k6, k7, '', ...
                q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, '', ...
				p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, '', l1);
%--------------------------------------------------------------------------