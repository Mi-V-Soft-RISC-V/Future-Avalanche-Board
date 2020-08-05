# Exporting core MiV_RV32IMC_0 to TCL
# Exporting Create design command for core MiV_RV32IMC_CFG1
create_and_configure_core -core_vlnv {Microsemi:MiV:MIV_RV32IMC:2.1.100} -component_name {MiV_RV32IMC_CFG1} -params {\
"AHB_END_ADDR_0:0xffff"  \
"AHB_END_ADDR_1:0x8fff"  \
"AHB_MASTER_TYPE:1"  \
"AHB_SLAVE_MIRROR:true"  \
"AHB_START_ADDR_0:0x0"  \
"AHB_START_ADDR_1:0x8000"  \
"APB_END_ADDR_0:0xffff"  \
"APB_END_ADDR_1:0x7fff"  \
"APB_MASTER_TYPE:1"  \
"APB_SLAVE_MIRROR:false"  \
"APB_START_ADDR_0:0x0"  \
"APB_START_ADDR_1:0x7000"  \
"AXI_END_ADDR_0:0xffff"  \
"AXI_END_ADDR_1:0x6fff"  \
"AXI_MASTER_TYPE:0"  \
"AXI_SLAVE_MIRROR:false"  \
"AXI_START_ADDR_0:0x0"  \
"AXI_START_ADDR_1:0x6000"  \
"DAP_END_ADDR_0:0x4000"  \
"DAP_END_ADDR_1:0x4000"  \
"DAP_START_ADDR_0:0x0"  \
"DAP_START_ADDR_1:0x4000"  \
"DEBUGGER:true"  \
"ECC_ENABLE:false"  \
"FWD_REGS:false"  \
"GEN_DECODE_RV32:3"  \
"GEN_MUL_TYPE:2"  \
"GPR_REGS:false"  \
"INTERNAL_MTIME:true"  \
"INTERNAL_MTIME_IRQ:true"  \
"MTIME_PRESCALER:100"  \
"MTVEC_OFFSET:0x34"  \
"NUM_EXT_IRQS:6"  \
"RESET_VECTOR_ADDR_0:0x0"  \
"RESET_VECTOR_ADDR_1:0x8000"  \
"TCM_DAP_PRESENT:false"  \
"TCM_END_ADDR_0:0x4000"  \
"TCM_END_ADDR_1:0x4000"  \
"TCM_PRESENT:true"  \
"TCM_START_ADDR_0:0x0"  \
"TCM_START_ADDR_1:0x4000"  \
"VECTORED_INTERRUPTS:false"   }
# Exporting core MiV_RV32IMC_0 to TCL done
