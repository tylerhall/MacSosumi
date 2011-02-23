# Handy script to un-dereference the symlinks inside Apple's FMIP deviceIcons folder.
# http://serverfault.com/questions/149609/replace-symbolic-link-with-target
find . -type l | while read -r link
do 
    target=$(readlink "$link")
    if [ -e "$target" ]
    then
        rm "$link" && cp "$target" "$link" || echo "ERROR: Unable to change $link to $target"
    else
        # remove the ": # " from the following line to enable the error message
        : # echo "ERROR: Broken symlink"
    fi
done
