#在终端运行程序，一次性提交多个作业
#130-160ns
mol new ../../../2fkw_wm.prmtop
mol addfile ../../prod100-200ns/prod100-200ns.dcd first 30000 last 59999 step 30 waitfor all
set reslist {{1,11} {96,106} {191,201} {286,296} {381,391} {476,486} {571,581} {666,676} {761,771}}
animate goto 0
set nf [molinfo top get numframes]
puts "#####--->>> $nf frames in total <<<---#####"
set nm [llength $reslist]
set d 1
while {$d <= $nm} {
	set file [open helix-N$d.dat w]
	set c 1
	set f [lindex $reslist [expr $d-1]]
	puts "Will work on the residue $f"
	set resi_start [lindex [split $f ,] 0]
	set resi_end [lindex [split $f ,] 1]
	unset f
	set a [atomselect top "residue $resi_start to $resi_end"]
	unset resi_start resi_end
	set b [lsort -unique [$a get residue]]
	#echo $b
	while {$c <= $nf} {
		set num 0
		foreach resi $b {
			set cal_resi [atomselect top "residue $resi"]
			set sec_stru [lsort -unique [$cal_resi get structure]]
			$cal_resi delete
			#echo $sec_stru
			if { $sec_stru == "G" || $sec_stru == "H" } {set num [expr $num + 1]}
			unset sec_stru
		}
		puts "The number of Helix(alpha or 310) Amino acid in the $c/th frame is $num"
		puts $file "$num"
		animate goto $c
		mol ssrecalc top
		set c [expr $c + 1]
	}
	close $file
	set d [expr $d+1]
	unset c 
}
