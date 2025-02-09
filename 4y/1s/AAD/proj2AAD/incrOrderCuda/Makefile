CU_APPS=incOrderColumn incOrderRow

all: ${CU_APPS}

%: %.cu
	nvcc -O3 -Wno-deprecated-gpu-targets -o $@ $<
clean:
	rm -f ${CU_APPS}
