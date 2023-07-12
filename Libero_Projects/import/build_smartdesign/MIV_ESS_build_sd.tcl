# Libero SmartDesign builder script for PolarFire family hardware platforms
# This builder is targetted at the following soft-CPU configurations:
#
# DGC2 MIV_ESS: I2C-Boot
#

#Libero's TCL top level script
#
#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Sourcing the Tcl files for each of the design's components
set cjdRstType [expr {$softCpu eq "MIV_RV32" ? "TRSTN" : "TRST"}]

set sramMemComp "SRC_MEM"
source $scriptDir/import/components/CORERESET_PF_C0.tcl 
source $scriptDir/import/components/PF_CCC_C0.tcl
source $scriptDir/import/components/PF_INIT_MONITOR_C0.tcl 
source $scriptDir/import/components/dgc/COREJTAGDEBUG_C0.tcl 
source $scriptDir/import/components/dgc/MIV_ESS_${config}_C0.tcl 
source $scriptDir/import/components/dgc/${softCpu}_${config}_C0.tcl
source $scriptDir/import/components/dgc/${sramMemComp}_C0.tcl


# Creating SmartDesign BaseDesign
create_smartdesign -sd_name ${sdName}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sdName} -port_name {REF_CLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {BOOTSTRAP_BYPASS} -port_direction {IN} 
sd_create_scalar_port -sd_name ${sdName} -port_name {SYS_RESET_REQ} -port_direction {IN}

sd_create_scalar_port -sd_name ${sdName} -port_name {USER_RST} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {RX} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TX} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {TCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TMS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TRSTB} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDO} -port_direction {OUT}

sd_create_scalar_port -sd_name ${sdName} -port_name {SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sdName} -port_name {SDA} -port_direction {INOUT} -port_is_pad {1}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sdName} -port_name {GPIO_IN} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sdName} -port_name {GPIO_OUT} -port_direction {OUT} -port_range {[3:0]}


# MIV_RV32_DGC(n)_C0 instance setup
sd_instantiate_component -sd_name ${sdName} -component_name "${softCpu}_${config}_C0" -instance_name "${softCpu}_${config}_C0_0"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:JTAG_TDO_DR"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_RESETN"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:TIME_COUNT_OUT"
sd_create_pin_slices -sd_name ${sdName} -pin_name "${softCpu}_${config}_C0_0:MSYS_EI" -pin_slices {[0:1]}
sd_create_pin_slices -sd_name ${sdName} -pin_name "${softCpu}_${config}_C0_0:MSYS_EI" -pin_slices {[2:2]}
sd_create_pin_slices -sd_name ${sdName} -pin_name "${softCpu}_${config}_C0_0:MSYS_EI" -pin_slices {[3:5]}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI\[0:1\]" -value {GND}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI\[3:5\]" -value {GND}
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:JTAG_TDO_DR"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_RESETN"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:TIME_COUNT_OUT"
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_IRQ" -value {GND}


# Add MIV_ESS_DGC(n)_C0 instance
sd_instantiate_component -sd_name ${sdName} -component_name "MIV_ESS_${config}_C0" -instance_name "MIV_ESS_${config}_C0_0"
sd_create_pin_slices -sd_name ${sdName} -pin_name "MIV_ESS_${config}_C0_0:GPIO_IN" -pin_slices {[1:0]}
sd_create_pin_slices -sd_name ${sdName} -pin_name "MIV_ESS_${config}_C0_0:GPIO_IN" -pin_slices {[3:2]}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:GPIO_IN\[3:2\]" -value {GND}
sd_invert_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SYS_RESET_REQ"


# Add CORERESET_PF_C0_0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {CORERESET_PF_C0} -instance_name {CORERESET_PF_C0_0}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:FF_US_RESTORE} -value {GND}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:PLL_POWERDOWN_B}


# Add PF_INIT_MONITOR_C0_0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {PF_INIT_MONITOR_C0} -instance_name {PF_INIT_MONITOR_C0_0}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:PCIE_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:XCVR_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:AUTOCALIB_DONE}


# Add PF_CCC_C0 instance
sd_instantiate_component -sd_name ${sdName}  -component_name {PF_CCC_C0} -instance_name {PF_CCC_C0_0}


# Add Clock Buffer Macro for ref clock
sd_instantiate_macro -sd_name ${sdName} -macro_name {CLKBUF} -instance_name {CLKBUF_0} 


# Add BIBUF_0 instance
sd_instantiate_macro -sd_name ${sdName} -macro_name {BIBUF} -instance_name {BIBUF_0}
sd_invert_pins -sd_name ${sdName} -pin_names {BIBUF_0:E}


