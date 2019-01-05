mol new 2fkw_ini850_opth.pdb
mol new  2fkw_ave850-opth.pdb
axes location Off
color Display Background white
display depthcue off
mol modstyle 0 0 Licorice 0.300000 12.000000 12.000000
mol modcolor 0 0 ColorID 2
mol modstyle 0 1 Licorice 0.300000 12.000000 12.000000
mol modselect 0 0 name MG CHA CHB CHC CHD NA C1A C2A C3A C4A CMA CAA CBA CGA O1A O2A NB C1B C2B C3B C4B CMB CBB NC C1C C2C C3C C4C CMC CAC CBC ND C1D C2D C3D C4D CMD CAD OBD CBD CGD O1D O2D CED CAB OBB
mol modselect 0 1 name MG CHA CHB CHC CHD NA C1A C2A C3A C4A CMA CAA CBA CGA O1A O2A NB C1B C2B C3B C4B CMB CBB NC C1C C2C C3C C4C CMC CAC CBC ND C1D C2D C3D C4D CMD CAD OBD CBD CGD O1D O2D CED CAB OBB
set a [atomselect 0 "name MG CHA CHB CHC CHD NA C1A C2A C3A C4A CMA CAA CBA CGA O1A O2A NB C1B C2B C3B C4B CMB CBB NC C1C C2C C3C C4C CMC CAC CBC ND C1D C2D C3D C4D CMD CAD OBD CBD CGD O1D O2D CED CAB OBB"]
set b [atomselect 1 "name MG CHA CHB CHC CHD NA C1A C2A C3A C4A CMA CAA CBA CGA O1A O2A NB C1B C2B C3B C4B CMB CBB NC C1C C2C C3C C4C CMC CAC CBC ND C1D C2D C3D C4D CMD CAD OBD CBD CGD O1D O2D CED CAB OBB"]
$a move [measure fit $a $b]
display resetview
scale by 1.3
rotate x by  90
menu reder on
set c 1
set d 1
while { $c <= 36 } {
render TachyonInternal /home/mrc/script/tcl/picture/$d.bmp  %s
rotate y by -10
echo $c
set c [expr $c+1]
set d [expr $d+1]
}
