# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {{C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.srcs/sources_1/new/L3_P3.v}}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.srcs/constrs_1/imports/EE 460M/Basys3_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/Lab3/L3_P3/EE460M_Lab3_P3.srcs/constrs_1/imports/EE 460M/Basys3_Master.xdc}}]


synth_design -top traffic_FSM -part xc7a35tcpg236-1


write_checkpoint -force -noxdef traffic_FSM.dcp

catch { report_utilization -file traffic_FSM_utilization_synth.rpt -pb traffic_FSM_utilization_synth.pb }
