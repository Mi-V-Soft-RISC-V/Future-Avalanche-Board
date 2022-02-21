## Mi-V Extended Subsystem Design Guide Configuration 2: I2C Write & Boot
Information on the provided Libero SoC v2021.3 DGC2 project is listed here...

#### PF_Avalanche_MIV_RV32_BaseDesign (no ES equivalent)

| Config  | Description|
| :------:|:----------------------------------------|
| DGC2    | This design uses the MIV_RV32 core configured as follows: <ul><li>RISC-V Extensions: IMC</li><li>Multiplier: MACC (Pipelined)</li><li>Interfaces: AHB Master (mirrored), APB3 Master</li><li>Internal IRQs: 6</li><li>TCM: Enabled</li><li>System Timer: Internal MTIME enabled, Internal MTIME IRQ enabled</li><li>Debug: enabled</li></ul>|

**Note:** This design configuration is only available for the  Polar Fire Avalanche Kit (Revision 3 with production silicon devices). 

## <a name="quick"></a> Instructions

#### Running Libero SoC in GUI mode, with Script Arguments
    1. Open Libero SoC
    2. Execute the selected script, Project -> Execute Script
    3. Select the directory that the script is located in, using the "..."
    4. Select the script and select "Open"
    5. In the arguments text box, enter "DGC2 SYNTHESIZE"
    6. Select the "Run" button to execute the script
    7. Once complete, a script report will be generated.

In this example, the arguments "DGC2 SYNTHESIZE" are entered to take the project through to Synthesis.

Libero executes the script and opens the Mi-V sample project. The script adds Timing constraints to the project for Synthesis, Place and Route, and Timing Verification. Additionally, IO Constraints are added to the project for Place and Route. The project can now be taken through the remainder of the Libero SoC design flow.

## <a name="Script arguments"></a> Script Arguments
The complete set of script arguments are documented here.

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
* **miv-rv32i-systick-blinky.hex**: A Hex program configured to run from TCM's address (0x4000_0000). The program is initialized in the LSRAM component at 0x8000_0000 and it is accessible over the AHB interface.
    > The example hex program was created using  miv-rv32i-systick-blinky in release mode (mivrv32i-Release).
* **miv-rv32-ess-bootloader.elf**: The supplied elf file is used to copy data from the LSRAM (SRC_MEM) @0x8000_0000 to external flash memory connected to either  I2C or SPI.
    > The .elf program was compiled using 'miv-rv32-ess-bootloader' in Bootstrap mode.


#### Running a Bootloader .elf program for DGC2
The provided program, *miv-rv32-ess-bootloader.elf* , is available in the Libero project folder after the *create_project* .tcl script has been run for the Design Configuration 2 (DGC2). The program can be used to transfer a program stored in LSRAM to an external I2C EEPROM. The MIV_ESS can then copy the code to the MIV_RV32 Tightly Coupled Memory (TCM), then the MIV_RV32 can boot the copied code.

The sources are available from the [Mi-V Soft processor Bare Metal examples](www.link.link)
To run the Bootloader .elf program, follow the steps below or refer to the [MIV_ESS Design Guide](www.link.link) for more detailed instructions:
> A DGC2 Libero design directory is required to have been created to access the .elf file. The hardware needs to be programmed with DGC2 bitstream

    1. Open SoftConsole (v2021.1 above)
    2. From Run > Debug Configurations, double click GDB OpenOCD Debugging
    3. In the Main window, select C/C++ Applications using the Browse button, then navigate to your Libero's project directory ./MIV_DGC2_BD and select the Bootloader .elf file
    4. Select the Debugger tab to set up OpenOCD and GDB
        a. To set up OpenOCD, check the Start OpenOCD locally check box and browse to the OpenOCD path <SoftConsole-install-directory>\openocd\bin\openocd.exe
        b. To set up GDB, browse to the GDB path <SoftConsole-install-directory>\riscv-unknownelf-gcc\bin\riscv64-unknown-elf-gdb.exe.
    5. Click **Apply**
    6. Click Debug to launch the debug session. 

    
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
* User peripherals: MIV_ESS, 2 Timers, 2 GPIO Inputs and 4 GPIO Outputs **REVIEW THIS** 
* User peripherals: MIV_ESS, CoreTimer **REVIEW THIS** 
* MIV_ESS peripherals: I2C, Bootstrap, UART, 2 GPIO Inputs, 4 GPIO Outputs **REVIEW THIS** 

##### Boot Sequence (currently being worked on)
The Bootstrap module is enabled by default in DGC2. By default, it remains in bypass mode after programming the bitstream. Push-button (?) needs to be activated to lift the bypass mode off, allowing for a boot sequence to occur. The boot sequence looks as follows
    * A .hex program generated using the 'miv-rv32i-systick-blinky' software project is stored in the LSRAM component. The program was generated using the 'mivrv32i-Release' configuration.
    * The .hex program has been compiled for 0x4000_0000 

the Bootstrap module to copy data into TCM from external I2C EEPROM. The Bootloader .elf file, a compiled software project that is capable of writing data from SRC_MEM (LSRAM) to external memory I2C. 

##### Peripherals - MIV_ESS

| Peripheral                       | Address Start | Address End    |
| ------------------------------:  |:-------------:|:--------------:|
| PLIC                             | 0x7000_0000   | 0x70FF_FFFF    |
| CoreUARTapb                      | 0x7100_0000   | 0x71FF_FFFF    |
| Timer                            | 0x7200_0000   | 0x72FF_FFFF    |
| CoreTimer_0 / MIV_ESS_APBSLOT3   | 0x7300_0000   | 0x73FF_FFFF    |
| CoreTimer_1 / MIV_ESS_APBSLOT4   | 0x7400_0000   | 0x74FF_FFFF    |
| CoreGPIO_OUT                     | 0x7500_0000   | 0x75FF_FFFF    |
| SPI                              | 0x7600_0000   | 0x76FF_FFFF    |
| uDMA                             | 0x7800_0000   | 0x78FF_FFFF    |
| WDOG                             | 0x7900_0000   | 0x79FF_FFFF    |
| I2C                              | 0x7A00_0000   | 0x7AFF_FFFF    |
| MIV_ESS_APBSLOTB_BASE            | 0x7B00_0000   | 0x7BFF_FFFF    |
| MIV_ESS_APBSLOTC_BASE            | 0x7C00_0000   | 0x7CFF_FFFF    |
| MIV_ESS_APBSLOTD_BASE            | 0x7D00_0000   | 0x7DFF_FFFF    |
| MIV_ESS_APBSLOTE_BASE            | 0x7E00_0000   | 0x7EFF_FFFF    |
| MIV_ESS_APBSLOTF_BASE            | 0x7F00_0000   | 0x7FFF_FFFF    |
    
##### Memory Sources
    
| Memory Source                    | Address Start | Address End | Size   |
| -------------------------------: |:-------------:|:-----------:|:------:|
| TCM                              | 0x4000_0000   | 0x4000_7FFF | 32kB   | 
| LSRAM                            | 0x8000_0000   | 0x8000_7FFF | 32kB   |


