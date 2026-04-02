#!/bin/bash

echo "scheduler,benchmark,ipc" > /accel-sim/results.csv

for sched in "lrr" "gto" "two_level_rr:8" "lwm:64" "lwm:256" "lwm_two_level:64" "lwm_two_level:256" "lwm_two_level_adaptive:64" "lwm_two_level_adaptive:256"; do
    echo "=== Running scheduler: ${sched} ==="
    sed -i "s/-gpgpu_scheduler.*/-gpgpu_scheduler ${sched}/" ./gpgpusim.config
    for bench in backprop bfs hotspot kmeans lud nw pathfinder srad_v2 streamcluster; do
        tracedir=$(find /accel-sim/hw_run/rodinia_2.0-ft/9.1/${bench}* -name "kernelslist.g" 2>/dev/null | head -1)
        if [ -n "$tracedir" ]; then
            ipc=$(/accel-sim/gpu-simulator/bin/release/accel-sim.out \
                -config ./gpgpusim.config \
                -trace $tracedir 2>&1 \
                | grep "gpu_tot_ipc" | tail -1 | awk '{print $NF}')
            echo "${sched},${bench},${ipc}" >> /accel-sim/results.csv
            echo "  Running ${bench}... IPC = ${ipc}"
        fi
    done
done

echo ""
echo "=== Final Results ==="
cat /accel-sim/results.csv
