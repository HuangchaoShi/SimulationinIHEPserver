version=version1
currentdir=`pwd`
dirlay2=(touse tousp coule coulp breme bremp)
for i in `seq 0 5`
do
  echo check $dirlay2
  let n=100
  cd ${currentdir}/${version}/Generate/${dirlay2[i]}
  for j in `seq 10`
  do
    simSuc=`tail -n 3 sim_${n}.txt.bosslog | grep "Terminated successfully" | wc -l`
    recSuc=`tail -n 3 rec_${n}.txt.bosslog | grep "Terminated successfully" | wc -l`
    if [[ simSuc -eq 0 ]];then 
      echo sim_${n} not success
#      hep_sub -g physics sub_$n.txt
    elif [[ recSuc -eq 0 ]];then
      echo rec_${n} not success, rewrite sub.txt
      echo "boss.exe rec_$n.txt > rec_$n.txt.bosslog" > sub_${n}.txt
      echo "rm -rf sub_$n.txt.o*" >> sub_${n}.txt
      echo "rm -rf sub_$n.txt.e*" >> sub_${n}.txt
#      hep_sub -g physics sub_$n.txt
    fi
    let n++
  done
done
