#!/bin/bash
# draw a scale bar

#chmod 755 draw_scalebar.sh 
# usage is ./draw_scalebar.sh test1.eps 3 nm

#http://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
image_name=$1
scale_label=$2
unit=$3
point_size=$4


border_scale_factor=0.7
text_scale_factor=1.6


echo "$image_name"

image=${image_name%.*}

width=`convert -format "%[fx:w]" $image_name info:`
height=`convert -format "%[fx:h]" $image_name info:`

height_border=`convert -format "%[fx:h*0.15]" $image_name info:`

lsx=`convert -format "%[fx:20*w/100]" $image_name info:`
lex=`convert -format "%[fx:80*w/100]"  $image_name info:`


# 0.7 for border_scale_factor is a valid value
# 1.6 for text sclae factor

ly=`convert -format "%[fx:((100*h)/100) + ($height_border*$border_scale_factor)]"  $image_name info:`
ytext=`convert -format "%[fx:($ly - $height)/$text_scale_factor ]"  $image_name info:`

echo "$height_border"
echo "$width"
echo "$height"
echo "$lsx"
echo "$lex"
echo "$ly"
echo "$ytext"

# add a bar at the bottom
convert -background 'graya(85%, 0.5)'  -gravity south -splice 0x$height_border $image_name $image'_with_border.eps'
convert -stroke black -strokewidth 2 -pointsize $point_size -gravity south -draw "line $lsx,$ly $lex,$ly  text 0,$ytext '$scale_label $unit'" $image'_with_border.eps' $image'_with_scalebar.eps'
