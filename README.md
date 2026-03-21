# Evaluating-Two-Level-Warp-Scheduling-with-AccelSim

In AccelSim, there exists a two level warp scheduler which chooses between active and pending pools. The paper by Narasiman and co, implemented scheduling by just taking fixed fetch groups (from the active warps). This is a premitive type of scheduling but sticks to the ethos of the paper. To implement the scheduling mechanism, we define a new class in the shader.h header file. This updated file is linked in the repository.

/home/niraj/accel-sim/accel-sim-framework/gpu-simulator/gpgpu-sim/src/gpgpu-sim/shader.h
