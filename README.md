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

The input data are located in the *data_power_grid* direcotry, as the mat-file with the struct variable *data*. The power system data is given in the variable *data.system*, with variables *bus*, *generator*, *line*, *inTransformer*, *shiftTransformer*, and *baseMVA*.  Minimum amount of information with each instance of the data structure to run the module requires *bus* and one of the variables *line*, *inTransformer* and *shiftTransformer*.   
