#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

/* program configuration */

#ifndef ARRAY_LENGTH
# define ARRAY_LENGTH  (1 << 4)
#endif
#ifndef N_ARRAYS
# define N_ARRAYS  (1 << 4)
#endif

/* allusion to internal functions */
static void order_array_cpu_kernel (unsigned int *data, unsigned int length);
static double get_delta_time(void);

/* main program */

int main (int argc, char **argv)
{
  printf("%s Starting...\n", argv[0]);
  if (sizeof (unsigned int) != (size_t) 4)
     { fprintf (stderr, "Type int is not 4 bytes long.");
       return EXIT_FAILURE;
     }

  /* allocate memory space in host to store the arrays */
  unsigned int data_size;
  unsigned int *host_data;

  data_size = (size_t) N_ARRAYS * (size_t) ARRAY_LENGTH * sizeof (unsigned int);
  if (data_size > (size_t) 1.8e9)
     { fprintf (stderr, "Too much memory to be allocated!\n");
       return EXIT_FAILURE;
     }
  printf ("Total data size: %u\n", data_size);

  host_data = (unsigned int *) malloc (data_size);

  /* initialize host data */
  int i;

  (void) get_delta_time ();
  srand(0xAAD2022);
  for (i = 0; i < (int) (data_size / (int) sizeof(unsigned int)); i++)
    host_data[i] = (unsigned int) ((double) rand ()/RAND_MAX * 10000);
  printf ("The initialization of host data took %.3e seconds\n",get_delta_time ());
  for (i = 0; i < N_ARRAYS * ARRAY_LENGTH; i++)
  { if (((i % ARRAY_LENGTH) == 0) && (i != 0)) printf ("\n");
    printf ("%6d", host_data[i]);
  }
  printf ("\n");

  /* run the computational kernel on the CPU */
  (void) get_delta_time ();
  for (i = 0; i < N_ARRAYS; i++)
    order_array_cpu_kernel (host_data + i, ARRAY_LENGTH);
  printf("The cpu kernel took %.3e seconds to run (single core)\n", get_delta_time ());
  for (i = 0; i < N_ARRAYS * ARRAY_LENGTH; i++)
  { if (((i % ARRAY_LENGTH) == 0) && (i != 0)) printf ("\n");
    printf ("%6d", host_data[i]);
  }
  printf ("\n");

  /* free host memory */
  free (host_data);

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
