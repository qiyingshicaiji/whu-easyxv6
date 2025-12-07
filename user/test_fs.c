#include "syscall.h"

// Simple FS integrity and concurrency smoke test
int main(void) {
    write(1, "[user] Starting FS test...\n", 27);
    // Integrity test
    int fd = open("testfile", 1); // create
    if (fd < 0) { write(1, "open(create) failed\n", 20); return -1; }
    const char *msg = "Hello, filesystem!";
    int n = write(fd, msg, 20);
    if (n != 20) { write(1, "write failed\n", 13); return -2; }
    close(fd);

    fd = open("testfile", 0);
    char buf[32];
    int r = read(fd, buf, sizeof(buf));
    close(fd);
    if (r < 0) { write(1, "read failed\n", 12); return -3; }

    // unlink and ensure open fails without create
    unlink("testfile");
    int fd2 = open("testfile", 0);
    if (fd2 >= 0) { write(1, "unlink failed\n", 14); return -4; }

    // Concurrent access (very simple)
    // In this minimalist environment, just do repeated writes/reads
    int fd3 = open("stress", 1);
    if (fd3 < 0) { write(1, "open(stress) failed\n", 22); return -5; }
    for (int i=0;i<100;i++) {
        char c = 'A' + (i % 26);
        char tmp[8];
        for (int j=0;j<8;j++) tmp[j] = c;
        write(fd3, tmp, 8);
    }
    close(fd3);
    fd3 = open("stress", 0);
    char rb[16];
    read(fd3, rb, sizeof(rb));
    close(fd3);

    write(1, "[user] FS test done.\n", 22);
    return 0;
}
