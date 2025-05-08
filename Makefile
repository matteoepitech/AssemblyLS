NAME    := ls
SRC     := $(wildcard src/*.s)
OBJ     := $(SRC:src/%.s=%.o)

NASM    := nasm
NASMFLAGS := -f elf64

LD      := ld
LDFLAGS := -o $(NAME)

all: $(NAME)

$(NAME): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ)

%.o: src/%.s
	$(NASM) $(NASMFLAGS) -o $@ $<

clean:
	rm -f *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
