#在终端运行程序，一次性提交多个作业
mol new ../../../2fkw_wm.prmtop
mol addfile ../prod.dcd first 0 last 49999 step 100 waitfor all
set reslist {{1,11} {96,106} {191,201} {286,296} {381,391} {476,486} {571,581} {666,676} {761,771}}
#set reslist {{1,11}}
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
		if {$d ==1} {
			set add "residue 860";set bdd "residue 856 and name MG"
		} elseif {$d ==2} {
			set add "residue 864";set bdd "residue 859 and name MG"
		} elseif {$d ==3} {
			set add "residue 868";set bdd "residue 863 and name MG"
		} elseif {$d ==4} {
			set add "residue 872";set bdd "residue 867 and name MG"
		} elseif {$d ==5} {
			set add "residue 876";set bdd "residue 871 and name MG"
		} elseif {$d ==6} {
			set add "residue 880";set bdd "residue 875 and name MG"
		} elseif {$d ==7} {
			set add "residue 884";set bdd "residue 879 and name MG"
		} elseif {$d ==8} {
			set add "residue 889";set bdd "residue 883 and name MG"
		} elseif {$d ==9} {
			set add "residue 886";set bdd "residue 888 and name MG"
		}
		set ad [atomselect top "$add"]
		set bd [atomselect top "$bdd"]
		set dist [veclength [vecsub  [lindex [measure center $a]] [lindex [$bd get {x y z}] 0]]]
		if {$num <= 3} {puts $file "$num dist:$dist"} else {puts $file "$num dist:  $dist"}	
		animate goto $c
		mol ssrecalc top
		set c [expr $c + 1]
	}
	close $file
	set d [expr $d+1]
}
