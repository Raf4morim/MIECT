#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "common.h"
#include <cuda_runtime.h>

/* program configuration */

#ifndef ARRAY_LENGTH
# define ARRAY_LENGTH  (1 << 10)
#endif
#ifndef N_ARRAYS
# define N_ARRAYS  (1 << 10)
#endif

/* allusion to internal functions */
static void order_array_cpu_kernel (unsigned int *data, unsigned int length);
__global__ static void order_array_cuda_kernel (unsigned int *data, unsigned int length);
static double get_delta_time(void);

/* main program */

int main (int argc, char **argv)
{
  printf("%s Starting...\n", argv[0]);
  if (sizeof (unsigned int) != (size_t) 4)
     { fprintf (stderr, "Type int is not 4 bytes long.");
       return EXIT_FAILURE;
     }

  /* set up device */
  int dev = 0;
  cudaDeviceProp deviceProp;

  CHECK (cudaGetDeviceProperties (&deviceProp, dev));
  printf("Using Device %d: %s\n", dev, deviceProp.name);
  CHECK (cudaSetDevice (dev));

  /* allocate memory space in host and device to store the arrays */
  unsigned int data_size;
  unsigned int *host_data;
  unsigned int *device_data;

  data_size = (size_t) N_ARRAYS * (size_t) ARRAY_LENGTH * sizeof (unsigned int);
  if (data_size > (size_t) 1.8e9)
     { fprintf (stderr, "Too much memory to be allocated!\n");
       return EXIT_FAILURE;
     }
  printf ("Total data size: %u\n", data_size);

  host_data = (unsigned int *) malloc (data_size);
  CHECK (cudaMalloc ((void **) &device_data, data_size));

  /* initialize host data */
  int i;

  (void) get_delta_time ();
  srand(0xAAD2022);
  for (i = 0; i < (int) (data_size / (int) sizeof(unsigned int)); i++)
    host_data[i] = (unsigned int) ((double) rand ()/RAND_MAX * 10000);
  printf ("The initialization of host data took %.3e seconds\n",get_delta_time ());

  /* copy host data to device memory */
  (void) get_delta_time ();
  CHECK (cudaMemcpy (device_data, host_data, data_size, cudaMemcpyHostToDevice));
  printf ("The transfer of %d bytes from the host to the device took %.3e seconds\n", data_size, get_delta_time ());

  /* run the computational kernel on the GPU
     as an example, N_ARRAYS threads are launched where each thread deals with one array
  */
  unsigned int gridDimX,gridDimY,gridDimZ,blockDimX,blockDimY,blockDimZ;

  blockDimX = 1 << 0;                                             // optimize!
  blockDimY = 1 << 0;                                             // optimize!
  blockDimZ = 1 << 0;                                             // do not change!
  gridDimX = 1 << 10;                                             // optimize!
  gridDimY = 1 << 0;                                              // optimize!
  gridDimZ = 1 << 0;                                              // do not change!

  dim3 grid (gridDimX, gridDimY, gridDimZ);
  dim3 block (blockDimX, blockDimY, blockDimZ);

  if ((gridDimX * gridDimY * blockDimX * blockDimY) != N_ARRAYS)
     { fprintf (stderr, "Wrong configuration!\n");
       return EXIT_FAILURE;
     }
  (void) get_delta_time ();
  order_array_cuda_kernel <<<grid, block>>> (device_data, ARRAY_LENGTH);
  CHECK (cudaDeviceSynchronize ());                               // wait for kernel to finish
  CHECK (cudaGetLastError ());                                    // check for kernel errors
  printf("The CUDA kernel <<<(%d,%d,%d), (%d,%d,%d)>>> took %.3e seconds to run\n",
         gridDimX, gridDimY, gridDimZ, blockDimX, blockDimY, blockDimZ, get_delta_time ());

  /* copy result back to host side */
  unsigned int *modified_device_data;

  modified_device_data = (unsigned int *) malloc (data_size);
  CHECK (cudaMemcpy (modified_device_data, device_data, data_size, cudaMemcpyDeviceToHost));
  printf ("The transfer of %ld bytes from the device to the host took %.3e seconds\n", (long) data_size, get_delta_time ());

  /* free device allocated memory */
  CHECK (cudaFree (device_data));

  /* reset device */
  CHECK (cudaDeviceReset ());

  /* run the computational kernel on the CPU */
  (void) get_delta_time ();
  for (i = 0; i < N_ARRAYS; i++)
    order_array_cpu_kernel (host_data + i, ARRAY_LENGTH);
  printf("The cpu kernel took %.3e seconds to run (single core)\n", get_delta_time ());

  /* compare results from CPU and GPU */
  for(i = 0; i < N_ARRAYS * ARRAY_LENGTH; i++)
    if (host_data[i] != modified_device_data[i])
       { fprintf (stderr, "Mismatch in array %d, element %d\n", i / N_ARRAYS, i % ARRAY_LENGTH);
         return EXIT_FAILURE;
       }
  printf ("All is well!\n");

  /* free host memory */
  free (host_data);
  free (modified_device_data);

  return EXIT_SUCCESS;
}

static void order_array_cpu_kernel (unsigned int *data, unsigned int length)
{
  unsigned int i, j;
  unsigned int tmp;
  bool noSwap;

  for (i = 0; i < length - 1; i++)
  { noSwap = true;
    for (j = length - 1; j > i; j--)
      if (data[j*N_ARRAYS] < data[(j-1)*N_ARRAYS])
         { tmp = data[j*N_ARRAYS];
           data[j*N_ARRAYS] = data[(j-1)*N_ARRAYS];
           data[(j-1)*N_ARRAYS] = tmp;
           noSwap = false;
         }
    if (noSwap) break;
  }
}

__global__ static void order_array_cuda_kernel (unsigned int *data, unsigned int length)
{
  /* compute thread number */
  unsigned int x, y, idx;

  x = (unsigned int) threadIdx.x + (unsigned int) blockDim.x * (unsigned int) blockIdx.x;
  y = (unsigned int) threadIdx.y + (unsigned int) blockDim.y * (unsigned int) blockIdx.y;
  idx = (unsigned int) blockDim.x * (unsigned int) gridDim.x * y + x;
  if (idx >= N_ARRAYS)
     return;                                             // safety precaution

  /* adjust pointer to the array to be ordered */
  data += idx;

  /* order the array elements */
  unsigned int i, j;
  unsigned int tmp;
  bool noSwap;

  for (i = 0; i < length - 1; i++)
  { noSwap = true;
    for (j = length - 1; j > i; j--)
      if (data[j*N_ARRAYS] < data[(j-1)*N_ARRAYS])
         { tmp = data[j*N_ARRAYS];
           data[j*N_ARRAYS] = data[(j-1)*N_ARRAYS];
           data[(j-1)*N_ARRAYS] = tmp;
           noSwap = false;
         }
    if (noSwap) break;
  }
}

static double get_delta_time(void)
{
  static struct timespec t0,t1;

  t0 = t1;
  if(clock_gettime(CLOCK_MONOTONIC,&t1) != 0)
  {
    perror("clock_gettime");
    exit(1);
  }
  return (double)(t1.tv_sec - t0.tv_sec) + 1.0e-9 * (double)(t1.tv_nsec - t0.tv_nsec);
}
