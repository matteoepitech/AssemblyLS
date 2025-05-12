NAME    := ls
SRC     := $(wildcard src/*.s) $(wildcard src/utils/*.s)
OBJ_DIR := obj
OBJ     := $(SRC:src/%.s=$(OBJ_DIR)/%.o)
NASM    := nasm
NASMFLAGS := -f elf64 -g -F dwarf
LD      := ld
LDFLAGS := -o $(NAME)

all: $(NAME)

$(NAME): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ)

$(OBJ_DIR)/%.o: src/%.s
	@mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) -o $@ $<

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

debug:
	@echo "SRC: $(SRC)"
	@echo "OBJ: $(OBJ)"

.PHONY: all clean fclean re debug
