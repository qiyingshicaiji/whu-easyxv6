#ifndef SPINLOCK_H
#define SPINLOCK_H

struct spinlock {
    int locked;
};

void initlock(struct spinlock *lk);
void acquire(struct spinlock *lk);
void release(struct spinlock *lk);

#endif // SPINLOCK_H
