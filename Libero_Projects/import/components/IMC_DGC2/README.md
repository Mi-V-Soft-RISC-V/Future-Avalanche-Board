## Mi-V Extended Subsystem: DGC2 - Design Guide Configuration 2
Information on the provided Libero SoC v2021.3 DGC2 project is listed here...

### Peripherals map for MIV_ESS DGC2 design

| Peripheral    | Address   |
| ------------- |:-------------:|
| PLIC          | 0x7000_0000   |
| CoreUARTapb   | 0x7100_0000   |
| Timer         | 0x7200_0000   |
| CoreTimer_0   | 0x7300_0000   |
| CoreTimer_1   | 0x7400_0000   |
| CoreGPIO_OUT  | 0x7500_0000   |
| SRAM| 0x8000_0000|

#### Running a Bootloader.elf program for DGC2
The DGC2 design uses the Bootstrap module to copy data into TCM from external I2C EEPROM. The Bootloader.elf file consists of a compiled software project that is capable of writing data from SRC_MEM (LSRAM) to external memory I2C. Please refer to the design guide for more detail on how to run this... Link up  to the baremetal bootloader repository <link>...
    
    1. Open latest version of SoftConsole (v2021.1 and above are supported)
    2. Select 'configure....'
    3. ...
    4. ...
    5. ...
    
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
