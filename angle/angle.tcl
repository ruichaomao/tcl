mol new ../../../../1nkz_wm.prmtop
mol addfile ../prod100-200ns.dcd first 20000 last 49999 step 30 waitfor all
set reslist_a {{{201,204} {220,223}} {{107,110} {126,129}} {{13,16} {32,35}} {{789,792} {808,811}} {{6
95,698} {714,717}} {{601,604} {620,623}} {{495,498} {514,517}} {{401,404} {420,423}} {{307,310} {326,3
29}}}
set reslist_b {{{272,275} {246,249}} {{178,181} {152,155}} {{84,87} {58,61}} {{860,863} {834,837}} {{7
66,769} {740,743}} {{672,675} {646,649}} {{566,569} {540,543}} {{472,475} {446,449}} {{378,381} {352,3
55}}}
animate goto 0
set nf [molinfo top get numframes]
puts "#####--->>> $nf frames in total <<<---#####"
set nm [llength $reslist_a]
set d 1
while {$d <= $nm} {
	set file [open angle-N$d.dat w]
	set alpha_chain [lindex $reslist_a [expr $d-1]]
	set beta_chain [lindex $reslist_b [expr $d-1]]
	puts "Will work on the residue $alpha_chain"
	######alpha
	set alpha_Cstart [lindex [split [lindex $alpha_chain 0] ,] 0]
	set alpha_Cend [lindex [split [lindex $alpha_chain 0] ,] 1]
	set alpha_Nstart [lindex [split [lindex $alpha_chain 1] ,] 0]
	set alpha_Nend [lindex [split [lindex $alpha_chain 1] ,] 1]
	#select Centroid atoms of alpha
	set C [atomselect top "residue $alpha_Cstart to $alpha_Cend"]
	set N [atomselect top "residue $alpha_Nstart to $alpha_Nend"]
	######beta
	set beta_Cstart [lindex [split [lindex $beta_chain 0] ,] 0]
	set beta_Cend [lindex [split [lindex $beta_chain 0] ,] 1]
	set beta_Nstart [lindex [split [lindex $beta_chain 1] ,] 0]
	set beta_Nend [lindex [split [lindex $beta_chain 1] ,] 1]
	#select Centroid atoms of beta
	set C_beta [atomselect top "residue $beta_Cstart to $beta_Cend"]
	set N_beta [atomselect top "residue $beta_Nstart to $beta_Nend"]
	set c 1
	while {$c <= $nf} {
		#get Centroid of alpha
		set C_cen [measure center $C]
		set N_cen [measure center $N]
		#get vec of  alpha
		set alpha_vector [vecsub $N_cen $C_cen]
		#get Centroid of beta
		set C_beta_cen [measure center $C_beta]
		set N_beta_cen [measure center $N_beta]
		#get vec of  beta
		set beta_vector [vecsub $C_beta_cen $N_beta_cen]
		#####get the angle of alpha and beta
		set alenth [veclength $alpha_vector]
		set blenth [veclength $beta_vector]
		set dot [vecdot $alpha_vector $beta_vector]
		echo $alenth $blenth $dot
		set angle_ab [expr 57.2958 * acos($dot / ($alenth * $blenth))]	
		puts $angle_ab  
		puts $file "$angle_ab"
		animate goto $c
		set c [expr $c + 1]
	}
	close $file
	set d [expr $d+1]
}
