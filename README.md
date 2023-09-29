# network-on-chip
## Multicore Implementation of Crypto-Algorithm Using Network-on-Chip

Bachelor's thesis @ Faculty of Electrical Engineering and Computing, University of Zagreb


This work describes a refined architectural approach to solving intensive parallel
computation in hardware - a Network-on-Chip. Network-on-Chip allows for multicore processing of vast amounts of data in hardware. The implementation of NoC
used is an open source named OpenNoc, designed for the FPGA technology. Crypto-algorithms perform predominantly concurrent computation and therefore benefit of
hardware acceleration. The work provided implementation of custom processing elements performing the Serpent crypto-algorithm encryption and decryption. Perfor-
mance was assessed in simulation of the NoC with various numbers of cores. Several
improvements regarding the implementation flexibility, security, power and memory
consumption are suggested.
