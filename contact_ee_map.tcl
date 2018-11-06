puts -nonewline "pdb name:\n>"
flush stdout
set pdb_name [gets stdin]
flush stdout
puts -nonewline "contact_distance:\n>"
set contact_dis [gets stdin]
set contact $contact_dis
mol load pdb $pdb_name
mol modselect 0 top resname BCL
set pigm [atomselect top "resname BCL"]
set pigm_list [lsort -unique -integer [$pigm get resid]]
$pigm delete
set filename "dis_ee.dat"
set file [open $filename w]
#unset filename
set num 0
#cycle1
foreach pigm_resid $pigm_list {
	#puts $pigm_resid
	set num [expr $num + 1]
	puts "the calculating BCL num is $num"
	set pigm [atomselect top "resid $pigm_resid"]
	#puts $pigm
	set atom_list [lsort -unique -integer [$pigm get index]]
	$pigm delete
	#puts $atom_list
	foreach atom_index $atom_list {
		#puts $atom_index
		set atom [atomselect top "index $atom_index"]
		set cord1 [$atom get {x y z}]
		$atom delete
		set cord1_vec [lindex $cord1 0]
		#puts cord1$cord1_vec
		#cycle2
		set pigm2 [atomselect top "resname BCL and same resid as exwithin 12 of resid $pigm_resid"]
		set pigm_list2 [lsort -unique -integer [$pigm2 get resid]]
		$pigm2 delete
		#puts $pigm_list2
		foreach pigm_resid2 $pigm_list2 {
			if {$pigm_resid2 != $pigm_resid} {
				set pigm2 [atomselect top "resid $pigm_resid2"]
				set atom_list2 [lsort -unique -integer [$pigm2 get index]]
				$pigm2 delete
				foreach atom_index2 $atom_list2 {
					set atom2 [atomselect top "index $atom_index2"]
					set cord2 [$atom2 get {x y z}]
					$atom2 delete
					set cord2_vec [lindex $cord2 0]
					#puts cord2$cord2_vec
					set dist [veclength [vecsub $cord2_vec $cord1_vec]]
					#puts $dist
					if {$dist < $contact} {
						puts $file "$dist resid$pigm_resid atom$atom_index resid$pigm_resid2 atom$atom_index2"
						graphics top line [lindex $cord1 0] [lindex $cord2 0] width 3 style dashed
					}
					
				}
			}
			
		}
		
	}


}
close $file
