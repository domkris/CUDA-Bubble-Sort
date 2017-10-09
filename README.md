# CUDA-Bubble-Sort

This project is developed as part of university studies to show how CUDA  can be impractical for bubble sort, mostly due to 
asynchronous behaviour of blocks.

Progr. languages and tools used:<br>
Cuda 8.0 version, C++, Visual Studio Community 2015

<h2>Information about computer used to develop and test this program</h2>
WINDOWS & CPU INFO

![promisechains](https://github.com/domkris/files/blob/master/Screenshot%20(182).png?raw=true)

GPU INFO 

![promisechains](https://github.com/domkris/files/blob/master/Screenshot%20(181).png?raw=true)


<h2> RESULTS CPU(HOST)</h2>
Used array of sizes: 512, 1025, 2048, 4096  (odd and other integer numbers can be used)

![promisechains](https://github.com/domkris/files/blob/master/BUbbleCPU.png?raw=true)

<sup>chart made with www.onlinecharttool.com</sup><br>

<h2> RESULTS GPU(DEVICE)</h2>
Used array of sizes: 512, 1025, 2048. 4096 (Here it has to be 2^n)<br>
FOR PARALEL GPU  <b>SIZE = 2^n</b> <br>
FOR PARALEL GPU  <b>THREADS = SIZE / (BLOCKS * 2)</b> <br>
FOR PARALEL GPU  <b>BLOCKS = SIZE / (THREADS * 2)</b> <br>
<br><br>

![promisechains](https://github.com/domkris/files/blob/master/BUbbleGPU.png?raw=true)

<sup>chart made with www.onlinecharttool.com</sup><br>

<h2> Getting time results (nvcc compiler)</h2>
Main file <strong> kernel.cu</strong> to test this code located in CUDABubbleSort folder.<br>
Open command prompt in CUDABubbleSort folder.<br>
(Windows cmd) type: <i>nvcc kernel.cu</i><br>
(Windows cmd) after that type: <i>nvprof a.exe</i>
<br><br>
Profiling result: <br>
(Time execution for <i>bubbleSortDeviceParralel()</i> (size=1024) is 64.096 ms)

![promisechains](https://github.com/domkris/files/blob/master/Screenshot%20(179).png?raw=true)
