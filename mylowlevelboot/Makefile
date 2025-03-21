# Compiler and tools
CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
OBJCOPY = riscv64-unknown-linux-gnu-objcopy

# Flags
CFLAGS = -nostartfiles -T./boot.lds -Wl,-Map=build/lowlevel_fw.map -Wl,--gc-sections
ASFLAGS = -x assembler-with-cpp
OBJCOPY_FLAGS = -O binary -S
OBJDUMP_FLAGS = --source --demangle --disassemble --reloc --wide

# Targets
TARGET = build/lowlevel_fw.elf
BIN = build/lowlevel_fw.bin
LIST = build/lowlevel_fw.lst
FW_BIN = build/fw.bin
OPENSBI_BIN = build/fw_jump.bin 

# Source files
STARTUP_SRC = startup.s
STARTUP_OBJ = build/startup.o

DTB = build/quard_star_sbi.dtb

# Default target
all: build-dir  $(FW_BIN) $(LIST)

build-dir:
	mkdir -p build

# Build steps
$(STARTUP_OBJ): $(STARTUP_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@

$(DTB): mydts/quard_star_sbi.dts
	@echo "Compiling DTS"
	@dtc -I dts -O dtb -o build/quard_star_sbi.dtb mydts/quard_star_sbi.dts

$(TARGET): $(STARTUP_OBJ)
	$(CC) $(CFLAGS) $(STARTUP_OBJ) -o $@

$(BIN): $(TARGET)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $< $@

$(LIST): $(TARGET)
	$(OBJDUMP) $(OBJDUMP_FLAGS) $< > $@

#
#		| 偏移地址 (KB) | 内容                     |
#		|---------------|--------------------------|
#		| 0             | 二进制文件 `$(BIN)`      |
#		| 512           | 设备树文件 `$(DTB)`      |
#		| 2k            | opensbi                  |
#		| 其他位置      | 填充为零（未修改）       |
#

$(FW_BIN): $(DTB) $(OPENSBI_BIN) $(BIN)
	dd if=/dev/zero of=$(FW_BIN) bs=1k count=32k
	dd if=$(BIN) of=$(FW_BIN) bs=1k conv=notrunc seek=0
	dd if=$(DTB) of=$(FW_BIN) bs=1k conv=notrunc seek=512
	dd if=$(OPENSBI_BIN) of=$(FW_BIN) bs=1k conv=notrunc seek=2K 

$(OPENSBI_BIN):
	cd ../opensbi && make CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=quard_star
	cp -r ../opensbi/build/platform/quard_star/firmware/fw_jump.bin $(OPENSBI_BIN)

# Clean up build artifacts
clean:
	rm -f build/*

.PHONY: all clean
