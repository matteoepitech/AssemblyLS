%define SYS_WRITE 1
%define SYS_EXIT 60
%define SYS_OPENAT 257
%define SYS_GETDENTS64 217

%define STDIN 0
%define STDOUT 1
%define STDERR 2

%define O_RDONLY 0
%define O_DIRECTORY 65536

%define AT_FDCWD -100

%define FAIL_SYS -1

; --------------------------
; struct linux direct offset
; --------------------------
%define D_INO 0
%define D_OFF (D_INO + 8)
%define D_RECLEN (D_OFF + 8)
%define D_TYPE (D_RECLEN + 2)
%define D_NAME (D_TYPE + 1)

%define ASCII_DOT 46
