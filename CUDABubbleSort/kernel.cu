
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <device_functions.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <atomic>
#include <thread>
#include <cuda_profiler_api.h>

using namespace std;

#define SIZE 1024 // FOR PARALEL GPU  SIZE HAS TO BE 2^n 1024
#define THREADS 4 // FOR PARALEL GPU  THREADS = SIZE / (BLOCKS * 2) 
#define BLOCKS 128//FOR PARALEL GPU  BLOCKS = SIZE / (THREADS * 2) 
string type = "DEVICE";  // USE "HOST" FOR CPU BUBBLE SORT, USE "DEVICE" FOR GPU BUBBLE SORT
int flag = 0;


__host__ void bubbleSortHost(int *array, int index)
{
	int temp;
	do {

		for (int i = 0; i < SIZE - 1 - index * 2 - flag; i++) {
			if (array[index * 2 + i] > array[index * 2 + 1 + i]) {
				temp = array[index * 2 + 1 + i];
				array[index * 2 + 1 + i] = array[index * 2 + i];
				array[index * 2 + i] = temp;
			}
		}

		flag++;

	} while (SIZE - 1 - index * 2 - flag> 0);
}

// NOT USED BUT THERE JUST IN CASE
__global__ void bubbleSortDeviceSerial(int size, int *array)
{
	int i, j, temp;
	for (i = 1; i < size; i++) {
		for (j = 0; j < size - 1; j++) {
			if (array[j] > array[j + 1]) {
				temp = array[j + 1];
				array[j + 1] = array[j];
				array[j] = temp;
			}
		}
	}
}

__global__ void bubbleSortDeviceParallel(int *array, int offSet)
{

	int index = blockIdx.x * blockDim.x + threadIdx.x;
	int indexPerBlock = threadIdx.x;
	int temp;

	if (index  < THREADS* BLOCKS) {

		// FIRST STEP
		if (offSet == 0) {

			// DO THREAD SORTING IN CORRESPONDING BLOCK 
			for (int j = 0; j < THREADS / 2; j++) {

				for (int i = 0; i < THREADS * 2 - 1 - indexPerBlock * 2; i++) {

					if (array[index * 2 + i] > array[index * 2 + 1 + i]) {
						temp = array[index * 2 + 1 + i];
						array[index * 2 + 1 + i] = array[index * 2 + i];
						array[index * 2 + i] = temp;
					}
				}
				__syncthreads();
			}
		}
		// ALL OTHER STEPS, INDEX/THREADS/BLOCKS SHIFTED FOR int offSet
		// LAST BLOCK SKIPPED
		else {
			if (blockIdx.x != BLOCKS - 1) {
				for (int j = 0; j < THREADS / 2; j++) {
					for (int i = offSet; i < THREADS * 2 - 1 + offSet - indexPerBlock * 2; i++) {

						if (array[index * 2 + i] > array[index * 2 + 1 + i]) {
							temp = array[index * 2 + 1 + i];
							array[index * 2 + 1 + i] = array[index * 2 + i];
							array[index * 2 + i] = temp;
						}

					}
					__syncthreads();
				}
			}
		}
	}

}

