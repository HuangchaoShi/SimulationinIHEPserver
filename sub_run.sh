version=version1
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)
for i in `seq 0 5`
do
  cd ${currentdir}/${version}/Run/${dirlay2[i]}
  hep_sub -g physics sub.txt
done
