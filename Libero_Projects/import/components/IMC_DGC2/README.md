## Mi-V Extended Subsystem: DGC2 - Design Guide Configuration 2
Information on the provided Libero SoC v2021.3 DGC2 project is listed here...

#### PF_Avalanche_MIV_RV32_BaseDesign (ES equivalent is not supported) / (strictly)

| Config  | Description|
| :------:|:----------------------------------------|
| DGC2    | This design uses the MIV_RV32 core configured as follows: <ul><li>RISC-V Extensions: IMC</li><li>Multiplier: MACC (Pipelined)</li><li>Interfaces: AHB Master (mirrored), APB3 Master</li><li>Internal IRQs: 6</li><li>TCM: Enabled</li><li>System Timer: Internal MTIME enabled, Internal MTIME IRQ enabled</li><li>Debug: enabled</li></ul>|

**Note:** DGC2 is only available for the rev 3 // production silicon device script

#### Instructions on executing the script in Libero are listed in the main readme <link>
* It might be worth to add them in here as well but, that would be replicating info that is already there
* The main readme might benefit from having DGC2 listed in with the arguments, otherwise it can be listed here

#### First argument:
| Argument                  |  Description   |
| ------------------------- |:---------------|
| DGC2                      | Generate a MIV_ESS example design from the MIV_ESS Design Guide  |

#### Running a Bootloader.elf program for DGC2
The DGC2 design uses the Bootstrap module to copy data into TCM from external I2C EEPROM. The Bootloader.elf file consists of a compiled software project that is capable of writing data from SRC_MEM (LSRAM) to external memory I2C. Please refer to the design guide for more detail on how to run this... Link up  to the baremetal bootloader repository <link>...
    
    1. Open latest version of SoftConsole (v2021.1 and above are supported)
    2. Select 'configure....'
    3. ...
    4. ...
    5. ...

## DGC2 Features
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

### DGC2 Description
The design uses MIV_ESS companion core 

#### Boot Sequence
After programming, by default, the Bootstrap remains in bypass mode...


#### Peripherals map for MIV_ESS DGC2 design

| Peripheral    | Address   |
| ------------- |:-------------:|
| PLIC          | 0x7000_0000   |
| CoreUARTapb   | 0x7100_0000   |
| Timer         | 0x7200_0000   |
| CoreTimer_0   | 0x7300_0000   |
| CoreTimer_1   | 0x7400_0000   |
| CoreGPIO_OUT  | 0x7500_0000   |
| SRAM| 0x8000_0000|

    
### Memory Sources
    
| Memory Source    | Address Range             | Size   |
| ---------------- |:-------------------------:| ------:|
| TCM              | 0x4000_0000 - 0x4000_7FFF | 32kB   | 
| LSRAM            | 0x8000_0000 - 0x8000_7FFF | 32kB   |
    
    
### Or...
    
|CFG  | Memory Source    | Address Range             | Size   | Bootable |
|----:| ---------------- |:-------------------------:| ------:| --------:|
|DGC2 | TCM              | 0x4000_0000 - 0x4000_7FFF | 32kB   | Yes      |
|DGC2 | LSRAM            | 0x8000_0000 - 0x8000_7FFF | 32kB   | Yes      |
