# 🧠 AssemblyLS — Minimal `ls` in pure x86\_64 ASM

> A minimal, reimplementation of `ls`, written in raw Intel ASM without the libc.
> This project use NASM as assembler

<p align="center">
  <img src="tmp/demo.gif" alt="AssemblyLS demo" />
</p>

---

## ⚙️ Build

```bash
make        # build the binary
make clean  # clean the directory obj/ files
make fclean # clean everything
make re     # rebuild from scratch
```

---

## 🧵 Tech used

* 🧠 x86\_64 Assembly (Intel syntax)
* 🚫 No libc / No GCC
* ✅ Only Linux syscalls (`getdents64`, `write`, `exit`, etc.)
* 🧱 Fully manual linking (`nasm` + `ld`)

---

## 📦 Output Example

```bash
$ ./ls
main.s  utils.s  Makefile  README.md
```

---

## 📄 License

MIT — use freely, this can segfault btw 😉
