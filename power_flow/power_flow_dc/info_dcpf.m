 function [pf] = info_dcpf(pf)

%--------------------------------------------------------------------------
% Forms the info data for DC power flow.
%--------------------------------------------------------------------------
%  Input:
%	- pf: power flow data
%
%  Output:
%	- pf.info: the DC power flow info data
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-03-25
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Info DC Power Flow Data--------------------------
 l1 = repmat('-',1,59);

 g1 = ' The DC Power Flow Result Variable Description';
 
 t0 =  '   |---------------------------------------------------|'; 
 t1 =  '   | Variable: result.bus                              |';
 t2 =  '   |-------------------|-------------------------------|';
 t3 =  '   |       Column      |          Description          |';
 t4 =  '   |-------------------|-------------------------------|';
 t5 =  '   |          1        |  bus voltage angles           |';
 t6 =  '   |          2        |  bus active power injections  |';
 t7 =  '   |          3        |  generation active powers     |';
 t8 =  '   |-------------------|-------------------------------|';

 h1 =  '   |-------------------|-------------------------------|';
 h2 =  '   |      Variable     |          Description          |';
 h3 =  '   |-------------------|-------------------------------|';
 h4 =  '   |  result.branch    |  branch active power flows    |';
 h5 =  '   |  result.method    |  name of the solving method   |';
 h6 =  '   |  result.time.pre  |  preprocessing time           |';
 h7 =  '   |  result.time.con  |  convergence time             |';
 h8 =  '   |  result.time.pos  |  postprocessing time          |'; 
 h9 =  '   |-------------------|-------------------------------|';
 
 pf.info = char(l1, '', g1, '', t0, t1, t2, t3, t4, t5, t6, t7, t8, '', ...
				h1, h2, h3, h4, h5, h6, h7, h8, h9, '', l1);
%--------------------------------------------------------------------------