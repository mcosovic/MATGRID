# PowerMarieEdu

The software package provides the solution of the AC and DC power flow, the non-linear and DC state estimation, as well as the state estimation with PMUs, with built-in measurements generator.

## Modules

There are three basic modules:
   - **power flow** - using the executive m-file *power_flow.m* runs the AC and DC power flow;
   - **state estimation** - using the executive m-file *state_estimation.m* runs the non-linear, DC and PMU state estimation;
   - **state estimation with built-in measurments generator** - using the executive m-file *power_estimation.m* runs the AC power flow, generates a set of measurements and continues with the state estimation.
   
Note: The state estimation with PMUs is currently not available.

## Power Flow
### Input Data

The input data are located in the *data_power_grid* directory, as the mat-file with the struct variable *data*. The power system data is given in the variable *data.system*, with variables *bus*, *generator*, *line*, *inTransformer*, *shiftTransformer*, and *baseMVA*.  The minimum amount of information with each instance of the data structure to run the module requires *bus* and one of the variables *line*, *inTransformer* and *shiftTransformer*. In the following, we describe the structure of the variable *data.system*.
   - **data.system.bus** with columns: (1) bus number; (2) bus type; (3) initial voltage magnitude; (4) initial voltage angle; (5) load real power injection; (6) load reactive power injection; (7) conductance of the shunt element; (8) susceptance of the shunt element; (9) minimum voltage magnitude; (10) maximum voltage magnitude 
   - **data.system.generator** with columns: (1) bus number; (2) generator real power injection; (3) generator reactive power injection; (4) minimum reactive power injection; (5) maximum reactive power injection; (6) voltage magnitude; (7) on/off status
   - **data.system.line** with columns: (1) from bus number; (2) to bus number; (3) transmission line resistance; (4) transmission line reactance; (5) total transmission line charging susceptance; (6) on/off status 
   - **data.system.inTransformer** with columns: (1) from bus number; (2) to bus number; (3) in-phase transformer resistance; (4) in-phase transformer reactance; (5) total in-phase transformer charging susceptance; (6) turns ratio (7) on/off status
   - **data.system.shiftTransformer** with columns: (1) from bus number; (2) to bus number; (3) phase-shifting transformer resistance; (4) phase-shifting transformer reactance; (5) total phase-shifting charging susceptance; (6) turns ratio; (7) shift angle; (8) on/off status 
   - **data.system.baseMVA**: system base power

Note that all quantities related to the power always should be given in (MVA), (MVAr) or (MW), magnitudes are in (p.u.), while angles should be given in (degree), conductance, susceptance, resistance, and reactance are also in (p.u.).

### User Options
<p align="center">
<img src="/doc/figures/power_flow_chart.png" scale="1">
</p>

The power flow user options should be defined using variable *flow*, in the following form:
  1. **flow.grid**: name of the mat-file that contains power system data
      * example: flow.grid = 'ieee300_411';
  2. **flow.module**: AC or DC power flow
      * flow.module = 1 - AC power flow
      * flow.module = 2 - DC power flow
  3. **flow.reactive** and **flow.voltage**: forces reactive power and voltage magnitude constraints
      * flow.reactive = 1 - on
      * flow.voltage = 1 - on      
  4. **flow.bus** and **flow.branch**: display
      * flow.bus = 1 - on      
      * flow.branch = 1 - on        
   5. **flow.save**: write display data to a text file
      * flow.save = 1 - on        
      
## State Estimation
### Input Data
The input data are located in the *data_power_grid* directory, as the mat-file with the struct variable *data*. The state estimation module, except measurement data, requires quantities that describes the physical structure of the power system, and those are located in variable *data.system*.

