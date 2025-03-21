CROSS_PREFIX = riscv64-unknown-linux-gnu-
#QEMU_COMMON_FLAGS = 	qemu-system-riscv64 -M quard-star -m 1G -smp 8 -nographic -serial mon:stdio -monitor telnet:127.0.0.1:1234,server,nowait
QEMU_COMMON_FLAGS = 	qemu-system-riscv64 -M quard-star -m 1G -smp 8 
LLB_FLAGS = -drive if=pflash,bus=0,unit=0,format=raw,file=mylowlevelboot/build/fw.bin
runboard:


run:
	@cd mylowlevelboot && make
	$(QEMU_COMMON_FLAGS) $(LLB_FLAGS)

cleanall:
	@cd mylowlevelboot && make clean
	@cd opensbi && make clean


