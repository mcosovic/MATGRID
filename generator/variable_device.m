 function [msr] = variable_device(sys)

%--------------------------------------------------------------------------
% Builds measurement statistics.
%
% The function forms different variables that are used to generate
% measurements, according to different options.
%--------------------------------------------------------------------------
%  Input:
%	- sys: power system data
%
%  Outputs:
%	- msr.w: number of branches
%	- msr.state: number of state variables
%	- msr.total: total number of legacy and phasor measurements
%	- msr.tleg: number of legacy measurements per type
%	- msr.tpmu: number of phasor measurements per type
%	- msr.dleg: number of legacy measurements per device
%	- msr.dpmu: number of phasor measurements per device
%	- msr.mred: maximum redundancy for legacy and phasor measurements
%--------------------------------------------------------------------------
% Created by Mirsad Cosovic on 2019-02-24
% Last revision by Mirsad Cosovic on 2019-03-27
% MATGRID is released under MIT License.
%--------------------------------------------------------------------------


%-------------------------Measurement Statistics---------------------------
 msr.w = sys.Nbr;

 msr.state = 2 * sys.Nbu - 1;
 msr.total = [6 * msr.w + 3 * sys.Nbu; 4 * msr.w + 2 * sys.Nbu];
 msr.tleg  = [2 * msr.w; 2 * msr.w; 2 * msr.w; sys.Nbu; sys.Nbu; sys.Nbu];
 msr.tpmu  = [2 * msr.w; 2 * msr.w; sys.Nbu; sys.Nbu];
 msr.dleg  = [2 * msr.w; 2 * msr.w; sys.Nbu; sys.Nbu];
 msr.dpmu  = sys.Nbu;
 msr.mred  = msr.total ./ msr.state;
%--------------------------------------------------------------------------