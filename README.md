# Linux4.16.0 arm64 kernel build
### for debuging with KGDB
###### will add KDB later..

## What is this repository?
kgdb를 이용해 arm64 커널을 바로 디버깅 할 수 있도록 빌드 해놓은
저장소입니다. 
_~~영어를 못해서 한글로 적은 것은 아닙니다. ㅎㅎㅎㅎㅎㅎ ^^;;;;;~~_

### Debugging Environment
* **Host OS** : Ubuntu(18.04 LTS) on Windows (Download from Windows Store)
* **Target Kernel Version** : v4.16.0
* **GDB Version** : GNU gdb:multiarch 8.1.0
* **Compiler Version** : aarch64:linux:gnu:gcc 7.3.0
* **Qemu Version** : qemu:system:aarch64 2.11.1

## How to get ready for compiling


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


## How to make Image?

```sh
make mrproper
make defconfig
make menuconfig
make Image
```

* `$ make mrproper` : config 파일 clean
* `$ make defconfig` : 해당 arch의 defconfig 파일로 .config 설정 (./arch/ARCH/configs/defconfig 달랑 하나있음)
* `$ make menuconfig` : 추가 변경할 config 설정(kgdb 설정)
* `$ make Image` :  Image (커널이미지) 빌드.  
        * Caution : -j 옵션을 주지 않는 것을 권장. (파일 의존성 문제로 컴파일 중단이 자주 벌어짐)

> [http://xenostudy.tistory.com/485](http://xenostudy.tistory.com/485)

## How to update configuration file for debugging

* **defconfig**
![config-defconfig](https://tot0ro-prog.firebaseapp.com/Image/Linux4.16_arm64_debug_build/make_config.PNG)

* **CONFIG\_DEBUG\_INFO=y**
![config-debuginfo](https://tot0ro-prog.firebaseapp.com/Image/Linux4.16_arm64_debug_build/debug_info.PNG)

* **CONFIG\_KGDB=y**
![config-kgdb](https://tot0ro-prog.firebaseapp.com/Image/Linux4.16_arm64_debug_build/kgdb.PNG)

* **CONFIG\_KGDB\_SERIAL\_CONSOLE=y**
![config-kgdb-serial-console](https://tot0ro-prog.firebaseapp.com/Image/Linux4.16_arm64_debug_build/kgdb_serial_console.PNG)

* **CONFIG\_FRAME\_POINTER=y**
![config-frame-pointer](https://tot0ro-prog.firebaseapp.com/Image/Linux4.16_arm64_debug_build/frame_pointer.PNG)

> [http://studyfoss.egloos.com/5490783](http://studyfoss.egloos.com/5490783)



