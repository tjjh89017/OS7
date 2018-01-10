PROG = frag

CC = gcc
LD = gcc
CFLAGS = 
LDFLAGS = 
OBJS = main.o

DIR = mnt

.PHONY: all
all: $(PROG)

$(PROG): $(OBJS)
	$(CC) -o $(PROG) $(OBJS)

.c.o:
	$(CC) -c $< -o $@

.PHONY: real-test
real-test: $(PROG) pre-test
	-mkdir $(DIR)
	sudo mount a.img $(DIR)
	sudo chmod 777 -R $(DIR)
	cp $(PROG) $(DIR)
	cd $(DIR) && ./$(PROG)
	e2freefrag a.img

.PHONY: pre-test
pre-test: 
	dd if=/dev/zero of=a.img bs=1M count=100
	sync
	sync
	sync
	mkfs.ext4 a.img

.PHONY: wholetest
test: post-test real-test
	-sudo umount $(DIR)
	-rm -rf a.img
	-rm -rf $(DIR)

.PHONY: post-test
post-test:
	-sudo umount $(DIR)
	-rm -rf a.img
	-rm -rf $(DIR)

.PHONY: test
debug-test: post-test real-test

.PHONY: clean
clean:
	rm -rf $(OBJS) $(PROG) $(DIR)