int main()
{
	srand(time(NULL));
	int h_count = SIZE;
	int counter = BLOCKS;
	int *h_array;
	int *d_array;
	int offSet;

	h_array = new int[h_count];

	// 1. OPTION: TYPE ELEMENTS OF h_array
	/*
	cout << "TYPE ELEMENTS OF ARRAY: " << endl;
	for (int i = 0; i < h_count; i++) {
	cout << i + 1 << ". ELEMENT: ";
	cin >> h_array[i];
	}
	cout << "" << endl;
	*/


	// 2.OPTION: GENERATING RANDOM ELEMENTS FOR h_array
	/*
	for (int i = 0; i < h_count; i++) {
	h_array[i] = rand() % SIZE;
	}
	*/


	// 3. OPTION 999.... 0..1
	for (int i = 0; i < h_count; i++) {
		h_array[i] = SIZE - i;
	}

	// BUBBLE SORT USING CPU
	if (type == "HOST") {

		cout << "ELEMENTS OF ARRAY BEFORE SORT: " << endl;
		for (int i = 0; i < SIZE; i++)
		{
			cout << h_array[i] << " ";
		}
		cout << endl;

		cudaEvent_t beginEvent;
		cudaEvent_t endEvent;

		cudaEventCreate(&beginEvent);
		cudaEventCreate(&endEvent);

		cudaEventRecord(beginEvent);

		thread bubbleSortCPU[THREADS];
		for (int i = 0; i < THREADS; i++) {
			bubbleSortCPU[i] = thread(bubbleSortHost, h_array, i);
			bubbleSortCPU[i].join();
		}

		cudaEventRecord(endEvent);
		cudaEventSynchronize(endEvent);

		float timeValue = 0;
		cudaEventElapsedTime(&timeValue, beginEvent, endEvent);

		cout << "CPU Time: " << timeValue << endl;
		cudaEventDestroy(beginEvent);
		cudaEventDestroy(endEvent);

		// ARRAY AFTER BUBBLE SORT
		cout << "BUBBLE SORT RESULTS: " << endl;
		for (int i = 0; i < h_count; i++) {
			cout << h_array[i] << " ";
		}
		cout << endl;
	}

	// BUBBLE SORT USING GPU
	if (type == "DEVICE") {

		cout << "ELEMENTS OF ARRAY BEFORE SORT: " << endl;
		for (int i = 0; i < SIZE; i++)
		{
			cout << h_array[i] << " ";
		}
		cout << endl;

		if (cudaMalloc(&d_array, sizeof(int) * h_count) != cudaSuccess)
		{
			cout << "D_ARRAY ALLOCATING NOT WORKING!" << endl;
			return 0;
		}

		if (cudaMemcpy(d_array, h_array, sizeof(int)* h_count, cudaMemcpyHostToDevice) != cudaSuccess)
		{
			cout << "cudaMemcpyHostToDevice ERROR!" << endl;
			cudaFree(d_array);
			return 0;
		}

		cudaEvent_t beginEvent;
		cudaEvent_t endEvent;

		cudaEventCreate(&beginEvent);
		cudaEventCreate(&endEvent);

		cudaEventRecord(beginEvent);

		do {

			for (int i = 0; i < THREADS * 2; i++) {
				offSet = i;
				// POSSIBLE CHANGE: if offset != 0 USE bubbleSortDeviceParallel << < BLOCKS-1, THREADS >> > (d_array, offSet);
				bubbleSortDeviceParallel << < BLOCKS, THREADS >> > (d_array, offSet);
			}

			counter--;
		} while (counter > 0);

		cudaDeviceSynchronize();
		cudaEventRecord(endEvent);
		cudaEventSynchronize(endEvent);

		float timeValue = 0;
		cudaEventElapsedTime(&timeValue, beginEvent, endEvent);

		cout << "GPU Time: " << timeValue << endl;
		cudaEventDestroy(beginEvent);
		cudaEventDestroy(endEvent);

		if (cudaMemcpy(h_array, d_array, sizeof(int)* h_count, cudaMemcpyDeviceToHost) != cudaSuccess)
		{
			delete[] h_array;
			cudaFree(d_array);
			cout << "cudaMemcpyDeviceToHost Error" << endl;
			system("pause");
			return 0;
		}
		cout << endl;

		// ARRAY AFTER BUBBLE SORT
		cout << "BUBBLE SORT RESULTS: " << endl;
		for (int i = 0; i < h_count; i++) {
			cout << h_array[i] << " ";
		}
		cout << endl;


	}

	// FREEING MEMORY OF CPU & GPU
	delete[] h_array;
	cudaFree(d_array);
	cudaDeviceReset();

	system("pause");
	return 0;
}
