%define SYS_WRITE 1
%define SYS_STAT 4
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

; --------------------------
; struct stat NOT FINISHED
; --------------------------
%define ST_DEV 0
%define ST_INO (ST_DEV + 8)
%define ST_NLINK (ST_INO + 8)
%define ST_MODE (ST_NLINK + 8)

%define S_IFREG 0100000o
%define S_IFDIR 0040000o
%define S_IFMT  0170000o

%define ASCII_DOT 46
%define ASCII_DASH 45
%define ASCII_A 97
%define ASCII_L 108

%define NO_OPTION 00000000b
%define A_OPTION  00000001b
%define L_OPTION  00000010b
