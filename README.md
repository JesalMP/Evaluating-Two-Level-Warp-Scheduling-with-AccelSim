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

This accounts to a speedup of 1.000326 with two_level_rr over lrr. 
1.000326



