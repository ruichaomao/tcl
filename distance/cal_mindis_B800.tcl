#for compute Dis-RG1800
mol new ../../../../../1nkz_wm.prmtop
mol addfile ../../prod100-200ns.dcd first 50000 last 99999 step 50 waitfor all
animate goto 0
set nf [molinfo top get numframes]
puts "#####--->>> $nf frames in total <<<---#####"
set d 1
while {$d <= 9} {
	set c 1
	set file [open helix-N$d.dat w]
	set l_resi1 {289 286 578 583 580 872 877 874 284}
	set l_resi2 {283 288 292 577 582 586 871 876 880}
	#set l_resi2 {{861 862} {865 866} {869 870} {873 874} {877 878} {881 882} {885 887} {855 890} 
{857 858}}
	while {$c <= $nf} {
		echo "The $c/th frame"
		set num1 [lindex $l_resi1 [expr $d-1]]
		set num2 [lindex $l_resi2 [expr $d-1]]
		set add "residue $num1";set bdd "residue $num2"
		unset num1 num2		
		#set porphyrin {name MG CHA CHB CHC CHD NA C1A C2A C3A C4A CMA NB C1B C2B C3B C4B CMB 
CBB NC C1C C2C C3C C4C CMC CAC CBC ND C1D C2D C3D C4D CMD CAD OBD CBD CGD O1D O2D CED CAB OBB}
		set porphyrin {name NB ND}
		set ad [atomselect top "$add and noh"]
		set bd [atomselect top "$bdd and $porphyrin and noh"]
		unset porphyrin
		set atom_list [lsort -unique -integer [$ad get index]]
		set atom_list2 [lsort -unique -integer [$bd get index]]
		puts "$add's atomlist is >> $atom_list"
		puts "$bdd's atomlist is >> $atom_list2"
		$ad delete
		$bd delete
		set num_dis 20
		foreach ad_atomindex $atom_list {
			puts "$add---------->$ad_atomindex"
			set atom [atomselect top "index $ad_atomindex"]
			set cord1 [$atom get {x y z}]
			$atom delete
			set cord1_vec [lindex $cord1 0]
			unset cord1
			foreach bd_atomindex $atom_list2 {
				puts "$bdd--->$bd_atomindex"
				set atom2 [atomselect top "index $bd_atomindex"]
				set cord2 [$atom2 get {x y z}]
				$atom2 delete
				set cord2_vec [lindex $cord2 0]
				unset cord2
				set dist [veclength [vecsub $cord2_vec $cord1_vec]]
				if {$dist < $num_dis} {
					set num_dis $dist
					puts $num_dis
				}
				
			}
			
		}
		unset atom_list atom_list2 cord1_vec cord2_vec
		puts $file $num_dis
		animate goto $c
		set c [expr $c + 1]
		unset dist add bdd  num_dis
	}
	close $file
	set d [expr $d+1]
	unset c l_resi1 l_resi2
}
