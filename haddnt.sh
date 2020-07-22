version=version2
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)
if false;then
  for i in `seq 0 5`
  do
    echo hadd ${dirlay2[i]}
    cd ${currentdir}/${version}/Run/${dirlay2[i]}
    rm all.root
    hadd all.root nt_1*.root
  done
fi

if true;then
  for i in `seq 0 5`
  do
    echo hadd EMC ${dirlay2[i]}
    cd ${currentdir}/${version}/EMCRun/${dirlay2[i]}
    rm all.root
    hadd all.root nt_1*.root
  done
fi
