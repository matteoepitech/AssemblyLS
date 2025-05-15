%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
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
%define ST_UID (ST_MODE + 4)
%define ST_GID (ST_UID + 4)
%define ST_SIZE 48

%define S_IFREG 0100000o
%define S_IFDIR 0040000o
%define S_IFMT  0170000o
%define S_IRUSR	00400o
%define S_IWUSR	00200o
%define S_IXUSR	00100o
%define S_IRWXG	00070o
%define S_IRGRP	00040o
%define S_IWGRP	00020o
%define S_IXGRP	00010o
%define S_IRWXO	00007o
%define S_IROTH	00004o
%define S_IWOTH	00002o
%define S_IXOTH	00001o

%define ASCII_DOT 46
%define ASCII_DASH 45
%define ASCII_A 97
%define ASCII_L 108
%define ASCII_D 100

%define NO_OPTION 00000000b
%define A_OPTION  00000001b
%define L_OPTION  00000010b
