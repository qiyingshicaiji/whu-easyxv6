#include "fs.h"
#include "uart.h"
#include "proc.h"
#include "defs.h"

static file_entry_t files[MAX_FILES];
static file_handle_t fds[MAX_FILES];

static void *kalloc_zero(uint32_t sz) {
    void *p = alloc_page();
    if (!p) return 0;
    uint8_t *b = (uint8_t*)p;
    for (uint32_t i=0;i<sz;i++) b[i]=0;
    return p;
}

void fs_init(void) {
    for (int i = 0; i < MAX_FILES; i++) {
        files[i].in_use = 0;
        fds[i].used = 0;
    }
}

static int find_file(const char *name) {
    for (int i = 0; i < MAX_FILES; i++) {
        if (files[i].in_use) {
            // simple string compare
            int eq = 1;
            for (int j=0;j<MAX_NAME;j++) {
                if (files[i].name[j] != name[j]) { eq = 0; break; }
                if (name[j] == '\0') break;
            }
            if (eq) return i;
        }
    }
    return -1;
}

static int create_file(const char *name) {
    int empty = -1;
    for (int i = 0; i < MAX_FILES; i++) {
        if (!files[i].in_use) { empty = i; break; }
    }
    if (empty < 0) return -1;
    // init entry
    for (int j=0;j<MAX_NAME;j++) { files[empty].name[j] = name[j]; if (name[j]=='\0') break; }
    files[empty].size = 0;
    files[empty].capacity = 4096;
    files[empty].data = (uint8_t*)kalloc_zero(files[empty].capacity);
    if (!files[empty].data) return -1;
    files[empty].in_use = 1;
    return empty;
}

int fs_open(const char *name, int create) {
    int idx = find_file(name);
    if (idx < 0 && create) idx = create_file(name);
    if (idx < 0) return -1;
    for (int i=0;i<MAX_FILES;i++) {
        if (!fds[i].used) {
            fds[i].used = 1;
            fds[i].idx = idx;
            fds[i].offset = 0;
            return i;
        }
    }
    return -1;
}

int fs_close(int fd) {
    if (fd < 0 || fd >= MAX_FILES || !fds[fd].used) return -1;
    fds[fd].used = 0;
    return 0;
}

int fs_read(int fd, void *buf, int n) {
    if (fd < 0 || fd >= MAX_FILES || !fds[fd].used) return -1;
    file_handle_t *h = &fds[fd];
    file_entry_t *e = &files[h->idx];
    if (!e->in_use) return -1;
    if (h->offset >= e->size) return 0;
    uint32_t rem = e->size - h->offset;
    uint32_t m = (n < (int)rem) ? (uint32_t)n : rem;
    uint8_t *dst = (uint8_t*)buf;
    for (uint32_t i=0;i<m;i++) dst[i] = e->data[h->offset + i];
    h->offset += m;
    return (int)m;
}

int fs_write(int fd, const void *buf, int n) {
    if (fd < 0 || fd >= MAX_FILES || !fds[fd].used) return -1;
    file_handle_t *h = &fds[fd];
    file_entry_t *e = &files[h->idx];
    if (!e->in_use) return -1;
    uint32_t need = h->offset + (uint32_t)n;
    if (need > e->capacity) return -1; // simple cap check
    const uint8_t *src = (const uint8_t*)buf;
    for (int i=0;i<n;i++) e->data[h->offset + i] = src[i];
    h->offset += (uint32_t)n;
    if (h->offset > e->size) e->size = h->offset;
    return n;
}

int fs_unlink(const char *name) {
    int idx = find_file(name);
    if (idx < 0) return -1;
    files[idx].in_use = 0;
    files[idx].size = 0;
    files[idx].name[0] = '\0';
    // data left allocated; in this simple demo we don't free
    return 0;
}
