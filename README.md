# occupational-module

This repository provides the implementation of the QMRA model corresponding to the occupational module, 
intended to quantify the occupational exposure of ESBL producing E. coli to workers in farm-to-fork broiler 
production chain.

## Directory layout

There are several subdirectors in this repository:

* [`data-input`](./data-input/) contains excel files with fixed and estimated input parameters metadata. 
* [`docs`](./docs/) provides documentaion and  ppts. 
* [`results`](./results/) provides scripts for hygiene intervention benchmarking and sensitivity analysis. 
* [`utilities`](./docs/) provides scripts containing utility functions and visualization. 

The roles of the scripts in this repository:

* [`contact_module.R`](./contact_module.R): implements contact module.
* [`farm_to_fork_module.R`](./farm_to_fork_module.R): script to call farm and foodborne modules.
* [`hygiene_module.R`](./hygiene_module.R): implements hygiene module.
* [`risk_module.R`](./risk_module.R): implements hazard characterization.
* [`run_occupational_module.R`](./run_occupational_module.R): simulates user defined batches of production.

## Related resources

Bibliographic resources for this work can be found in this 
[repository](https://github.com/ENVIRE-JPIAMR/bibliography/tree/main/occupational-module).