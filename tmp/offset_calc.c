#include <stdio.h>
#include <stddef.h>
#include <sys/stat.h> 

int main()
{
    printf("Offset of st_dev: %zu\n", offsetof(struct stat, st_dev));
    printf("Offset of st_ino: %zu\n", offsetof(struct stat, st_ino));
    printf("Offset of st_nlink: %zu\n", offsetof(struct stat, st_nlink));
    printf("Offset of st_mode: %zu\n", offsetof(struct stat, st_mode));
    printf("Offset of st_uid: %zu\n", offsetof(struct stat, st_uid));
    printf("Size st_mode : %zu bytes\n", sizeof(((struct stat *)0)->st_mode));
    printf("Size st_nlink : %zu bytes\n", sizeof(((struct stat *)0)->st_nlink));
    printf("Size st_uid : %zu bytes\n", sizeof(((struct stat *)0)->st_uid));
    return 0;
}

