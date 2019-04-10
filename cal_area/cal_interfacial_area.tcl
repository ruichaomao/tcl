mol new ../pro1.prmtop
mol addfile ../pro1.dcd step 1 waitfor all
set file [open area.dat w]
animate goto 0
set nf [molinfo top get numframes]
set d 1
while {$d <= $nf} {
        set a [atomselect top "residue 1762 to 1774"]
        set b [atomselect top "residue 3586 to 3598"]
        set c [atomselect top "residue 2215 to 2227"]
        set d1 [measure center $a weight mass]
        set d2 [measure center $b weight mass]
        set d3 [measure center $c weight mass]
        set d12 [expr (([veclength [vecsub $d1 $d2]])/10.0)]
        set d13 [expr (([veclength [vecsub $d1 $d3]])/10.0)]
        #set d23 [veclength [vecsub $d2 $d3]]
        set d23 [expr (([veclength [vecsub $d2 $d3]])/10.0)]
        set s [expr ($d12 + $d13 + $d23)/2.0]
        set A [expr sqrt(($s - $d12)*($s - $d13)*($s - $d23))]
        puts "The area is $A Ångstrom"
        puts $file "$A"
        animate goto $d
        #incr $d 1
        set d [expr $d +1]
        $a delete;$b delete;$c delete;unset d1 d2 d3 d12 d13 d23 s A
}
close $file
