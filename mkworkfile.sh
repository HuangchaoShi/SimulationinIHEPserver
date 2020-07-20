version=version1
currentdir=`pwd`
dirlay1=(Generate Run Plot InputData)
dirlay2=(touse tousp coule coulp breme bremp)

mkdir ${version}
cd ${version}
for i in `seq 0 3`
do
  mkdir ${dirlay1[i]}
done 

for i in `seq 0 5`
do 
  mkdir Generate/${dirlay2[i]}
  mkdir Run/${dirlay2[i]}
done

#--------------------------------------
#    make file in Generate
#-------------------------------------
nevt=(170000 170000 60000 60000 8300 8300)
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
    echo "${currentdir}/${version}/Generate/${dirlay2[i]}/r_${n}.rtraw" >> job_${n}.txt
    cat ${currentdir}/scripts/run.mid >> job_${n}.txt
    echo "${currentdir}/${version}/Generate/${dirlay2[i]}/d_${n}.dst" >> job_${n}.txt
    cat ${currentdir}/scripts/run.foot >> job_${n}.txt 
    sed -i "s/hist.root/hist_${n}.root/g" job_${n}.txt
    sed -i "s/nt.root/nt_${n}.root/g"  job_${n}.txt
    echo "boss.exe tous_job${n}.txt > tous_job${id}.txt.bosslog" >> sub.txt
    let n++
  done
done


