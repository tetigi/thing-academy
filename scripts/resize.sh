 for f in *; do echo $f; convert $f -resize 400x400^ -gravity Center -crop 400x400+0+0 +repage $f; done
