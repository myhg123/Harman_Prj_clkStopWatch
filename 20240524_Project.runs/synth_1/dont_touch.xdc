# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: imports/vivado_project/MY_Basys-3-Master.xdc

# IP: ip/ila_0/ila_0.xci
set_property KEEP_HIERARCHY SOFT [get_cells -hier -filter {REF_NAME==ila_0 || ORIG_REF_NAME==ila_0} -quiet] -quiet

# XDC: /home/yoons/vivado_project/Harman_Prj_clkStopWatch/20240524_Project.gen/sources_1/ip/ila_0/ila_v6_2/constraints/ila_impl.xdc
set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==ila_0 || ORIG_REF_NAME==ila_0} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: /home/yoons/vivado_project/Harman_Prj_clkStopWatch/20240524_Project.gen/sources_1/ip/ila_0/ila_v6_2/constraints/ila.xdc
#dup# set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==ila_0 || ORIG_REF_NAME==ila_0} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: /home/yoons/vivado_project/Harman_Prj_clkStopWatch/20240524_Project.gen/sources_1/ip/ila_0/ila_0_ooc.xdc