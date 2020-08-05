set project_folder_name_CFG1 MiV_CFG1_BD
set project_dir_CFG1 "./$project_folder_name_CFG1"
set Libero_project_name_CFG1 PF_Avalanche_ES_MiV_RV32IMC_CFG1_BaseDesign

set project_folder_name_CFG2 MiV_CFG2_BD
set project_dir_CFG2 "./$project_folder_name_CFG2"
set Libero_project_name_CFG2 PF_Avalanche_ES_MiV_RV32IMC_CFG2_BaseDesign

set project_folder_name_CFG3 MiV_CFG3_BD
set project_dir_CFG3 "./$project_folder_name_CFG3"
set Libero_project_name_CFG3 PF_Avalanche_ES_MiV_RV32IMC_CFG3_BaseDesign

set config [string toupper [lindex $argv 0]]
set design_flow_stage [string toupper [lindex $argv 1]]


proc create_new_project_label { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
	puts "Creating a new project for the 'PF_Avalanche_ES' board."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc project_exists { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
	puts "Error: A project exists for the 'PF_Avalanche_ES' with this configuration."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc no_first_argument_entered { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "No 1st Argument has been entered."
	puts "Enter the 1st Argument responsible for type of design configuration -'CFG1..CFGn' " 
	puts "Default 'CFG1' design has been selected."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc invalid_first_argument { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Wrong 1st Argument has been entered."
    puts "Make sure you enter a valid first argument -'CFG1..CFGn'."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc no_second_argument_entered { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "No 2nd Argument has been entered."
	puts "Enter the 2nd Argument after the 1st to be taken further in the Design Flow." 
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc invalid_second_argument { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Wrong 2nd Argument has been entered."
    puts "Make sure you enter a valid 2nd argument -'Synthesize...Export_Programming_File'."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc  base_design_built { }\
{
	puts "\n ---------------------------------------------------------------------------------------------------------"
	puts "BaseDesign built."
	puts "--------------------------------------------------------------------------------------------------------- \n"
}

proc pre_configure_place_and_route { }\
{
	# Configuring Place_and_Route tool for a timing pass.
	configure_tool -name {PLACEROUTE} -params {EFFORT_LEVEL:true} -params {REPAIR_MIN_DELAY:true} -params {TDPR:true} -params {IOREG_COMBINING:true}
}

proc run_verify_timing { }\
{
	run_tool -name {VERIFYTIMING}	
}

if {"$config" == "CFG1"} then {
	if {[file exists $project_dir_CFG1] == 1} then {
		project_exists
	} else {
		create_new_project_label
		new_project -location $project_dir_CFG1 -name $Libero_project_name_CFG1 -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {PolarFire} -die {MPF300T_ES} -package {FCG484} -speed {STD} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT}
		source ./import/components/IMC_CFG1/import_component_and_constraints_pf_avalanche_es_rv32imc_cfg1.tcl
		save_project
        base_design_built
	}
} elseif {"$config" == "CFG2"} then {
	if {[file exists $project_dir_CFG2] == 1} then {
		project_exists
	} else {
		create_new_project_label
		new_project -location $project_dir_CFG2 -name $Libero_project_name_CFG2 -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {PolarFire} -die {MPF300T_ES} -package {FCG484} -speed {STD} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT}
		source ./import/components/IMC_CFG2/import_component_and_constraints_pf_avalanche_es_rv32imc_cfg2.tcl
		save_project
        base_design_built
	}
} elseif {"$config" == "CFG3"} then {
	if {[file exists $project_dir_CFG3] == 1} then {
		project_exists
	} else {
		create_new_project_label
		new_project -location $project_dir_CFG3 -name $Libero_project_name_CFG3 -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {PolarFire} -die {MPF300T_ES} -package {FCG484} -speed {STD} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT}
		source ./import/components/IMC_CFG3/import_component_and_constraints_pf_avalanche_es_rv32imc_cfg3.tcl
		save_project
        base_design_built
	}
} elseif {"$config" != ""} then {
		invalid_first_argument
} else {
	if {[file exists $project_dir_CFG1] == 1} then {
		project_exists
	} else {
		no_first_argument_entered
		create_new_project_label
		new_project -location $project_dir_CFG1 -name $Libero_project_name_CFG1 -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {PolarFire} -die {MPF300T_ES} -package {FCG484} -speed {STD} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT}
		source ./import/components/IMC_CFG1/import_component_and_constraints_pf_avalanche_es_rv32imc_cfg1.tcl
		save_project
        base_design_built
	}
}


if {"$design_flow_stage" == "SYNTHESIZE"} then {
	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Begin Synthesis..."
	puts "--------------------------------------------------------------------------------------------------------- \n"

	pre_configure_place_and_route
    run_tool -name {SYNTHESIZE}
    save_project

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Synthesis Complete."
	puts "--------------------------------------------------------------------------------------------------------- \n"


} elseif {"$design_flow_stage" == "PLACE_AND_ROUTE"} then {

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Begin Place and Route..."
	puts "--------------------------------------------------------------------------------------------------------- \n"

	pre_configure_place_and_route
	run_verify_timing
	save_project

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Place and Route Complete."
	puts "--------------------------------------------------------------------------------------------------------- \n"



} elseif {"$design_flow_stage" == "GENERATE_BITSTREAM"} then {

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Generating Bitstream..."
	puts "--------------------------------------------------------------------------------------------------------- \n"


	pre_configure_place_and_route
	run_verify_timing
    run_tool -name {GENERATEPROGRAMMINGDATA}
    run_tool -name {GENERATEPROGRAMMINGFILE}
    save_project

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Bitstream Generated."
	puts "--------------------------------------------------------------------------------------------------------- \n"



} elseif {"$design_flow_stage" == "EXPORT_PROGRAMMING_FILE"} then {

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Exporting Programming Files..."
	puts "--------------------------------------------------------------------------------------------------------- \n"


	pre_configure_place_and_route
	run_verify_timing
	run_tool -name {GENERATEPROGRAMMINGDATA}
	run_tool -name {GENERATEPROGRAMMINGFILE}

	if {"$config" == "CFG1"} then {
		export_prog_job \
			-job_file_name {PF_Avalanche_ES_MiV_RV32IMC_CFG1_BaseDesign} \
			-export_dir {./MiV_CFG1_BD/designer/BaseDesign/export} \
			-bitstream_file_type {TRUSTED_FACILITY} \
			-bitstream_file_components {}
		save_project
	} elseif {"$config" == "CFG2"} then {
		export_prog_job \
			-job_file_name {PF_Avalanche_ES_MiV_RV32IMC_CFG2_BaseDesign} \
			-export_dir {./MiV_CFG2_BD/designer/BaseDesign/export} \
			-bitstream_file_type {TRUSTED_FACILITY} \
			-bitstream_file_components {}
		save_project
	} else {
		export_prog_job \
			-job_file_name {PF_Avalanche_ES_MiV_RV32IMC_CFG3_BaseDesign} \
			-export_dir {./MiV_CFG3_BD/designer/BaseDesign/export} \
			-bitstream_file_type {TRUSTED_FACILITY} \
			-bitstream_file_components {}
		save_project
	}

	puts "\n ---------------------------------------------------------------------------------------------------------"
    puts "Programming Files Exported."
	puts "--------------------------------------------------------------------------------------------------------- \n"

} elseif {"$design_flow_stage" != ""} then {
	invalid_second_argument
} else {
	no_second_argument_entered
}