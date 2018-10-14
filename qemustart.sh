qemu-system-aarch64 -machine virt -cpu cortex-a57 -smp 2 -nographic -m 4096M -kernel Image -s -S -append "kgdboc=ttyS0,115200"
