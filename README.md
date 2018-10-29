# Linux4.16.0 arm64 kernel build
### for debuging with KGDB
###### will add KDB later..

## What is this repository?
kgdb를 이용해 arm64 커널을 바로 디버깅 할 수 있도록 빌드 해놓은
저장소입니다. //
_~~영어를 못해서 한글로 적은 것은 아닙니다. ㅎㅎㅎㅎㅎㅎ ^^;;;;;~~_

* [Linux4.16.0 arm64 kernel build](https://github.com/TOT0RoKor/Linux4.16_arm64_debug_build)

### Debugging Environment
* **Host OS** : Ubuntu(18.04 LTS) on Windows (Download from Windows Store)
* **Target Kernel Version** : v4.16.0
* **GDB Version** : GNU gdb-multiarch 8.1.0
* **Compiler Version** : aarch64-linux-gnu-gcc 7.3.0
* **Qemu Version** : qemu-system-aarch64 2.11.1


## How to do it
~~_손 발을 Do it! 단 둘이 둘이! 이 밤을 Take it!_~~

### Install

#### GDB

###### Ubuntu
```sh
sudo apt-get install gdb-multiarch
```

#### QEMU

###### Ubuntu
```sh
sudo apt-get install qemu-system-aarch64
```


### Use

이 Repository 디렉터리에서 동작시킨다.

#### QEMU

![qemu_exec](https://user-images.githubusercontent.com/24751868/47661004-8d50be80-dbdb-11e8-8059-ef80ced11c89.PNG)

###### Ubuntu
```sh
qemu-system-aarch64 -machine virt -cpu cortex-a57 -smp 2 -nographic \
                -m 4096M -s -S -kernel Image -append "kgdboc=ttyS0,115200"
```

* `$ qemu-system-aarch64` : Start qemu emulator.
* `-machine (-M) virt` : Use virt machine and virt machine's default dtb.
* `-cpu cortex-a57` : Use cortex-a57 cpu.
* `-smp 2` : Use 2 cores.
* `-nographic` : Do not use GUI qemu.
* `-m 4096M` : Use 4096MB memory. Default 128M.
* `-s` : Use gdbserver (localhost:1234, tcp)
* `-S` : Freeze the cpu.
* `-kernel Image` : Use the kernel image.
* `-append "kgdboc=ttyS0,115200"` : Use serial port of ttyS0 and Baud rate is 115200bps. 

> <http://studyfoss.egloos.com/5491211>

> <https://www.slideshare.net/aksmj/kgdbkdb>

> <https://withinrafael.com/2018/02/11/boot-arm64-builds-of-windows-10-in-qemu/>

> <http://jake.dothome.co.kr/qemu/>

#### GDB

###### Ubuntu

**Prompt= $**
```sh
gdb-multiarch vmlinux
```

**Prompt= (gdb)**
```sh
set architecture aarch64
set serial baud 115200
target remote :1234
```
* `(gdb) set architecture aarch64` : 디버깅 할 아키텍쳐를 aarch64로 변경. 기본 gdb에는 없는 아키텍쳐.
* `(gdb) set serial baud 115200` : baud rate를 115200bps로 변경.
* `(gdb) target remote :1234` : qemu로 구동한 os에 접속. qemu에서 `-s` 옵션에 기본 포트는 `:1234`

이후는 gdb 명령어를 이용해 이용 하면 된다. `-S` 옵션으로 인해 Head.S에서 cpu가 Freeze 상태.
`b(ranch) [func]` 로 특정 함수에 breakpoint를 걸고 `c(ontinue)`를 실행하면 해당 함수까지 구동한다.

> <https://sjp38.github.io/post/qemu_kernel_debugging/>

> <https://code.i-harness.com/ko-kr/q/14fc388>

## You can do
~~_너두? 야 나두._~~

### How to get ready for compiling


**Install Dependent Packages**

###### Ubuntu
```sh
sudo apt-get install build-essentials libncurses5-dev libssl-dev bc bison flex \
                libelf-dev
```

###### Fedora
```sh
sudo dnf install ncurses-devel bison-devel bison flex-devel flex \
                elfutils-libelf-devel openssl-devel
```
> [https://sjp38.github.io/post/linux-kernel-build/](https://sjp38.github.io/post/linux-kernel-build/)

**Install Compiler Package**

###### Ubuntu
```sh
sudo apt-get install binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu \
                g++-aarch64-linux-gnu
```

> [https://blog.thinkbee.kr/linux/crosscompile-arm/](https://blog.thinkbee.kr/linux/crosscompile-arm/)

### How to configure a Makefile

Modify a Makefile.

```sh
vi Makefile
```

1. Set Architecture and Cross compiler.

![makefile1](https://user-images.githubusercontent.com/24751868/47661002-8cb82800-dbdb-11e8-92a3-8fdf87440d85.PNG)

2. Set Checkstack architecture.

![makefile2](https://user-images.githubusercontent.com/24751868/47661003-8d50be80-dbdb-11e8-9708-790e53bba28b.PNG)



### How to make Image

```sh
make mrproper
make defconfig
make menuconfig
make Image
```

* `$ make mrproper` : config 파일 clean.
* `$ make defconfig` : 해당 arch의 defconfig 파일로 .config 설정. (./arch/ARCH/configs/defconfig 달랑 하나있음)
* `$ make menuconfig` : 추가 변경할 config 설정(kgdb 설정).
* `$ make Image` :  Image (커널이미지) 빌드.  
        * Caution : -j 옵션을 주지 않는 것을 권장. (파일 의존성 문제로 컴파일 중단이 자주 벌어짐)

> [http://xenostudy.tistory.com/485](http://xenostudy.tistory.com/485)

### How to update configuration file for debugging

* **defconfig**
![make_config](https://user-images.githubusercontent.com/24751868/47661000-8cb82800-dbdb-11e8-8e1b-241b2c293d54.PNG)

#### make menuconfig

* **CONFIG\_DEBUG\_INFO=y**
![debug_info](https://user-images.githubusercontent.com/24751868/47660994-8b86fb00-dbdb-11e8-9be1-dc20609faf3e.PNG)

* **CONFIG\_KGDB=y**
![kgdb](https://user-images.githubusercontent.com/24751868/47660998-8c1f9180-dbdb-11e8-8bc5-b061636342fe.PNG)

* **CONFIG\_KGDB\_SERIAL\_CONSOLE=y**
![kgdb_serial_console](https://user-images.githubusercontent.com/24751868/47660999-8cb82800-dbdb-11e8-81f8-66dbb99bc577.PNG)

* **CONFIG\_FRAME\_POINTER=y**
![frame_pointer](https://user-images.githubusercontent.com/24751868/47660996-8c1f9180-dbdb-11e8-8170-83169ca31590.PNG)

> [http://studyfoss.egloos.com/5490783](http://studyfoss.egloos.com/5490783)



