version=version1
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)
for i in `seq 0 5`
do
  let n=100
  for j in `seq 0 10`
  do
    cd ${currentdir}/${version}/Generate/${dirlay2[i]}
    hep_sub -g physics sub_$n.txt
    let n++
  done
done
