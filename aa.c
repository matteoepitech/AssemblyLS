#include <fcntl.h>
#include <stdio.h>

char *get_line(int fd);

int main(void)
{
	int fd = open("/etc/passwd", O_RDONLY);

	char *a = get_line(fd);
	printf("%s", a);
	char *b = get_line(fd);
	printf("%s", b);
}
