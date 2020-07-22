version=version2
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)
runMDC=true
runEMC=true

if ( ${runMDC} );then
  for i in `seq 0 5`
  do
    cd ${currentdir}/${version}/Run/${dirlay2[i]}
    hep_sub -g physics sub.txt
  done
fi

if ( ${runEMC} );then
  for i in `seq 0 5`
  do
    cd ${currentdir}/${version}/EMCRun/${dirlay2[i]}
    hep_sub -g physics sub.txt
  done
fi
