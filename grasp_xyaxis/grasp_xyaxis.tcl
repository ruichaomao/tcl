mol new ../../../../../1nkz_wm.prmtop
mol addfile ../../270k_imaged_0.1ns_step.dcd first 3000 last 3999 step 1 waitfor all
animate goto 0
proc getxy {id} {
    set xy_list {}
    foreach i $id {
        #echo $i
        set a [atomselect top "index $i"]
        set b [$a get {x y z}]
        #echo $b
        set c [lindex $b 0 0]
        #echo $c
        lappend xy_list $c
    }
    lappend xy_list "---"
    foreach i $id {
        #echo $i
        set a [atomselect top "index $i"]
        set b [$a get {x y z}]
        #echo $b
        set c [lindex $b 0 1]
        #echo $c
        lappend xy_list $c
    }
    return $xy_list
    }

set nf [molinfo top get numframes]
set filename "xy.dat"
set file [open $filename w]
for {set i 1} {$i <= $nf} {incr i} {
    #set xydata [getxy {11774 16607 17263 17801 4553 5209 5747 10580 11236}]
    set xydata [getxy {4413 4811 5069 5467 5607 5887 10440 10838 11096 11494 11634 11914 16467 16865 17123 17521 17661 17941}]

    puts $file $xydata
    animate goto $i
    }
close $file
