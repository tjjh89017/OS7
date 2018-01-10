#include <stdio.h>
#include <stdlib.h>

#define _GNU_SOURCE
#define __USE_LARGEFILE64
#include <fcntl.h>
#include <sys/time.h>

#define FALLOC_FL_COLLAPSE_RANGE 8

char junk[1024] = {'\0'};

int main(){

	struct timeval start;
	struct timeval end;
	unsigned long diff;
	gettimeofday(&start, NULL);

	// produce largefile.txt >= 400KiB
	int fd = open("largefile.txt", O_RDWR | O_CREAT | O_LARGEFILE);

	posix_fallocate(fd, 0, 1600 * 1024);

	for(int i = 0; i < 1600; i += 2){
		fallocate(fd, FALLOC_FL_COLLAPSE_RANGE, i * 1024, 1024);
	}

	close(fd);
	
	// test
	system("filefrag -v largefile.txt");
	gettimeofday(&end, NULL);
	diff = 1000000 * (end.tv_sec - start.tv_sec) + end.tv_usec - start.tv_usec;
	printf("Elapsed time: %f sec\n", (double)diff / 1000000);

	return 0;
}
