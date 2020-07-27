if [ -n "$1" ];then version=$1
else version=version00
fi
currentdir=`pwd`
dirlay1=(Generate Run EMCRun Plot InputData)
dirlay2=(touse tousp coule coulp breme bremp)

echo make $version
mkdir ${version}
cd ${version}
for i in `seq 0 4`
do
  mkdir ${dirlay1[i]}
done 

cp ${currentdir}/Plot/* ${currentdir}/${version}/Plot/

for i in `seq 0 5`
do 
  mkdir Generate/${dirlay2[i]}
  mkdir Run/${dirlay2[i]}
  mkdir EMCRun/${dirlay2[i]}
done

#--------------------------------------
#    make file in Generate
#-------------------------------------
nevt=(17000 17000 6000 6000 800 800)
nLineinAEvt=3
for i in `seq 0 5`
do
  cd ${currentdir}/${version}/Generate/${dirlay2[i]}

  #--- splite data-----
  let n=100
  for j in `seq 10`
  do
    InputDate=${currentdir}/${version}/InputData/${dirlay2[i]}.txt
    step=$[ ${nevt[i]}*${nLineinAEvt} ]
    min=$[ $[ ${j}-1 ]*${step}+1 ]
    max=$[ ${j}*${step} ]
    sed -n "${min},${max}p" ${InputDate} > data_${n}.dat
    let n++
  done 
  let n--
  evtlast=`cat data_${n}.dat | wc -l`
  let evtlast=${evtlast}/${nLineinAEvt}
  echo ${dirlay2[i]} ${evtlast}

  #-----make sim-----
  let n=100
  for j in `seq 10`
  do
    file_sim=${currentdir}/${version}/Generate/${dirlay2[i]}/sim_${n}.txt
    cat ${currentdir}/scripts/sim.head > ${file_sim}
    echo "BesRndmGenSvc.RndmSeed = $n;">> ${file_sim}
    echo "RootCnvSvc.digiRootOutputFile=\"r_${n}.rtraw\";" >> ${file_sim}
    cat ${currentdir}/scripts/sim.foot >> ${file_sim}
    sed -i "s/INPUT.dat/data_${n}.dat/g" ${file_sim}
    if [ ${n} -lt 109 ]; then
      sed -i "s/EVENTNUMBER/${nevt[i]}/g" ${file_sim}
    else
      sed -i "s/EVENTNUMBER/${evtlast}/g" ${file_sim}
    fi
    let n++
  done

  #----make rec-----
  let n=100
  for j in `seq 10`
  do 
    file_rec=${currentdir}/${version}/Generate/${dirlay2[i]}/rec_${n}.txt
    cat ${currentdir}/scripts/rec.head > ${file_rec}
    echo "BesRndmGenSvc.RndmSeed = $n;">> ${file_rec}
    echo "EventCnvSvc.digiRootInputFile = {\"r_${n}.rtraw\"};" >> ${file_rec}
    echo "EventCnvSvc.digiRootOutputFile =\"d_${n}.dst\";">> ${file_rec}
    cat ${currentdir}/scripts/rec.foot >> ${file_rec}
    let n++
  done

  #----make sub-----
  let n=100
  for j in `seq 10`
  do
    echo "boss.exe sim_$n.txt > sim_$n.txt.bosslog" > sub_${n}.txt
    echo "boss.exe rec_$n.txt > rec_$n.txt.bosslog" >> sub_${n}.txt
    echo "rm -rf sub_$n.txt.o*" >> sub_${n}.txt
    echo "rm -rf sub_$n.txt.e*" >> sub_${n}.txt
    chmod +x sub_${n}.txt
    let n++
  done
done

#----------------------------
#    make file in run 
#------------=---------------
for i in `seq 0 5`
do
  cd ${currentdir}/${version}/Run/${dirlay2[i]}
  echo "cd ${currentdir}/${version}/Run/${dirlay2[i]}" > sub.txt
  chmod 755 sub.txt
  let n=100
  for j in `seq 10`
  do
    cat ${currentdir}/scripts/run.head > job_${n}.txt
    echo \"${currentdir}/${version}/Generate/${dirlay2[i]}/r_${n}.rtraw\" >> job_${n}.txt
    cat ${currentdir}/scripts/run.mid >> job_${n}.txt
    echo \"${currentdir}/${version}/Generate/${dirlay2[i]}/d_${n}.dst\" >> job_${n}.txt
    cat ${currentdir}/scripts/run.foot >> job_${n}.txt 
    sed -i "s/hist.root/hist_${n}.root/g" job_${n}.txt
    sed -i "s/nt.root/nt_${n}.root/g"  job_${n}.txt
    echo "boss.exe job_${n}.txt > job_${n}.txt.bosslog" >> sub.txt
    let n++
  done
  echo "rm -rf sub.txt.o*" >> sub.txt
  echo "rm -rf sub.txt.e*" >> sub.txt
done

#-----------------------
# make EMC run file
#-----------------------
for i in `seq 0 5`
do
  cd ${currentdir}/${version}/EMCRun/${dirlay2[i]}
  echo "cd ${currentdir}/${version}/EMCRun/${dirlay2[i]}" > sub.txt
  chmod 755 sub.txt
  let n=100
  for j in `seq 10`
  do
    cat ${currentdir}/scripts/runEMC/run.head > job_${n}.txt
    echo \"${currentdir}/${version}/Generate/${dirlay2[i]}/r_${n}.rtraw\" >> job_${n}.txt
    cat ${currentdir}/scripts/runEMC/run.mid >> job_${n}.txt
    echo \"${currentdir}/${version}/Generate/${dirlay2[i]}/d_${n}.dst\" >> job_${n}.txt
    cat ${currentdir}/scripts/runEMC/run.foot >> job_${n}.txt
    sed -i "s/hist.root/hist_${n}.root/g" job_${n}.txt
    sed -i "s/nt.root/nt_${n}.root/g"  job_${n}.txt
    echo "boss.exe job_${n}.txt > job_${n}.txt.bosslog" >> sub.txt
    let n++
  done
  echo "rm -rf sub.txt.o*" >> sub.txt
  echo "rm -rf sub.txt.e*" >> sub.txt
done
