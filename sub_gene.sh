if [ -n "$1" ];then version=$1
  else version=version00
fi
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)

echo sub gene $version
for i in `seq 0 5`
do
  let n=100
  echo submit ${dirlay2[i]}
  for j in `seq 10`
  do
    cd ${currentdir}/${version}/Generate/${dirlay2[i]}
    hep_sub -g physics sub_$n.txt
    let n++
  done
done
