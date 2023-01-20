#If you have installed BLIS in a directory other than your home directory, set the HOME accordingly
#HOME      := /path_to_blis

# Make sure you have BLIS installed in your home directory
BLIS_LIB  := $(HOME)/blis/lib/libblis.a
BLIS_INC  := $(HOME)/blis/include/blis

# indicate how the object files are to be created
CC         := gcc-12
LINKER     := $(CC)
CFLAGS     := -O3 -I$(BLIS_INC) -m64 -mavx2 -std=c99 -march=native -fopenmp -D_POSIX_C_SOURCE=200809L
FFLAGS     := $(CFLAGS) 

# set the range of experiments to be performed
NREPEATS   := 3#      number of times each experiment is repeated.  The best time is reported.
NFIRST     := 48#     smallest size to be timed.
NLAST_SMALL:= 500#    largest size to be timed for slow implementations.
NLAST      := 1500#   largest size to be timed for fast implementations.
NINC       := 48#     increment between sizes.




# This is a sample of how you would pass in the matrix sizes as compile time defines.
PSIZE	   := -DNREPEATS=3   \
              -DNFIRST=48 \
              -DNLAST=500 \
              -DNINC=48


# Here's an example for small matrix sizes.
PSIZE_SMALL := -DNREPEATS=3   \
              -DNFIRST=48 \
              -DNLAST=100 \
              -DNINC=48

LDFLAGS    := -lpthread -m64 -lm -fopenmp

UTIL_OBJS  := FLA_Clock.o MaxAbsDiff.o RandomMatrix.o
OBJS_IJP := driver.o Gemm_IJP.o

# --------------------

.DEFAULT_TARGET := driver_IJP.x

#This is how you will create new targets for the first part of the Advanced changes
#small: PSIZE=$(PSIZE_SMALL)
#small: driver_IJP.x

driver_IJP.x: $(OBJS_IJP) $(UTIL_OBJS)
	$(LINKER) $(OBJS_IJP) $(UTIL_OBJS) $(BLIS_LIB) -o driver_IJP.x $(LDFLAGS) 


IJP: driver_IJP.x
	echo "$(NREPEATS) $(NFIRST) $(NLAST_SMALL) $(NINC)" | ./driver_IJP.x  

#Compile target needed for Developing changes
#%.o: %.c
#	$(CC) $(CFLAGS) -DNMATRIX $(PSIZE) -c $< -o $@

#Compile target for beginning changes
%.o: %.c
	$(CC) $(CFLAGS)  -c $< -o $@



# ---------------------                                                               
clean:
	rm -f *.o *~ core *.x
