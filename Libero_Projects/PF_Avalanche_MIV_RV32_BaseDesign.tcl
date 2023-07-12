# Parse user arguments
set config [string toupper [lindex $argv 0]]
set designFlow [string toupper [lindex $argv 1]]
set dieType [string toupper [lindex $argv 2]]

# Get the path of the currently executing script and set execution directory
set scriptPath [info script]
set scriptDir [file dirname $scriptPath]

# Load the TCL file with all of the procedural blocks
source $scriptDir/import/proc_blocks.tcl

# Set valid configurations
set hwPlatform "PF_AVAL"
set hwFamily "POLARFIRE"
set softCpu "MIV_RV32"
set cpuRef "MIV_RV32"
set validConfigs [list "CFG1" "CFG2" "CFG3" "DGC2"]
set validDesignFlows [list "SYNTHESIZE" "PLACE_AND_ROUTE" "GENERATE_BITSTREAM" "EXPORT_PROGRAMMING_FILE"]
set validDieTypes [list "PS" "ES" ""]
set sdName {BaseDesign}
set exProgramHex "miv-rv32i-systick-blinky.hex"

# Call procedures to validate user arguments
set config [verify_config $config]
set designFlow [verify_designFlow $designFlow]
set dieType [verify_dieType $dieType]

# Prime the TCL builder script for desired build settings
set cpuGroup [expr {$softCpu eq "MIV_RV32" ? "MIV_RV32" : "MIV_Legacy"}]
set sdBuildScript [get_config_builder $config $validConfigs $cpuGroup]
get_die_configuration $hwPlatform $dieType
print_message "Runnig script: $scriptPath \nDesign Arguments: $config $designFlow $dieType \nDesign Build Script: $sdBuildScript"

# Configure Libero project files and directories
set projectName "${hwPlatform}[expr {$dieType eq "ES" ? "_${dieType}" : ""}]_${cpuRef}_${config}_${sdName}" ; # projectName only reflects dieType if dieType is "ES"
append projectFolderName [expr { ($dieType eq "PS" ) ? "${cpuRef}_${config}_BD" : "${cpuRef}_${config}_BD_ES"}]
set projectDir $scriptDir/$projectFolderName
puts "Info: projectName: $projectName"
puts "Info: projectFolderName: $projectFolderName"
puts "Info: projectDir: $projectDir"

# Build Libero design project for selected configuration and hardware
if {[file exists $projectDir] == 1} then {
	print_message "Info: Error: A project with '$config' configuration already exists for the '$hwPlatform'."
} else {
	print_message "Info: Creating a new project for the '$hwPlatform' board."
	new_project \
		-location $projectDir \
		-name $projectName \
		-project_description {} \
		-block_mode 0 \
		-standalone_peripheral_initialization 0 \
		-instantiate_in_smartdesign 1 \
		-ondemand_build_dh 1 \
		-hdl {VERILOG} \
		-family {PolarFire} \
		-die $diePackage \
		-package $dieSize \
		-speed $dieSpeed \
		-die_voltage {1.0} \
		-part_range $tempGrade \
		-adv_options {IO_DEFT_STD:LVCMOS 1.8V} \
		-adv_options {RESTRICTPROBEPINS:1} \
		-adv_options {RESTRICTSPIPINS:0} \
		-adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} \
		-adv_options "TEMPR:$tempGrade" \
		-adv_options "VCCI_1.2_VOLTR:$tempGrade" \
		-adv_options "VCCI_1.5_VOLTR:$tempGrade" \
		-adv_options "VCCI_1.8_VOLTR:$tempGrade" \
		-adv_options "VCCI_2.5_VOLTR:$tempGrade" \
		-adv_options "VCCI_3.3_VOLTR:$tempGrade" \
		-adv_options "VOLTR:$tempGrade"
}

# Download the required direct cores
#download_required_direct_cores "$hwPlatform" "$softCpu" "$config"

# Copy the example software program into the project directory (and bootloader elf for DGC1 and DGC2 configs)
file copy -force $scriptDir/import/software_example/$softCpu/$config/hex $projectDir
if {$config in {"DGC1" "DGC2"}} {file copy -force $scriptDir/import/software_example/$softCpu/$config/bootloader_elf $projectDir}

# Import and build the design's SmartDesign
print_message "Info: Building the $sdName..."
source $scriptDir/import/build_smartdesign/$sdBuildScript
print_message "Info: $sdName Built."

# Optimizations - add constraints, modify package files if needed
print_message "Info: Applying Design Optimizations and Constraints..."
source $scriptDir/import/design_optimization.tcl
print_message "Info: Optimization and Constraints Applied."

# Configure 'Place & Route' tool
pre_configure_place_and_route

# Run 'Synthesize' from the design flow
if {"$designFlow" == "SYNTHESIZE"} then {
	print_message "Info: Starting Synthesis..."
    run_tool -name {SYNTHESIZE}
    save_project
	print_message "Info: Synthesis Complete."

# Run 'Place & Route' from the design flow
} elseif {"$designFlow" == "PLACE_AND_ROUTE"} then {
	print_message "Info: Starting Place and Route..."
	run_verify_timing
	save_project
	print_message "Info: Place and Route Completed successfully."

	# Generate Design Initialization Data -- only specific PolarFire Eval TCM designs
	if {($hwFamily == "POLARFIRE") && ($config == "CFG3")} {
		# configure_ram_device "$scriptDir" "$config" "$sdName" "$projectDir"
        puts "Info: This configuration does not include example software prorgam booting from memory after hardware programming."
	}

# Run 'Generate Bitstream' from the design flow
} elseif {"$designFlow" == "GENERATE_BITSTREAM"} then {
	# Generate Design Initialization Data -- only specific PolarFire Eval TCM designs
	if {($hwFamily == "POLARFIRE") && ($config == "CFG3")} {
		# configure_ram_device "$scriptDir" "$config" "$sdName" "$projectDir"
        puts "Info: This configuration does not include example software prorgam booting from memory after hardware programming."
	}
	
	print_message "Info: Generating Bitstream..."
	run_verify_timing
    run_tool -name {GENERATEPROGRAMMINGDATA}
    run_tool -name {GENERATEPROGRAMMINGFILE}
    save_project
	print_message "Info: Bitstream Generated successfully."

# Run 'Export Programming Job File' from the design flow (into default location)
} elseif {"$designFlow" == "EXPORT_PROGRAMMING_FILE"} then {
	print_message "Info: Exporting Programming Files..."

	run_verify_timing

	run_tool -name {GENERATEPROGRAMMINGFILE}
	# Generate Design Initialization Data -- only specific PolarFire Eval TCM designs
	if {($hwFamily == "POLARFIRE") && ($config == "CFG3")} {
		# configure_ram_device "$scriptDir" "$config" "$sdName" "$projectDir"
        puts "Info: This configuration does not include example software prorgam booting from memory after hardware programming."
	}

	export_prog_job \
		-job_file_name $projectName \
		-export_dir $projectDir/designer/$sdName/export \
		-bitstream_file_type {TRUSTED_FACILITY} \
		-bitstream_file_components {}
	save_project
	print_message "Info: Programming Files Exported."

} else {
	print_message "Info: No design flow tool run."
}

# Done