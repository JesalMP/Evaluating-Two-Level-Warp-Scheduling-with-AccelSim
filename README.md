# Evaluating-Two-Level-Warp-Scheduling-with-AccelSim

In AccelSim, there exists a two level warp scheduler which chooses between active and pending pools. The paper by Narasiman and co, implemented scheduling by just taking fixed fetch groups (from the active warps). This is a premitive type of scheduling but sticks to the ethos of the paper. To implement the scheduling mechanism, we define a new class in the shader.h header file. This updated file is linked in the repository.

/home/niraj/accel-sim/accel-sim-framework/gpu-simulator/gpgpu-sim/src/gpgpu-sim/shader.h

The constructor class is "two_level_rr_scheduler"

The Scheduler logic has been added to the shader.cc file under the same name "two_level_rr_scheduler". 
/home/niraj/accel-sim/accel-sim-framework/gpu-simulator/gpgpu-sim/src/gpgpu-sim/shader.cc

The shader.h and shader.cc files compiles into libcudart.so


After making these changes to the GPGPU-Sim Simulator files, we need to run this scheduling logic in an existing GPU. Since the Rodinia 3.1 traces for GV100 are available, we need to make certain changes to the gpgpusim.config file which is present in this directory:/home/niraj/accel-sim/accel-sim-framework/gpu-simulator/gpgpu-sim/configs/tested-cfgs/SM7_QV100/gpgpusim.config/. 

We need to add specialized units to Volta to make it compatible to the traces from Rodinia 3.1 suite. The specialized units have been added at the end of the gpgpusim.config file. From line 238 to end. 
Additionally, we need to change the default scheduler to "two_level_rr:8". "8" represents the warp group size. This is there in line 134. "-gpgpu_scheduler two_level_rr:8"

The gpgpusim.config file compiles into "accel-sim.out"

After this, we need to link the shader.h, shader.cc and the gpgpusim.config file of GV100 and then run the simulation. A benchmark such as bfs from the rodinia suite can be chosen. 

After running the BFS benchmark, on both lrr and two_level_rr, we get the following improvements in IPC

Scheduler BFS      gpu_tot_ipc
lrr (baseline)       9.9197
two_level_rr         9.9520

This accounts to a speedup of 1.000326 with two_level_rr over lrr. 1.000326




Update after adding LWM:

To run the benchmarks the following commands were run after invoking docker:
cd /accel-sim/gpu-simulator/gpgpu-sim && make -j$(nproc) 2>&1 | grep error
  cd /accel-sim/gpu-simulator && make -j$(nproc) 2>&1 | grep error
  cd /accel-sim/gpu-simulator/gpgpu-sim/configs/tested-cfgs/SM7_QV100
  bash /accel-sim/run_all.sh

Results obtained:

scheduler,benchmark,ipc
lrr,backprop,702.0930
lrr,bfs,9.9197
lrr,hotspot,634.7473
lrr,kmeans,46.4602
lrr,lud,3.1421
lrr,nw,4.2413
lrr,pathfinder,33.8825
lrr,srad_v2,365.1326
lrr,streamcluster,17.3566
gto,backprop,722.4822
gto,bfs,9.9331
gto,hotspot,643.9332
gto,kmeans,46.2751
gto,lud,3.1418
gto,nw,4.2413
gto,pathfinder,34.0228
gto,srad_v2,366.1394
gto,streamcluster,17.5640
two_level_rr:8,backprop,719.2573
two_level_rr:8,bfs,9.9520
two_level_rr:8,hotspot,644.3610
two_level_rr:8,kmeans,45.9136
two_level_rr:8,lud,3.1428
two_level_rr:8,nw,4.2413
two_level_rr:8,pathfinder,34.0326
two_level_rr:8,srad_v2,365.8073
two_level_rr:8,streamcluster,17.5933
lwm:64,backprop,713.5244
lwm:64,bfs,9.9269
lwm:64,hotspot,641.6331
lwm:64,kmeans,46.4729
lwm:64,lud,3.1428
lwm:64,nw,4.2413
lwm:64,pathfinder,33.8543
lwm:64,srad_v2,366.3982
lwm:64,streamcluster,17.5548
lwm:256,backprop,722.0339
lwm:256,bfs,9.9407
lwm:256,hotspot,641.6331
lwm:256,kmeans,46.4729
lwm:256,lud,3.1428
lwm:256,nw,4.2413
lwm:256,pathfinder,33.8543
lwm:256,srad_v2,366.3982
lwm:256,streamcluster,17.5504
lwm_two_level:64,backprop,717.5818
lwm_two_level:64,bfs,9.9269
lwm_two_level:64,hotspot,641.6331
lwm_two_level:64,kmeans,46.4729
lwm_two_level:64,lud,3.1428
lwm_two_level:64,nw,4.2413
lwm_two_level:64,pathfinder,33.8543
lwm_two_level:64,srad_v2,366.3982
lwm_two_level:64,streamcluster,17.5548
lwm_two_level:256,backprop,722.0339
lwm_two_level:256,bfs,9.9407
lwm_two_level:256,hotspot,641.6331
lwm_two_level:256,kmeans,46.4729
lwm_two_level:256,lud,3.1428
lwm_two_level:256,nw,4.2413
lwm_two_level:256,pathfinder,33.8543
lwm_two_level:256,srad_v2,366.3982
lwm_two_level:256,streamcluster,17.5504
lwm_two_level_adaptive:64,backprop,717.4835
lwm_two_level_adaptive:64,bfs,9.9474
lwm_two_level_adaptive:64,hotspot,641.6331
lwm_two_level_adaptive:64,kmeans,46.4729
lwm_two_level_adaptive:64,lud,3.1428
lwm_two_level_adaptive:64,nw,4.2413
lwm_two_level_adaptive:64,pathfinder,33.8543
lwm_two_level_adaptive:64,srad_v2,366.3982
lwm_two_level_adaptive:64,streamcluster,17.5661
lwm_two_level_adaptive:256,backprop,722.0339
lwm_two_level_adaptive:256,bfs,9.9407
lwm_two_level_adaptive:256,hotspot,641.6331
lwm_two_level_adaptive:256,kmeans,46.4729
lwm_two_level_adaptive:256,lud,3.1428
lwm_two_level_adaptive:256,nw,4.2413
lwm_two_level_adaptive:256,pathfinder,33.8543
lwm_two_level_adaptive:256,srad_v2,366.3982
lwm_two_level_adaptive:256,streamcluster,17.5504




