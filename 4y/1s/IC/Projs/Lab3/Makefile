
all:
	@(if [ ! -d build ]; then mkdir build; fi; cd build;\
	  if [ ! -d fcm-example-bin ]; then mkdir fcm-example-bin; fi; cmake ..; make)

clean:
	rm -rf build ../fcm-example-bin
