# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.srcs/sources_1/new/FullAdder.v}
  {C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.srcs/sources_1/new/Adder4.v}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.srcs/constrs_1/imports/EE 460M/Basys3_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Hyder/Documents/UT/SPRING 2018/EE 460M/EE460M_Lab_0.srcs/constrs_1/imports/EE 460M/Basys3_Master.xdc}}]


synth_design -top Adder4 -part xc7a35tcpg236-1


write_checkpoint -force -noxdef Adder4.dcp

catch { report_utilization -file Adder4_utilization_synth.rpt -pb Adder4_utilization_synth.pb }
