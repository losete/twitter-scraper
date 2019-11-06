#!/usr/bin/env bash

echo "Benchmark report" > benchmark_report
echo "--------------------" >> benchmark_report
i="0"
total=0
while [ $i -lt 5 ]
do
    start=`date +%s`
    python3 test.py
    end=`date +%s`
    runtime=$((end-start))
    total=$((total+runtime))
    i=$[$i+1]
    echo " - Time spent job $i: $runtime" >> benchmark_report
done

mean=$((total/5))
echo "--------------------" >> artifact_tmp/reports/benchmark_report
echo "Total time spent ($i jobs): $total" >> artifact_tmp/reports/benchmark_report
echo "Time spent per job: $mean" >> artifact_tmp/reports/benchmark_report
echo "--------------------" >> artifact_tmp/reports/benchmark_report