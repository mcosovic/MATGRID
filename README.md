# PowerMarieEdu

The software package provides the solution of the AC and DC power flow, the non-linear and DC state estimation, as well as the state estimation with PMUs, with built-in measurments generator.

## Modules

There are three basic modules:
   - **power flow** - using the executive m-file *power_flow.m* runs the AC and DC power flow;
   - **state estimation** - using the executive m-file *state_estimation.m* runs the non-linear, DC and PMU state estimation;
   - **state estimation with built-in measurments generator** - using the executive m-file *power_estimation.m* runs the AC power flow, generates a set of measurements and continues with the state estimation.
   
Note: The state estimation with PMUs is currently not available.

## Power Flow
1. Input Data

The input data are located in the *data_power_grid* direcotry, as the mat-file with the struct variable *data*. The power system data is given in the variable *data.system*, with variables *bus*, *generator*, *line*, *inTransformer*, *shiftTransformer*, and *baseMVA*.  Minimum amount of information with each instance of the data structure to run the module requires *bus* and one of the variables *line*, *inTransformer* and *shiftTransformer*. In the following, we describe the structure of the variable *data.system*.
   - **data.system.bus** with columns: (1) bus number; (2) bus type; (3) initial voltage magnitude; (4) initial voltage angle; (5) load real power injection; (6) load reactive power injection; (7) conductance of the shunt element; (8) susceptance of the shunt element; (9) minimum voltage magnitude; (10) maximum voltage magnitude 
   - **data.system.generator** with columns: (1) bus number; (2) generator real power injection; (3) generator reactive power injection; (4) minimum reactive power injection; (5) maximum reactive power injection; (6) voltage magnitude; (7) on/off status
   - **data.system.line** with columns: (1) from bus number; (2) to bus number; (3) transmission line resistance; (4) transmission line reactance; (5) total transmission line charging susceptance; (6) on/off status 
   - **data.system.inTransformer** with columns: (1) from bus number; (2) to bus number; (3) in-phase transformer resistance; (4) in-phase transformer reactance; (5) total in-phase transformer charging susceptance; (6) turns ratio (7) on/off status
   - **data.system.shiftTransformer** with columns: (1) from bus number; (2) to bus number; (3) phase-shifting transformer resistance; (4) phase-shifting transformer reactance; (5) total phase-shifting charging susceptance; (6) turns ratio; (7) shift angle; (8) on/off status 
   - **data.system.baseMVA**: system base power

Note that all quantities related to the power always should be given in (MVA), (MVAr) or (MW), magnitudes are in (p.u.), while angles  should be given in (deg), conductance, susceptance, resistance, and reactance are also in (p.u.).

2. User Options
<p align="center">
<img src="https://github.com/mcosovic/my_private/blob/master/power_marie_edu/power_flow_chart.png?raw=true" width="800">
</p>

