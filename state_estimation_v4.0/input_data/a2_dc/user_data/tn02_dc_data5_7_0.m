%% System Base Power; Slack Bus (bus and voltage angle value); Number of buses 

 system.baseMVA = 100;
 system.Nbu     = 5;
 system.slack   = [1 0];
 
%% Transmission Line Data

 %                  1       2         3          4          5
 %               |from|   |to|      |rij|      |xij|      |bsi|
 system.line = [    1       2      0.02000    0.10000    0.03000;  %1
                    1       5      0.05000    0.25000    0.02000;  %2
                    2       3      0.04000    0.20000    0.02500;  %3
                    2       5      0.05000    0.25000    0.02000;  %4   
                    3       4      0.05000    0.25000    0.02000;  %5
                    3       5      0.08000    0.40000    0.01000;  %6
                    4       5      0.10000    0.50000    0.07500]; %7    
                  
%% Power Flow Measurement Data

 %                  1       2         3      4         5     
 %               |from|   |to|      |Pij| |on/off|   |std|
 analog.flow = [    1       2       1.0302   1      0.1000;  %1 
                    1       5       0.2807   1      0.1000;  %2 
                    2       3       0.1959   0      0.1000;  %3 
                    2       5      -0.0548   1      0.1000;  %4 
                    3       4      -0.0579   1      0.1000;  %5 
                    3       5      -0.3125   1      0.1000;  %6 
                    4       5      -0.2958   0      0.1000]; %7 
       
%% Power Injection Measurement Data

 %                      1         2     3         4         
 %                    |bus|     |Pi| |on/off|   |std|
 analog.injection = [   1       1.1136  1      0.1000;  %1
                        2      -0.9679  1      0.1000;  %2
                        3      -0.5290  0      0.1000;  %3
                        4      -0.1311  1      0.1000;  %4
                        5       0.1562  0      0.1000]; %5
        
%% Voltage Angle Measurement Data
       
 %                 1          2      3         4                      
 %               |bus|      |Vmi| |on/off|   |std|       
 pmu.voltage = [  1         0.0000   1       10^-5;  %1
                  2        -0.0986   0       10^-5;  %2
                  3        -0.1340   0       10^-5;  %3
                  4        -0.1363   0       10^-5;  %4
                  5        -0.0610   1       10^-5]; %5
              