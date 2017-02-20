%% System Base Power, Slack Bus (bus and voltage angle value) and Measurement Data Units (power flow, power injection, voltage angle)

 baseMVA = 100;
 slack   = [1 0];
 unit    = {'mega', 'mega', 'deg'};
 
%% Transmission Line Data

 %           1       2         3          4          5
 %        |from|   |to|      |rij|      |xij|      |bsi|
 Line = [    1       2      0.02000    0.10000    0.03000;  %1
             1       5      0.05000    0.25000    0.02000;  %2
             2       3      0.04000    0.20000    0.02500;  %3
             2       5      0.05000    0.25000    0.02000;  %4   
             3       4      0.05000    0.25000    0.02000;  %5
             3       5      0.08000    0.40000    0.01000;  %6
             4       5      0.10000    0.50000    0.07500]; %7    
                  
%% Power Flow Measurement Data

 %           1       2         3       4            5     
 %        |from|   |to|      |Pij|  |on/off|      |std|
 Flow = [    1       2       102.30690  1        1.0000;  %1
             1       5        25.37590  1        1.0000;  %2
             2       3        18.33250  1        1.0000;  %3
             2       5       -14.93180  1        1.0000;  %4
             3       4         1.35560  1        1.0000;  %5     
             3       5       -18.23090  1        1.0000;  %6
             4       5       -14.71900  1        1.0000]; %7
       
%% Power Injection Measurement Data

 %               1         2       3             4         
 %             |bus|     |Pi|   |on/off|       |std|
 Injection = [   1       127.68290  1         1.0000;  %1
                 2       -96.00000  1         1.0000;  %2  
                 3       -35.00000  1         1.0000;  %3  
                 4       -16.00000  1         1.0000;  %4  
                 5        24.00000  1         1.0000]; %5
        
%% Voltage Angle Measurement Data
       
 %           1          2     3            4                      
 %         |bus|      |Ti| |on/off|      |std|       
 Angle = [   1        0.0000  1         0.0100;  %1 
             2       -4.9580  1         0.0100;  %2
             3       -6.9926  1         0.0100;  %3
             4       -6.8283  1         0.0100;  %4
             5       -2.9283  1         0.0100]; %5 
