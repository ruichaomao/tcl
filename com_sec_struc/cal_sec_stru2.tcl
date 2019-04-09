#计算某段蛋白螺旋(H+G)含量
#打开vmd,在vmd中交互式运行
mol new ../pro1.prmtop
mol addfile ../pro1.dcd step 1 waitfor all
puts -nonewline "range of redidues:\n(for example residue 1 to 10:  >>1,10)\n>> "
flush stdout
set resi_range [gets stdin]
#1803,1814 ;#helix-E1.dat
#2380,2391 ;#helix-C1.dat
flush stdout
set aa [split $resi_range ,]
set resi_start [lindex $aa 0]
set resi_end [lindex $aa 1]
puts -nonewline "filename:\n>>"
flush stdout
set filename [gets stdin]
#helix-E1.dat
#helix-C1.dat
#set filename "sec_stru.dat"
set file [open $filename w]
animate goto 0
set nf [molinfo top get numframes]
puts "#####--->>> $nf frames in total <<<---#####"
set c 1
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
