# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Dec 19 18:41:58 2023
# Designs open: 1
#   Sim: /home/ICer/luke_verify/lab0/tb1.simv
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: tb1
#   Group count = 4
#   Group Group1 signal count = 0
#   Group Group2 signal count = 17
#   Group Group3 signal count = 18
#   Group Group4 signal count = 20
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-1_Full64
# DVE build date: Oct 12 2018 21:19:11


#<Session mode="Full" path="/home/ICer/luke_verify/lab0/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set -value 1000ns

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{1 38} {1914 868}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}
gui_set_toolbar_attributes -toolbar {S&pecman} -dock_state top
gui_set_toolbar_attributes -toolbar {S&pecman} -offset 0
gui_show_toolbar -toolbar {S&pecman}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 318]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 318
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 317} {height 552} {dock_state left} {dock_on_new_line true} {child_hier_colhier 174} {child_hier_coltype 134} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 327]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 327
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 552
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 326} {height 552} {dock_state left} {dock_on_new_line true} {child_data_colvariable 152} {child_data_colvalue 112} {child_data_coltype 53} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 179]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 179
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 271} {height 179} {dock_state bottom} {dock_on_new_line true}}
set Watch.1 [gui_create_window -type Watch -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 100]
gui_set_window_pref_key -window ${Watch.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Watch.1} -key dock_height -value_type integer -value 100
gui_set_window_pref_key -window ${Watch.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Watch.1} {{left 0} {top 0} {width 431} {height 179} {dock_state bottom} {dock_on_new_line false}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 180]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 180
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1209} {height 179} {dock_state bottom} {dock_on_new_line false}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-ucligui -l run.log +ntb_random_seed=1}}
gui_set_env SIMSETUP::SIMEXE {/home/ICer/luke_verify/lab0/tb1.simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/home/ICer/luke_verify/lab0/tb1.simv}] } {
gui_sim_run Ucli -exe tb1.simv -args {-ucligui -l run.log +ntb_random_seed=1} -dir /home/ICer/luke_verify/lab0 -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1ps
gui_set_time_units 1ns
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {tb1}


set _session_group_6 Group1
gui_sg_create "$_session_group_6"
set Group1 "$_session_group_6"


set _session_group_7 Group2
gui_sg_create "$_session_group_7"
set Group2 "$_session_group_7"

gui_sg_addsignal -group "$_session_group_7" { tb1.ch0_ready tb1.ch0_margin tb1.ch1_ready tb1.ch1_margin tb1.ch2_ready tb1.ch2_margin tb1.mcdt_data tb1.mcdt_val tb1.mcdt_id tb1.clk tb1.rstn tb1.ch0_data tb1.ch0_valid tb1.ch1_data tb1.ch1_valid tb1.ch2_data tb1.ch2_valid }

set _session_group_8 Group3
gui_sg_create "$_session_group_8"
set Group3 "$_session_group_8"

gui_sg_addsignal -group "$_session_group_8" { tb1.clk tb1.rstn tb1.ch0_valid tb1.ch0_ready tb1.ch0_data tb1.ch0_margin tb1.ch1_valid tb1.ch1_ready tb1.ch1_data tb1.ch1_margin tb1.ch2_valid tb1.ch2_data tb1.ch2_margin tb1.ch2_ready tb1.dut.inst_slva_fifo_0.mem tb1.mcdt_data tb1.mcdt_id tb1.mcdt_val }
gui_set_radix -radix enum -signals {Sim:tb1.dut.inst_slva_fifo_0.mem}

set _session_group_9 Group4
gui_sg_create "$_session_group_9"
set Group4 "$_session_group_9"

gui_sg_addsignal -group "$_session_group_9" { tb1.dut.inst_slva_fifo_0.mem tb1.dut.inst_slva_fifo_1.mem tb1.dut.inst_slva_fifo_2.mem tb1.ch2_valid tb1.ch0_valid tb1.ch1_data tb1.ch1_ready tb1.rstn tb1.ch1_margin tb1.ch1_valid tb1.ch0_data tb1.ch0_margin tb1.mcdt_data tb1.clk tb1.ch2_ready tb1.ch0_ready tb1.ch2_data tb1.mcdt_id tb1.mcdt_val tb1.ch2_margin }
gui_set_radix -radix enum -signals {Sim:tb1.dut.inst_slva_fifo_0.mem}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Global: Watch 'Watch'

gui_watch_page_delete -id Watch -all
gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 1}
gui_watch_list_add_expr -id Watch -expr ch0_ready -meta tb1.ch0_ready -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch0_margin[4:0]} -meta tb1.ch0_margin -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr ch1_ready -meta tb1.ch1_ready -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch1_margin[4:0]} -meta tb1.ch1_margin -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr ch2_ready -meta tb1.ch2_ready -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch2_margin[4:0]} -meta tb1.ch2_margin -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {mcdt_data[31:0]} -meta tb1.mcdt_data -type Wire -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr mcdt_val -meta tb1.mcdt_val -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {mcdt_id[1:0]} -meta tb1.mcdt_id -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr clk -meta tb1.clk -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr rstn -meta tb1.rstn -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch0_data[31:0]} -meta tb1.ch0_data -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr ch0_valid -meta tb1.ch0_valid -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch1_data[31:0]} -meta tb1.ch1_data -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr ch1_valid -meta tb1.ch1_valid -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr {ch2_data[31:0]} -meta tb1.ch2_data -type {} -nonlocal -scope tb1

gui_watch_list_add_expr -id Watch -expr ch2_valid -meta tb1.ch2_valid -type {} -nonlocal -scope tb1

gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 2}
gui_watch_page_add -id Watch
gui_watch_page_rename -id Watch -name {Watch 3}

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 1000



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_select -id ${Hier.1} {tb1}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {tb1}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {tb1.ch2_valid tb1.ch0_valid tb1.ch1_data tb1.ch1_ready tb1.rstn tb1.ch1_margin tb1.ch1_valid tb1.ch0_data tb1.ch0_margin tb1.mcdt_data tb1.clk tb1.ch2_ready tb1.ch0_ready tb1.ch2_data tb1.mcdt_id tb1.mcdt_val tb1.ch2_margin }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active tb1 /home/ICer/luke_verify/lab0/tb1.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}

# Watch 'Watch.1'
gui_watch_page_activate -id ${Watch.1} -page {Watch 1}
gui_list_set_filter -id ${Watch.1} -page {Watch 1} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 1} -text {*}
gui_watch_list_scroll_to -id ${Watch.1} -horz 0 -vert 0
gui_watch_page_activate -id ${Watch.1} -page {Watch 2}
gui_list_set_filter -id ${Watch.1} -page {Watch 2} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 2} -text {*}
gui_watch_page_activate -id ${Watch.1} -page {Watch 3}
gui_list_set_filter -id ${Watch.1} -page {Watch 3} -list { {static 1} {randc 1} {public 1} {Parameter 1} {protected 1} {OtherTypes 1} {array 1} {local 1} {class 1} {AllTypes 1} {rand 1} {constraint 1} }
gui_list_set_filter -id ${Watch.1} -page {Watch 3} -text {*}
gui_watch_page_activate -id ${Watch.1} -page {Watch 1}
gui_view_scroll -id ${Watch.1} -vertical -set 0
gui_view_scroll -id ${Watch.1} -horizontal -set 0

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal {tb1.dut.inst_slva_fifo_0.mem[0:31][31:0]} -time 16 -starttime 16
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${Console.1}
}
#</Session>

