runboard:
	qemu-system-riscv64 \
	-M quard-star \
	-m 1G \
	-smp 8 \
	--parallel none \
	-monitor stdio
