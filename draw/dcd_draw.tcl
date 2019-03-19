下面附上一段把动力学轨迹中的每一帧使用ao+TachyonL-OptiX渲染成图片的tcl脚本。这个脚本不能直接用。关键地方我都写上注释，使用时需根据自己的实际情况修改。
--------------------------------------------------------------------------------------------------------------------
mol new {1.gro} type {gro}                                        #这里读入gromcs轨迹
mol addfile {1.trr} type {trr} waitfor all                        #读入轨迹时一定要加waitfor all 否则轨迹每读完就执行后面的命令会出错
###下面绿色的部分是分子样式的设置，根据自己的喜好修改
display resize 1280 720                                              #最后产生图片的尺寸，这里如果像第三部分中那样使用非gui模式的vmd，可以把display的尺寸设置的比实际屏幕大
color Display Background white
display projection Orthographic
display depthcue off
axes location Off
display resetview
rotate x by 90.000000
translate by 0.0 0.5 0.0
mol modselect 0 0 all not resname AAA
mol modmaterial 0 0 Transparent
material change opacity Transparent 0.100000
mol modstyle 0 0 DynamicBonds 1.6 0.200000 30.000000
mol modcolor 0 0 ResName
color Resname BBB silver
color Resname CCC silver
mol addrep 0
mol modselect 1 0 resname AAA
mol modcolor 1 0 Name
mol modstyle 1 0 VDW 0.900000 30.000000
mol modmaterial 1 0 AOShiny
color change rgb 10 0.4500000 0.4500000 0.4510000
###下面红色的部分是开启ao以及ao的参数设置，渲染的速度和需要渲染的分子数量，两个参数的乘积越，以及屏幕分辨率有关
display shadows on
display ambientocclusion on
render aasamples TachyonLOptiXInternal 12
render aosamples TachyonLOptiXInternal 2
###下面的蓝色部分是逐帧渲染的函数
proc make_movie {} {
    set num [molinfo top get numframes]
    # loop through the frames
    for {set i 1} {$i < $num} {incr i} {
        # go to the given frame
        set filename [format "%05d" $i].tga          #这里%05d 的意思就是输出图片的名称是00001.tga，00002tga。。。
        animate goto $i
        display update
        render TachyonLOptiXInternal $filename
        }
}
make_movie              #最后调用函数开始逐帧渲染
--------------------------------------------------------------------------------------------------------------------
渲染完成后，可以使用imagemagick中的mogrify 命令批量修改图片
使用ffmpeg 命令把图片合并成视频文件
使用premiere 后处理视频文件。。
