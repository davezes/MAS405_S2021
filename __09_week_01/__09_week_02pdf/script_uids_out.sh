
xwdth=470
xhght=540
xca=100
xcb=840
xra=170
xrb=770
xrc=1370

xpage=0

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  105297873.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  405645296.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  704024664.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  505119082.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  005450356.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  103787534.png
xpage=1

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  005645279.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  205645424.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  704443991.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  005220431.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  905636874.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  005445379.png
xpage=2

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  405642052.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  105645245.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  605638501.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  205644467.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  504217404.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  805638208.png
xpage=3

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  005640125.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  405430899.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  404731988.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  705645266.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  604210459.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  005643647.png
xpage=4

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  405179590.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  405649930.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  005449749.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  405645258.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  605473393.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  305542595.png
xpage=5

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  904615627.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xra  image.png  305645249.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  204502172.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrb  image.png  505640627.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrc  image.png  605449001.png
convert -crop $xwdth'x'$xhght'+'$xcb'+'$xrc  image.png  605645295.png
xpage=6

convert -density 200 PhotoRoster-663610200-21S.pdf[$xpage]  image.png

convert -crop $xwdth'x'$xhght'+'$xca'+'$xra  image.png  705450367.png
convert -crop $xwdth'x'$xhght'+'$xca'+'$xrb  image.png  904795181.png


echo -n > __log.tsv
echo 'UID'$'\t''file' >> __log.tsv
for f in *[0-9].png
do
g=${f//[.png]/}
echo $g
echo ${g}$'\t'${f} >> __log.tsv
done
