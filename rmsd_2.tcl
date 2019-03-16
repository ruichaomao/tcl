#mol load parm7 3wu2.prmtop
#mol new 3wu2.prmtop
#mol addfile prod.dcd step 4000 waitfor all #读入轨迹时一定要加waitfor all 否则轨迹每读完就执行后面的命令会出错

set outfile [open rmsd.dat w]
set nf [molinfo top get numframes]
set frame0 [atomselect top "protein and backbone and noh" frame 0]
set sel [atomselect top "protein and backbone and noh"]
# rmsd calculation loop
for {set i 1 } {$i < $nf } { incr i } {
    $sel frame $i
    $sel move [measure fit $sel $frame0]
    puts $outfile "[measure rmsd $sel $frame0]"
}
close $outfile
~               
