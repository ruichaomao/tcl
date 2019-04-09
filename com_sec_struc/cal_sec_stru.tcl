#在终端运行程序，一次性提交多个作业，计算动力学过程中某几段残基的二级结构变化
#需要手动在脚本里面更改所需计算的残基列表reslist,也可以根据需要更改生成文件的名字
#运行脚本：vmd -dispdev -eof <test.tcl> test.log & 
mol new ../pro1.prmtop
mol addfile ../pro1.dcd step 1 waitfor all
set reslist {{2380,2392}  {3751,3762} {1927,1938}}
animate goto 0
set nf [molinfo top get numframes]
puts "#####--->>> $nf frames in total <<<---#####"
set nm [llength $reslist]
set d 1
while {$d <= $nm} {
	set file [open helics-c$d.dat w]
	set c 1
	set f [lindex $reslist [expr $d-1]]
	puts "Will work on the residue $f"
	set resi_start [lindex [split $f ,] 0]
	set resi_end [lindex [split $f ,] 1]
	set a [atomselect top "residue $resi_start to $resi_end"]
	set b [lsort -unique [$a get residue]]
	#echo $b
	while {$c <= $nf} {
		set num 0
		foreach resi $b {
			set cal_resi [atomselect top "residue $resi"]
			set sec_stru [lsort -unique [$cal_resi get structure]]
			#echo $sec_stru
			if { $sec_stru == "G" || $sec_stru == "H" } {set num [expr $num + 1]}
		}
		puts "The number of Helix(alpha or 310) Amino acid in the $c/th frame is $num"
		puts $file "$num"
		animate goto $c
		mol ssrecalc top
		set c [expr $c + 1]
	}
	close $file
	set d [expr $d+1]
}
