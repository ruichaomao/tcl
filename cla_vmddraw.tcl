mol new 3jcu.pdb
set filename "distance-yls1.dat"
set fid [open $filename w]
#set mindis 10
set yls [atomselect top "resname CHL CLA"]
set Tyls_id1 [lsort -unique -integer [$yls get residue]]

foreach yls_id1 $Tyls_id1 {
set yls_name [atomselect top "(same residue as within 5 of residue $yls_id1) and (resname CHL CLA)"]
set Tyls_id2 [lsort -unique -integer [$yls_name get residue]]
##wotianjia
set seli [atomselect top "index $yls_id1"]
set cord1 [$seli get {x y z}]

foreach yls_id2 $Tyls_id2 {
set mindis 100
##wotianjia
set selj [atomselect top "index $yls_id2"]
set cord2 [$selj get {x y z}]


if {$yls_id1<$yls_id2} {
#echo $yls_id1
#echo $name

set yls_1 [atomselect top "residue $yls_id1"]
set yls_2 [atomselect top "residue $yls_id2"]

set yls_name1 [lsort -unique [$yls_1 get resname]]
set yls_name2 [lsort -unique [$yls_2 get resname]]

set yls_atom1 [$yls_1 get name]
set yls_atom2 [$yls_2 get name]

set len1 [llength $yls_atom1]
set len2 [llength $yls_atom2]
#echo $len1
#echo $len2
for {set i 0} {$i<$len1} {incr i} {
#echo $i
set nx [lindex [lindex [$yls_1 get {x y z}] $i] 0]
set ny [lindex [lindex [$yls_1 get {x y z}] $i] 1]
set nz [lindex [lindex [$yls_1 get {x y z}] $i] 2]
#echo $nz
	for {set j 0} {$j<$len2} {incr j} {
	#echo $j
	set px [lindex [lindex [$yls_2 get {x y z}] $j] 0]
	set py [lindex [lindex [$yls_2 get {x y z}] $j] 1]
	set pz [lindex [lindex [$yls_2 get {x y z}] $j] 2]
	set dis [expr sqrt(($px - $nx)*($px - $nx)+($py - $ny)*($py - $ny)+($pz -$nz)*($pz - $nz))]
	#echo $dis
	unset px
	unset py
	unset pz
	if {$mindis>$dis} {set mindis $dis} else {continue}
	}
unset nx
unset ny
unset nz
echo $mindis
}
#echo $mindis
} else {continue}

  graphics top line [lindex $cord1 0] [lindex $cord2 0] width 3 style dashed

puts $fid "$mindis  $yls_name1$yls_id1  $yls_name2$yls_id2"
}
#puts $fid "$mindis  $yls_name1$yls_id1  $yls_name2$yls_id2"
}
close $fid
