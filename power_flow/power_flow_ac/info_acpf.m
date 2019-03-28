 function [pf] = info_acpf(pf)

%--------------------------------------------------------------------------
% Forms the info data for AC power flow.
%--------------------------------------------------------------------------
%  Input:
%	- pf: power flow data
%
%  Output:
%	- pf.info: AC power flow info data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-21
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Info AC Power Flow Data--------------------------
 l1 = repmat('-',1,99);

 s1 = ' The AC Power Flow Result Variable Description'; 
 
 t0 =   '   |------------------------------------------------------------------------------------------|'; 
 t1 =   '   | Variable: result.bus                                                                     |';
 t2  =  '   |--------------------|---------------------------------------------------------------------|';
 t3  =  '   |       Column       |                             Description                             |';
 t4  =  '   |--------------------|---------------------------------------------------------------------|';
 t5  =  '   |          1         |  bus complex voltages                                               |';
 t6  =  '   |          2         |  bus apparent power injections                                      |';
 t7  =  '   |          3         |  generation apparent powers                                         |';
 t8  =  '   |          4         |  load apparent powers                                               |';
 t9  =  '   |          5         |  shunt apparent powers                                              |';
 t10 =  '   |          6         |  bus where the minimum limits violated                              |';
 t11 =  '   |          7         |  bus where the maximum limits violated                              |';
 t12 =  '   |--------------------|---------------------------------------------------------------------|';

 g0 =   '   |------------------------------------------------------------------------------------------|'; 
 g1 =   '   | Variable: result.branch                                                                  |';
 g2  =  '   |--------------------|---------------------------------------------------------------------|';
 g3  =  '   |       Column       |                             Description                             |';
 g4  =  '   |--------------------|---------------------------------------------------------------------|';
 g5  =  '   |          1         |  branch line currents at from bus end                               |';
 g6  =  '   |          2         |  branch line currents at to bus end                                 |';
 g7  =  '   |          3         |  branch line currents after charging susceptance at from bus end    |';
 g8  =  '   |          4         |  branch line currents after charging susceptance at to bus end      |';
 g9  =  '   |          5         |  branch apparent powers at from bus end                             |';
 g10 =  '   |          6         |  branch apparent powers at to bus end                               |';
 g11 =  '   |          7         |  branch apparent powers after charging susceptance at from bus end  |';
 g12 =  '   |          8         |  branch apparent powers after charging susceptance at to bus end    |';
 g13 =  '   |          9         |  charging susceptance reactive power injections at from bus end     |';
 g14 =  '   |         10         |  charging susceptance reactive power injections at to bus end       |';
 g15 =  '   |         11         |  branch apparent power losses at series impedance                   |';
 g16 =  '   |--------------------|---------------------------------------------------------------------|';

 h1 =   '   |--------------------|---------------------------------------------------------------------|';
 h2 =   '   |      Variable      |                             Description                             |';
 h3  =  '   |--------------------|---------------------------------------------------------------------|';
 h4 =   '   |  result.method     |  name of the solving method                                         |';
 h5 =   '   |  result.iteration  |  number of iterations                                               |';
 h6 =   '   |  result.time.pre   |  preprocessing time                                                 |';
 h7 =   '   |  result.time.con   |  convergence time                                                   |';
 h8 =   '   |  result.time.pos   |  postprocessing time                                                |'; 
 h9 =   '   |--------------------|---------------------------------------------------------------------|';

 pf.info = char(l1, '', s1, '', t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, '', ...
				g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16, '', ...
				h1, h2, h3, h4, h5, h6, h7, h8, h9, '', l1);
%--------------------------------------------------------------------------