Measurement data is given in variables *data.legacy* and *data.pmu*, with variables *flow*, *current*, *injection*, *voltage* for legacy measurements, and *current*, *voltage* for phasor measurement units (PMUs). The minimum amount of information with each instance of the data structure to run the module requires one of the types of measurements (e.g., *data.legacy.flow*) . In the following, we describe the structure of the variables *data.legacy* and *data.pmu*.
  - **data.legacy.flow** with columns: (1) from bus number; (2) to bus number; (3) active power flow measurement; (4) active power flow variance; (5) on/off status; (6) reactive power flow measurement; (7) reactive power flow variance; (8) on/off status; (9) active power flow exact value (optional); (10) reactive power flow exact value (optional) 
  - **data.legacy.current** with columns: (1) from bus number; (2) to bus number; (3) line current magnitude measurement; (4) line current magnitude variance; (5) on/off status; (6) line current magnitude exact value (optional)
  - **data.legacy.injection** with columns: (1) bus number; (2) active power injection measurement; (3) active power injection variance; (4) on/off status; (5) reactive power injection measurement; (6) reactive power injection variance; (7) on/off status; (8) active power injection exact value (optional); (9) reactive power injection exact value (optional)   
  - **data.legacy.voltage** with columns: (1) bus number; (2) bus voltage magnitude measurement; (3) bus voltage magnitude variance; (4) on/off status; (6) bus voltage magnitude exact value (optional) 
  - **data.pmu.current** with columns: (1) from bus number; (2) to bus number; (3) line current magnitude measurement; (4) line current magnitude variance; (5) on/off status; (6) line current angle measurement; (7) line current angle variance; (8) on/off status; (9) line current magnitude exact value (optional); (10) line current angle exact value (optional)
  - **data.pmu.voltage** with columns: (1) bus number; (2) bus voltage magnitude measurement; (3) bus voltage magnitude variance; (4) on/off status; (5) bus voltage angle measurement; (6) bus voltage angle variance; (7) on/off status; (8) bus voltage magnitude exact value (optional); (9) bus voltage angle exact value (optional).
  
Note that all quantities should be given in (p.u.) or (radian). 

### User Options
<p align="center">
<img src="/doc/figures/state_estimation_chart.png" scale="1">
</p>

The state estimation user options should be defined using variable *estimate*, in the following form:
  1. **estimate.grid**: name of the mat-file that contains power system and measurement data
      * example: estimate.grid = 'ieee300_411';
  2. **estimate.module**: non-linear, PMU or DC state estimation
      * flow.module = 1 - non-linear state estimation
      * flow.module = 2 - state estimation only with PMUs (still in progress)
      * flow.module = 3 - DC state estimation      
  3. **estimate.flat** or **estimate.warm** or **estimate.random**: initialize the Gauss-Newton method (for the non-linear state estimation, see figure with options i1, i2, i3)
      * example: estimate.flat = [0 1] -  same initial values for voltage angles (degree) and magnitudes (p.u.) 
      * flow.warm = 1 - initial point is defined as the one applied in the AC power flow 
      * flow.warm = 2 - initial point is defined using exact values (if exist) 
      * example: estimate.random = [-0.5 0.5 0.95 1.05] - initial point is defined using random perturbation between minimum and maximum values of the voltage angles (degree), and minimum and maximum values of the voltage magnitudes (p.u.)     
  4. **estimate.bus**, **estimate.branch**, **estimate.estimation** and **estimate.evaluation**: display
      * estimate.bus = 1 - on      
      * estimate.branch = 1 - on
      * estimate.estimation = 1 - on      
      * estimate.evaluation = 1 - on       
   5. **estimate.save**: write display data to a text file
      * flow.save = 1 - on 
   6. **estimate.linear**: export the system model (matrix and vectors) for the linear state estimation problems in the variable *data.extras*
      * estimate.linear = 1 - on       

Note that currently phasor measurements are integrated using polar coordinates resulting in the more accurate state estimates in comparison to the rectangular measurement representation, but it requires larger computing time, and causes possible ill-conditioned.  

## State Estimation with Built-in Measurments Generator
