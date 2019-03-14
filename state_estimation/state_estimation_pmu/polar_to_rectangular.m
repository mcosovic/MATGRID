 function [data] = polar_to_rectangular(data)

%--------------------------------------------------------------------------
% Transforms phasor measurements from polar to rectangular coordinate
% system.
%
% The function transforms current and voltage measurements from PMUs from
% polar to rectangular coordinate system, where we transform all
% measurements. Also, measurement variances are transformed from polar to
% rectangular system, as a result, measurement errors of a single PMU are
% correlated and covariance matrix does not have diagonal form.
%
%  Input:
%	- data: input power system data with measurements
%
%  Outputs:
%	- data.pmu.current with additional columns:
%    (11) real component of the line current phasor measurement;
%    (12) variance of the real component of the line current phasor; 
%    (13) imaginary component of the line current phasor measurement;
%    (14) variance of the imaginary component of the line current phasor; 
%    (15) exact real component of the line current phasor;
%    (16) exact imaginary component of the line current phasor;
%	- data.pmu.voltage with additional columns:
%    (10) real component of the bus voltage phasor measurement;
%    (11) variance of the real component of the bus voltage phasor; 
%    (12) imaginary component of the bus voltage phasor measurement;
%    (13) variance of the imaginary component of the bus voltage phasor; 
%    (14) exact real component of the bus voltage phasor;
%    (15) exact imaginary component of the bus voltage phasor;
%	- data.pmu.Cv: covariance matrix related with current measurements
%	- data.pmu.Vv: covariance matrix related with voltage measurements
%
% The local function which is used in the PMU state estimation.
%--------------------------------------------------------------------------


%--------------------Current Phasor Measurement Data-----------------------
 zm  = data.pmu.current(:,3);
 vm  = data.pmu.current(:,4);
 za  = data.pmu.current(:,6);
 va  = data.pmu.current(:,7);
%--------------------------------------------------------------------------


%-------Current Phasor Measurement Variances to Rectangular System---------
 N = length(zm);
 S = spdiags([vm; va], 0, 2*N, 2*N);

 Rmr = spdiags(cos(za), 0, N, N);
 Rar = spdiags(-zm .* sin(za), 0, N, N);
 Rmi = spdiags(sin(za), 0, N, N);
 Rai = spdiags(zm .* cos(za), 0, N, N);
 R   = [Rmr Rar; Rmi Rai];

 data.pmu.Cv = R * S * R';
%--------------------------------------------------------------------------


%------------Current Phasor Measurement to Rectangular System--------------
 d = full(diag(data.pmu.Cv));
 
 data.pmu.current = [data.pmu.current zm .* cos(za) d(1:N) ...
                     zm .* sin(za) d(N+1:end)];
%--------------------------------------------------------------------------


%------------------------Voltage Phasor Measurement Data-------------------
 zm  = data.pmu.voltage(:,2);
 vm  = data.pmu.voltage(:,3);
 za  = data.pmu.voltage(:,5);
 va  = data.pmu.voltage(:,6);
%--------------------------------------------------------------------------


%-------Voltage Phasor Measurement Variances to Rectangular System---------
 N = length(zm);
 S = spdiags([vm; va], 0, 2*N, 2*N);

 Rmr = spdiags(cos(za), 0, N, N);
 Rar = spdiags(-zm .* sin(za), 0, N, N);
 Rmi = spdiags(sin(za), 0, N, N);
 Rai = spdiags(zm .* cos(za), 0, N, N);
 R   = [Rmr Rar; Rmi Rai];

 data.pmu.Vv = R * S * R';
%--------------------------------------------------------------------------


%------------Voltage Phasor Measurement to Rectangular System--------------
 d = full(diag(data.pmu.Vv));
 data.pmu.voltage = [data.pmu.voltage zm .* cos(za) d(1:N) ...
                     zm .* sin(za) d(N+1:end)];
%--------------------------------------------------------------------------