mol new 3wu2.pdb
set pro [atomselect top all]
set chain [lsort -unique [$pro get chain]]
echo $chain
set num 0
set num2 0
foreach i $chain {
	#echo $i
	set num [expr $num + 1]
	set num2 [expr $num2 +1]
	set chain_pro [atomselect top "chain '$i' and protein"]
	set chain_lig [atomselect top "chain '$i' and (not protein)"]
	#set name [lsort -unique [$chain_pdb get chain]]
	#echo $name
	#echo $i
	$chain_pro writepdb cut/protein/$num\_$i.pdb
	$chain_lig writepdb cut/ligand/$num2\_$i.pdb
	echo $i.pdb
	}
