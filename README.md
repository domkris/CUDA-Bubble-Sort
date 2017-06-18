# CUDA-Bubble-Sort

This project is developed as part of university studies to show how CUDA  can be impractical for bubble sort, mostly due to 
asynchronous behaviour of blocks.

Progr. languages and tools used:<br>
Cuda 8.0 version, C++, Visual Studio Community 2015

<h2>Information about computer used to develop and test this program</h2>
WINDOWS & CPU INFO

<a href="http://s1294.photobucket.com/user/DoVBid/media/Screenshot%20181_zpsmhnj4yot.png.html" target="_blank"><img src="http://i1294.photobucket.com/albums/b604/DoVBid/Screenshot%20181_zpsmhnj4yot.png" border="0" alt=" photo Screenshot 181_zpsmhnj4yot.png"/></a>

GPU INFO 

<a href="http://s1294.photobucket.com/user/DoVBid/media/Screenshot%20182_zpstlxys0ai.png.html" target="_blank"><img src="http://i1294.photobucket.com/albums/b604/DoVBid/Screenshot%20182_zpstlxys0ai.png" border="0" alt=" photo Screenshot 182_zpstlxys0ai.png"/></a>


<h2> RESULTS CPU(HOST)</h2>
Used array of sizes: 512, 1025, 2048, 4096  (odd and other integer numbers can be used)
<a href="http://s1294.photobucket.com/user/DoVBid/media/BUbbleCPU_zpscdwpsm0x.png.html" target="_blank"><img src="http://i1294.photobucket.com/albums/b604/DoVBid/BUbbleCPU_zpscdwpsm0x.png" border="0" alt=" photo BUbbleCPU_zpscdwpsm0x.png"/></a>
<sup>chart made with www.onlinecharttool.com</sup><br>

<h2> RESULTS GPU(DEVICE)</h2>
Used array of sizes: 512, 1025, 2048. 4096 (Here it has to be 2^n)<br>
FOR PARALEL GPU  <b>SIZE = 2^n</b> <br>
FOR PARALEL GPU  <b>THREADS = SIZE / (BLOCKS * 2)</b> <br>
FOR PARALEL GPU  <b>BLOCKS = SIZE / (THREADS * 2)</b> <br>
<br><br>
<a href="http://s1294.photobucket.com/user/DoVBid/media/BUbbleGPU_zpsoqoxtatj.png.html" target="_blank"><img src="http://i1294.photobucket.com/albums/b604/DoVBid/BUbbleGPU_zpsoqoxtatj.png" border="0" alt=" photo BUbbleGPU_zpsoqoxtatj.png"/></a>
<sup>chart made with www.onlinecharttool.com</sup><br>

<h2> Getting time results (nvcc compiler)</h2>
Main file <strong> kernel.cu</strong> to test this code located in CUDABubbleSort folder.<br>
Open command prompt in CUDABubbleSort folder.<br>
(Windows cmd) type: <i>nvcc kernel.cu</i><br>
(Windows cmd) after that type: <i>nvprof a.exe</i>
<br><br>
Profiling result: <br>
(Time execution for <i>bubbleSortDeviceParralel()</i> is 64.096 ms)

<a href="http://s1294.photobucket.com/user/DoVBid/media/Screenshot%20179_zpsixcuqlao.png.html" target="_blank"><img src="http://i1294.photobucket.com/albums/b604/DoVBid/Screenshot%20179_zpsixcuqlao.png" border="0" alt=" photo Screenshot 179_zpsixcuqlao.png"/></a>
