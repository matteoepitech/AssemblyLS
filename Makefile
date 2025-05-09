NAME    := ls
SRC     := $(wildcard src/*.s)
OBJ_DIR := obj
OBJ     := $(SRC:src/%.s=$(OBJ_DIR)/%.o)
NASM    := nasm
NASMFLAGS := -f elf64
LD      := ld
LDFLAGS := -o $(NAME)

all: $(OBJ_DIR) $(NAME)

$(NAME): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: src/%.s
	$(NASM) $(NASMFLAGS) -o $@ $<

clean:
	rm -f $(OBJ_DIR)/*.o
	rmdir $(OBJ_DIR) 2>/dev/null || true

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re $(OBJ_DIR)
