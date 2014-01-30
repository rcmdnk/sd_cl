#!/usr/bin/env bash
scripts=(https://raw.github.com/rcmdnk/sd_cl/master/etc/sd_cl)
scripts_dep=(https://raw.github.com/rcmdnk/sentaku/master/bin/sentaku)
if [ x"$prefix" = x ];then
  prefix=/usr/local
fi

prefix=`echo $prefix|sed 's|--prefix=||'|sed "s|^~|$HOME|"|sed "s|^\.|$(pwd)|"`

echo
echo "###############################################"
echo "Install to $prefix/etc"
echo "###############################################"
echo
sudo=""
if [ -d $prefix/etc ];then
  touch $prefix/etc/.install.test >& /dev/null
  if [ $? -ne 0 ];then
    sudo=sudo
  else
    rm -f $prefix/etc/.install.test
  fi
else
  mkdir -p $prefix/etc>&  /dev/null
  if [ $? -ne 0 ];then
    sudo mkdir -p $prefix/etc
    sudo=sudo
  fi
fi

for s in ${scripts[@]};do
  sname=`basename $s`
  echo Intalling ${sname}...
  $sudo curl -fsSL -o $prefix/etc/$sname $s
done

for s in ${scripts_dep[@]};do
  sname=`basename $s`
  if ! type $sname >& /dev/null;then
    echo Intalling ${sname}...
    $sudo curl -fsSL -o $prefix/bin/$sname $s
  fi
done

echo Add following line to your .bashrc/.zshrc:
echo
echo source $prefix/etc/sd_cl
