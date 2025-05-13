# 🧠 AssemblyLS — Minimal `ls` in pure x86\_64 ASM

> A minimal, reimplementation of `ls`, written in raw Intel ASM without the libc.

<p align="center">
  <img src="tmp/demo.gif" alt="AssemblyLS demo" />
</p>

---

## How to build ?

```bash
make        # build the binary
make clean  # clean the directory obj/ files
make fclean # clean everything
make re     # rebuild from scratch
```

## Tech used

* x86\_64 Assembly (Intel syntax)
* NASM (Netwide Assembler)
* No libc / No GCC

## What is working
- [x] Simple LS in lambda directory
- [x] Simple LS in big directory
- [x] -a option
- [ ] -l option

> [!WARNING]
> This project contains a lot of bad practice since it's a beginner friendly project.

---

## 📄 License

MIT — use freely, this can segfault btw 😉
