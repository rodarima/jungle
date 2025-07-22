HOSTCXX  ?= g++
NVCC     := nvcc -ccbin $(HOSTCXX)
CXXFLAGS := -m64

# Target rules
all: cudainfo

cudainfo: cudainfo.cpp
	$(NVCC) $(CXXFLAGS) -o $@ $<

clean:
	rm -f cudainfo cudainfo.o
