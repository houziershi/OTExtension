# compiler options
CC=g++ -g
CFLAGS=-fPIC
COMPILER_OPTIONS=-O3
BATCH=

# external libs (linking options)
LIBRARIES=-Wl,--no-whole-archive -lpthread -lmiracl -lssl -lcrypto #-lgmp -lgmpxx 
LIBRARIES_DIR=-L/usr/local/ssl/lib/

# target names
OT_MAIN=otmain
OT_LIBRARY=otlib

# sources
SOURCES_UTIL=util/*.cpp
OBJECTS_UTIL=util/*.o
SOURCES_OTMAIN=mains/otmain.cpp
OBJECTS_OTMAIN=mains/otmain.o
SOURCES_OT=ot/*.cpp
OBJECTS_OT=ot/*.o
OBJECTS_MIRACL=util/Miracl/*.o

# includes
MIRACL_PATH=-I/usr/local/include/miracl/
OPENSSL_INCLUDES=-I/usr/local/ssl/include/
INCLUDE=-I.. $(OPENSSL_INCLUDES)

## targets ##
all: ${OT_LIBRARY}

otlib: ${OBJECTS_UTIL} ${OBJECTS_OT}
	${CC} -shared -o libOTExtension.so \
	${OBJECTS_UTIL} ${OBJECTS_OT} ${MIRACL_PATH} ${LIBRARIES} ${LIBRARIES_DIR}

otmain: ${OBJECTS_UTIL} ${OBJECTS_MIRACL} ${OBJECTS_OT} ${OBJECTS_OTMAIN}
	${CC} -o ot.exe ${CFLAGS} ${OBJECTS_OTMAIN} ${OBJECTS_UTIL} ${OBJECTS_OT} ${OBJECTS_MIRACL} ${MIRACL_PATH} ${LIBRARIES} ${COMPILER_OPTIONS}

${OBJECTS_OTMAIN}: ${SOURCES_OTMAIN}$
	@cd mains; ${CC} -c ${INCLUDE} ${CFLAGS} otmain.cpp 

${OBJECTS_UTIL}: ${SOURCES_UTIL}$  
	@cd util; ${CC} -c ${CFLAGS} ${INCLUDE} ${BATCH} *.cpp

${OBJECTS_OT}: ${SOURCES_OT}$
	@cd ot; ${CC} -c ${CFLAGS} ${INCLUDE} ${BATCH} *.cpp 

clean:
	rm -rf ot.exe ${OBJECTS_UTIL} ${OBJECTS_OTMAIN} ${OBJECTS_OT}

