#ifndef FS_H
#define FS_H

#include <stdint.h>
#include "defs.h"

#define MAX_FILES 64
#define MAX_NAME 64

typedef struct file_entry {
    char name[MAX_NAME];
    uint8_t *data;
    uint32_t size;
    uint32_t capacity;
    int in_use;
} file_entry_t;

typedef struct file_handle {
    int used;
    int idx; // index into file table
    uint32_t offset;
} file_handle_t;

void fs_init(void);
int fs_open(const char *name, int create);
int fs_close(int fd);
int fs_read(int fd, void *buf, int n);
int fs_write(int fd, const void *buf, int n);
int fs_unlink(const char *name);

#endif