# Add BIBUF_1 instance
sd_instantiate_macro -sd_name ${sdName} -macro_name {BIBUF} -instance_name {BIBUF_1}
sd_invert_pins -sd_name ${sdName} -pin_names {BIBUF_1:E}


# Add COREJTAGDEBUG_C0_0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {COREJTAGDEBUG_C0} -instance_name {COREJTAGDEBUG_C0_0}


# Add SRAM component instance
sd_instantiate_component -sd_name ${sdName} -component_name "${sramMemComp}_C0" -instance_name "${sramMemComp}_C0_0"


# Add scalar net connections
sd_connect_pins -sd_name ${sdName} -pin_names "BOOTSTRAP_BYPASS MIV_ESS_${config}_C0_0:BOOTSTRAP_BYPASS" 
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_CPU_ACCESS_DISABLE"
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_TAS_ACCESS_DISABLE"
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_RESETN ${softCpu}_${config}_C0_0:RESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SYS_RESET_REQ SYS_RESET_REQ"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_0:D MIV_ESS_${config}_C0_0:I2C_SDA_O"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_0:E MIV_ESS_${config}_C0_0:I2C_SDA_O_EN"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_0:PAD SDA"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_0:Y MIV_ESS_${config}_C0_0:I2C_SDA_I"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_1:D MIV_ESS_${config}_C0_0:I2C_SCL_O"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_1:E MIV_ESS_${config}_C0_0:I2C_SCL_O_EN"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_1:PAD SCL"
sd_connect_pins -sd_name ${sdName} -pin_names "BIBUF_1:Y MIV_ESS_${config}_C0_0:I2C_SCL_I"

sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:I2C_IRQ ${softCpu}_${config}_C0_0:MSYS_EI\[2:2\]"

# Add scalar net connections
sd_connect_pins -sd_name ${sdName} -pin_names {"CLKBUF_0:Y" "PF_CCC_C0_0:REF_CLK_0"} 
sd_connect_pins -sd_name ${sdName} -pin_names {"CLKBUF_0:PAD" "REF_CLK"}
sd_connect_pins -sd_name ${sdName} -pin_names {"PF_CCC_C0_0:OUT0_FABCLK_0" "CORERESET_PF_C0_0:CLK"}
sd_connect_pins -sd_name ${sdName} -pin_names {"PF_CCC_C0_0:PLL_LOCK_0" "CORERESET_PF_C0_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 ${softCpu}_${config}_C0_0:CLK" 
sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 MIV_ESS_${config}_C0_0:PCLK"
sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 ${sramMemComp}_C0_0:HCLK" 
sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N ${sramMemComp}_C0_0:HRESETN"

sd_connect_pins -sd_name ${sdName} -pin_names {"USER_RST" "CORERESET_PF_C0_0:EXT_RST_N"}
sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N ${softCpu}_${config}_C0_0:RESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N MIV_ESS_${config}_C0_0:PRESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TCK_0 ${softCpu}_${config}_C0_0:JTAG_TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TDI_0 ${softCpu}_${config}_C0_0:JTAG_TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TDO_0 ${softCpu}_${config}_C0_0:JTAG_TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TMS_0 ${softCpu}_${config}_C0_0:JTAG_TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_${cjdRstType}_0 ${softCpu}_${config}_C0_0:JTAG_${cjdRstType}" 
sd_connect_pins -sd_name ${sdName} -pin_names {"CORERESET_PF_C0_0:FPGA_POR_N" "PF_INIT_MONITOR_C0_0:FABRIC_POR_N" }
sd_connect_pins -sd_name ${sdName} -pin_names {"CORERESET_PF_C0_0:INIT_DONE" "PF_INIT_MONITOR_C0_0:DEVICE_INIT_DONE" }
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:UART_RX RX" 
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:UART_TX TX" 

sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TCK TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TDI TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TDO TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TMS TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TRSTB TRSTB"

# Add bus net connections
sd_connect_pins -sd_name ${sdName} -pin_names "GPIO_IN MIV_ESS_${config}_C0_0:GPIO_IN\[1:0\]" 
sd_connect_pins -sd_name ${sdName} -pin_names "GPIO_OUT MIV_ESS_${config}_C0_0:GPIO_OUT" 

# Add bus interface netconnections
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:APB_0_mINITIATOR ${softCpu}_${config}_C0_0:APB_INITIATOR"
sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:AHBL_M_TARGET ${sramMemComp}_C0_0:AHBSlaveInterface"
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_APB_mTARGET ${softCpu}_${config}_C0_0:TAS_APB_TARGET"

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Re-arrange SmartDesign layout
sd_reset_layout -sd_name ${sdName}
# Save the smartDesign
save_smartdesign -sd_name ${sdName}
# Generate SmartDesign BaseDesign
generate_component -component_name ${sdName}
