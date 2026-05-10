# Creating an Elevator Control System using FSM - Verilog

## Project Overview ##
This project features a digital control system for an elevator, implemented using a Finite State Machine (FSM) designed in Verilog. Beyond the physical hardware description, the project includes a dedicated testbench environment to simulate real-world physical transitions, such as floor movement, motor direction control, and door timers.

## Features ##

### Verilog Design
* Built using a Moore FSM architecture.
* Features 5 distinct logical states: `IDLE`, `CLOSE_DOOR`, `MOVE_UP`, `MOVE_DOWN`, and `OPEN_DOOR`.
* Includes a precise internal timer for door control (5-second wait time).

### Automated Testbench
* Instantiates the FSM and provides specific stimuli (button presses, target floors).
* Automatically simulates the physical movement of the cabin between floors using time delays.
* Generates real-time logs in the console to track the elevator's behavior.

## FSM (Finite State Machine) Architecture ##
The logic of the controller is visually represented in the state diagram below. The FSM transitions between states based on internal timers, user input (button presses), and floor comparisons.

![Elevator FSM State Diagram](images/fsm_diagram.svg)

* **IDLE (000):** The elevator is stationary with doors open. It waits for a user request (`button_pressed`).
* **CLOSE_DOOR (001):** The doors close. The FSM compares the `current_floor` with the `target_floor` to determine the direction of travel.
* **MOVE_UP (010):** The motor turns on, and direction is set to UP. The state is maintained until the current floor matches the target.
* **MOVE_DOWN (011):** The motor turns on, and direction is set to DOWN. The state is maintained until the target is reached.
* **OPEN_DOOR (100):** The destination is reached. The motor stops, the doors open, and an internal counter keeps the doors open for roughly 5 seconds before returning to the `IDLE` state.

## Project Structure ##

| Folder/File | Description |
| :---------- | :---------- |
| `src/` | Contains the main hardware circuit module (`Elevator.v`). |
| `sim/` | Contains the simulation testbench (`Elevator_tb.v`). |
| `guide_images/` | Contains visual guides for Vivado setup. |
| `results/` | Contains the State Diagram SVG, screenshots of Waveforms and Tcl Console. |

## How to Run:

* ### Vivado Simulation:
1. Open Vivado Xilinx and create a new project.
2. Add the `.v` files (`Elevator.v` and `Elevator_tb.v`) as simulation sources.
3. **Note on Simulation Time:** The elevator doors are programmed to stay open for 5 seconds. The implicit duration-time of the Vivado simulation (usually 1000ns) won't be enough to see the full FSM cycle return to `IDLE`. 
   * **To fix this:** In Vivado, on the left-side, right-click on `Simulation` -> `Simulation Settings` -> `Simulation` -> `xsim.simulate.runtime` -> set to a higher value (e.g., `6000ms` or simply type `run all` in the Tcl console during simulation). You can find step-by-step tutorial images on how to change the simulation time in the `guide_images` file

* ### Results:
By clicking **Run Simulation** in Vivado, the testbench will automatically execute the scenario. 
The physical floor transitions and door status will be displayed directly in the Tcl Console via `$display` tasks, alongside the detailed signal interactions in the Waveform viewer.

![Wave forms for moving up](results/waveform_M_U.png)
![Tcl Console for moving up](results/Tcl_Console_M_U.png)

* ### Final notes:
* Ensure that your clock period in the testbench matches the physical constraints you want to simulate.
* If you want to test different floor combinations (Ex: Moving down), you will need to chang the following lines of code in the testbench:
* Line 43 -> change c_f to the vallue you want(less than 5).
* Line 44 -> change t_f to the vallue you want(less than 5).
* If you want to test the Moving-Down case, you will also need to change the following lines:
* Line 52 -> dir == 1'b1 change to dir == 1'b0.
* Line 58 -> c_f = c_f + 1'b1 change to c_f - 1'b1.

![Moving-down](guide_images/Moving_Down.png)

![Wave forms for moving down](results/waveform_M_D.png)
![Tcl console for moving down](results/Tcl_Console_M_D.png)

