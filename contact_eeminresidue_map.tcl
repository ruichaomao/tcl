puts -nonewline "pdb name:\n>"
flush stdout
set pdb_name [gets stdin]
if {0} {
flush stdout
puts -nonewline "contact_distance:\n>"
set contact_dis [gets stdin]
set contact $contact_dis
}
puts -nonewline "pigment name:\n>"
flush stdout
set pigm_name [gets stdin]
mol load pdb $pdb_name
mol modselect 0 top resname $pigm_name and noh
mol modcolor 0 top ColorID 0
set pigm [atomselect top "resname $pigm_name"]
set pigm_list [lsort -unique -integer [$pigm get residue]]
$pigm delete
set filename "dis_ee.dat"
set file [open $filename w]
#unset filename
set num 0
#cycle1
foreach pigm_resid $pigm_list {
	#!!!!!num_dis must be in the top of cycle1
	set num_dis 20
	#puts $pigm_resid
	set num [expr $num + 1]
	puts "------the $num calculating------"
	set pigm [atomselect top "residue $pigm_resid and noh"]
	#puts $pigm
	set atom_list [lsort -unique -integer [$pigm get index]]
	$pigm delete
	#puts $atom_list
	foreach atom_index $atom_list {
		#puts $atom_index
		set atom [atomselect top "index $atom_index"]
		set cord1 [$atom get {x y z}]
		set resn1 [$atom get resname]
		$atom delete
		set cord1_vec [lindex $cord1 0]
		#puts cord1$cord1_vec
		#cycle2
		set pigm2 [atomselect top "resname $pigm_name and same residue as exwithin 10 of residue $pigm_resid"]
		set pigm_list2 [lsort -unique -integer [$pigm2 get residue]]
		$pigm2 delete
		#puts $pigm_list2
		foreach pigm_resid2 $pigm_list2 {
			if {$pigm_resid2 != $pigm_resid} {
				set pigm2 [atomselect top "residue $pigm_resid2 and noh"]
				set atom_list2 [lsort -unique -integer [$pigm2 get index]]
				$pigm2 delete
				foreach atom_index2 $atom_list2 {
					set atom2 [atomselect top "index $atom_index2"]
					set cord2 [$atom2 get {x y z}]
					set resn2 [$atom2 get resname]
					$atom2 delete
					set cord2_vec [lindex $cord2 0]
					#puts cord2$cord2_vec
					set dist [veclength [vecsub $cord2_vec $cord1_vec]]
					if {$dist < $num_dis} {
						set num_dis $dist
						#??????????????????????????
						set pigm_resid11 $pigm_resid
						set pigm_resid22 $pigm_resid2
						set atom_index11 $atom_index
						set atom_index22 $atom_index2
						set resn11 $resn1 
						#$atom delete
						set resn22 $resn2
						#$atom2 delete
						set cord11 $cord1
						set cord22 $cord2
						} ;#else {continue}
					#puts $dist
					}
				}
			}
		}
		puts "the $num drawing-----$resn11$pigm_resid11 and $resn22$pigm_resid22\n"
		puts $file "$num_dis resname$resn11/resid$pigm_resid11/atom$atom_index11 resname$resn22/resid$pigm_resid22/atom$atom_index22"
		graphics top color 1 
		graphics top line [lindex $cord11 0] [lindex $cord22 0] width 3 style dashed
	}
close $file
