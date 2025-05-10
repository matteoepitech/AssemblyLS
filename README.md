# AssemblyLS (x86_64) - A minimal `ls`

This project is a **minimal reimplementation of the Unix `ls` command**, written entirely in **x86_64 assembly (Intel syntax)** using **NASM**.  
It does **not use any C standard library (libc)** or even `gcc` during linking — everything is built and linked manually, using only system calls.

---

## Build instructions

To build the project, make sure you have:

- `nasm` (Netwide Assembler)
- `ld` (GNU linker)
- `make` (For build the project entirely)


### Build with Makefile

```bash
make        # builds the project
make clean  # removes object files
make fclean # removes object files and the binary
make re     # rebuilds everything
```

---

## Why Not Use `gcc`?

You **can** compile assembly files with `gcc`, but it comes with automatic linking of:
- the **libc** (standard C library),
- startup files like `crt0.o`,
- and often assumes you're writing in **AT&T syntax**, not Intel (NASM-style).

In this project, we do **not** use `gcc` to compile or link.

### Alternatives:

| Method                   | Uses `libc`? | Syntax Style | Tools Used           |
|--------------------------|--------------|---------------|------------------------|
| `gcc file.s`             | ✅ Yes       | AT&T          | `gcc` |
| `nasm + gcc file.o`      | ✅ Yes       | Intel         | `nasm`, `gcc`          |
| `nasm + ld`              | ❌ No        | Intel         | `nasm`, `ld`           |

We use the last method — `nasm + ld` — for **complete control** and to **avoid linking against the libc**.

---

## System calls instead of libc

In C, listing a directory would look like this:

```c
DIR *d = opendir(".");
struct dirent *entry;

while ((entry = readdir(d)) != NULL) {
    printf("%s\n", entry->d_name);
}
```

This relies entirely on `libc`. Since `libc` contains the functions `opendir()` and `readdir()`.

But in our assembly project, we manually invoke system calls like:
- `sys_openat` -> Open a file/directory
- `sys_getdents64` -> Read the content of a directory
- `sys_write` -> Write content on the screen
- `sys_exit` -> Quit the program

This gives us full control and a deeper understanding of how directory listing really works under Linux.

---

## Example output

```bash
$ ./ls
main.s
utils.s
Makefile
README.md
```

*(Note: This is a simplified version of `ls`. It not support flags like `-l`, `-a`, etc.)*

---

## License

MIT — do whatever you want, just don’t blame me if you segfault 😉
