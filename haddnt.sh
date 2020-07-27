if [ -n "$1" ];then version=$1
else version=version00
fi
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)

echo check $version
if true;then
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
