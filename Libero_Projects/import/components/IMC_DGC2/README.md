## Mi-V Extended Subsystem Design Guide Configuration 2: I2C Write & Boot
Information on the provided Libero SoC v2021.3 DGC2 project is listed here...

#### PF_Avalanche_MIV_RV32_BaseDesign (no ES equivalent)

| Config  | Description|
| :------:|:----------------------------------------|
| DGC2    | This design uses the MIV_RV32 core configured as follows: <ul><li>RISC-V Extensions: IMC</li><li>Multiplier: MACC (Pipelined)</li><li>Interfaces: AHB Master (mirrored), APB3 Master</li><li>Internal IRQs: 6</li><li>TCM: Enabled</li><li>System Timer: Internal MTIME enabled, Internal MTIME IRQ enabled</li><li>Debug: enabled</li></ul>|

**Note:** DGC2 exists strictly with PF_Avalanche_MIV_RV32_BaseDesign (only available for the rev. 3 board with a production silicon device)

## <a name="quick"></a> Instructions

#### Running Libero SoC in GUI mode, with Script Arguments
    a. For running the design in Libero SoC in GUI mode, follow steps 1 to 4 from main readme: <link to the main readme>
    b. In the arguments text box, enter "DGC2 SYNTHESIZE"
    c. Follow step 6 and step 7

In this example, the arguments "DGC2 SYNTHESIZE" are entered to take the project through to Synthesis.

## <a name="Script arguments"></a> Script Arguments
In the examples above the arguments "DGC2" and "DGC2 SYNTHESIZE" were entered. The complete set of script arguments are documented here.

#### First argument:
| Argument                  |  Description   |
| ------------------------- |:---------------|
| DGC2                      | Generate a MIV_ESS example design from the MIV_ESS Design Guide  |

#### Second argument:
| Argument                  |  Description   |
| ------------------------- |:---------------|
| SYNTHESIZE                | Run synthesis on the design  |
| PLACE_AND_ROUTE           | Run place and route on the design  |
| GENERATE_BITSTREAM        | Generate the bitstream for the design|
| EXPORT_PROGRAMMING_FILE   | Export the programming file (.job) |


### Software Provided
There are two programs included with this configuration:
1. 'miv-rv32i-systick-blinky.hex' - A .hex program configured to run from TCM's address (0x4000_0000). The program is initialized in the LSRAM component at 0x8000_0000 and it is accessible over the AHB I/F
    a. The .hex program was generated with 'miv-rv32i-systick-blinky' software project, using the 'mivrv32i-Release' program configuration.
2. 'miv-rv32-ess-bootloader.elf' - An .elf file that can be debugged from TCM @ 0x4000_0000. The program can be used to write data from LSRAM (SRC_MEM) @ 0x8000_0000 to external memory I2C or SPI.
    b. The .elf program was compiled with 'miv-rv32-ess-bootloader.elf' software project, using the 'Bootstrap' program configuration


#### Running a Bootloader.elf program for DGC2
A Bootloader.elf file, a compiled software program is provided with the configuration. Located in the DGC2's Libero project directory after TCL execution. The program can write the blinky program from LSRAM to I2C EEPROM. The MIV_ESS's Bootstrap module can then copy this program from I2C EEPROM to TCM and, allow MIV_RV32 to boot from it. 

Refer to the [Mi-V Soft processor Bare Metal Examples](www.link.link) for more information on the software.
To run the Bootloader.elf program, follow the steps below or refer to the [MIV_ESS Design Guide](www.link.link) for a more detailed instructions:

    1. A DGCn Libero design directory is required to have been created to access the elf. file. The hardware needs to be programmed with DGCn bitstream
    2. Open SoftConsole (v2021.1 above)
    3. From Run > Debug Configurations, double click GDB OpenOCD Debugging
    4. In the Main window, select C/C++ Applications using the Browse button, then navigate to your Libero's project directory ./MIV_DGCn_BD and select the Bootloader.elf file
    5. Select the Debugger tab to set up OpenOCD and GDB
        a. To set up OpenOCD, check the Start OpenOCD locally check box and browse to the OpenOCD path <SoftConsole-install-directory>\openocd\bin\openocd.exe
        b. To set up GDB, browse to the GDB path <SoftConsole-install-directory>\riscv-unknownelf-gcc\bin\riscv64-unknown-elf-gdb.exe.
    6. Click **Apply**
    7. Click Debug to launch the debug session. 

    
### Design Guide Configuration
The project contains MIV_ESS Design Guide configuration design script that uses MIV_ESS companion core.

#### DGC2 - I2C Write & I2C Boot
The Bootstrap and I2C modules are both enabled in this configuration.

##### Features
The Libero designs include the following features:
* A soft RISC-V processor.
* A RISC-V debug block allowing on-target debug using SoftConsole
* An Extended subsystem for peripheral cores (language here?)
* The operating frequency of the design is 50MHz
* Target memory is SRAM/TCM (32kB)
* Options ?:
* User peripherals: MIV_ESS, 2 Timers, 2 GPIO Inputs and 4 GPIO Outputs
* or
* MIV_ESS peripherals (or modules?): I2C, Bootstrap with an TAS APB I/F Writer, UART, 2 GPIO Inputs, 4 GPIO Outputs 

##### Boot Sequence (currently being worked on)
The Bootstrap module is enabled by default in DGC2. By default, it remains in bypass mode after programming the bitstream. Push-button (?) needs to be activated to lift the bypass mode off, allowing for a boot sequence to occur. The boot sequence looks as follows
    * A .hex program generated using the 'miv-rv32i-systick-blinky' software project is stored in the LSRAM component. The program was generated using the 'mivrv32i-Release' configuration.
    * The .hex program has been compiled for 0x4000_0000 

the Bootstrap module to copy data into TCM from external I2C EEPROM. The Bootloader.elf file, a compiled software project that is capable of writing data from SRC_MEM (LSRAM) to external memory I2C. 

##### Peripherals - MIV_ESS

| Peripheral    | Address   |
| ------------- |:-------------:|
| PLIC          | 0x7000_0000   |
| CoreUARTapb   | 0x7100_0000   |
| Timer         | 0x7200_0000   |
| CoreTimer_0   | 0x7300_0000   |
| CoreTimer_1   | 0x7400_0000   |
| CoreGPIO_OUT  | 0x7500_0000   |
| SRAM| 0x8000_0000|


    
##### Choice 1 - Memory Sources
    
| Memory Source    | Address Range             | Size   |
| ---------------- |:-------------------------:| ------:|
| TCM              | 0x4000_0000 - 0x4000_7FFF | 32kB   | 
| LSRAM            | 0x8000_0000 - 0x8000_7FFF | 32kB   |
    
    
### Choice 2 - Memory Sources
    
|CFG  | Memory Source    | Address Range             | Size   | Bootable |
|----:| ---------------- |:-------------------------:| ------:| --------:|
|DGC2 | TCM              | 0x4000_0000 - 0x4000_7FFF | 32kB   | Yes      |
|DGC2 | LSRAM            | 0x8000_0000 - 0x8000_7FFF | 32kB   | Yes      |
