#basic representation
menu graphics on
axes location Off
color Display Background white
display depthcue off
#representation
mol modselect 0 top protein
mol modstyle 0 top NewRibbons 0.300000 12.000000 3.000000 0
mol modcolor 0 top ColorID 10
mol modmaterial 0 top Transparent
mol smoothrep top 0 2
mol addrep top
mol modselect 1 top resname RG1
mol modstyle 1 top Lines 1.000000
mol modcolor 1 top ColorID 0
mol smoothrep top 1 1 
mol addrep top
mol modselect 2 top residue 879 875 871 867 863 859 856 888 883
mol modstyle 2 top Licorice 0.100000 12.000000 12.000000
mol modcolor 2 top ColorID 7
mol smoothrep top 2 1 
mol addrep top
mol modselect 3 top resname BCL and not residue 879 875 871 867 863 859 856 888 883
mol modstyle 3 top Licorice 0.100000 12.000000 12.000000
mol modcolor 3 top ColorID 1
mol smoothrep top 3 1 
mol addrep top
mol modselect 4 top name MG
mol modstyle 4 top VDW 0.300000 12.000000
mol modcolor 4 top ColorID 3
mol smoothrep top 4 1 
#display
display resetview
scale by 1.61
rotate z by -70
#render
animate goto start
menu render on
set nf [molinfo top get numframes]
set c 1
set a "ns"
set b "t="
while { $c <= $nf } {
draw color black
graphics top text {-15 0 20} $b$c$a size 3.5
#render snapshot /home/mrc/script/tcl_draw/tcl3_lh2/pic_data/$d.bmp display %s
render TachyonInternal /home/mrc/script/tcl_draw/tcl3_lh2/pic_data3/$c.bmp display %s
draw delete all
animate goto $c
echo $c
set c [expr $c+1]
}
