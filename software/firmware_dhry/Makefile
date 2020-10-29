ROOT_DIR:=../..
include ../software.mk


#include peripherals
dummy:=$(foreach p, $(PERIPHERALS), $(eval include $(SUBMODULES_DIR)/$p/software/embedded/embedded.mk))

NUMBER_OF_RUNS = 100

#local flags
CFLAGS+=--specs=nano.specs -Wl,-Bstatic,-T,../template.lds,-Map,firmware.map,--strip-debug

#local sources
HDR+= periphs.h
SRC+= dhry_1.c dhry_2.c stdlib.c syscalls.c firmware.S

run: firmware.elf

firmware.elf: dhry.lds $(HDR) $(SRC)
	$(TOOLCHAIN_PREFIX)gcc -O3 -ffreestanding -nostdlib -march=rv32im -mabi=ilp32 -Wno-implicit-int -Wno-implicit-function-declaration -o firmware.elf $(DEFINE) -DRISCV -DTIME -DNUMBER_OF_RUNS=$(NUMBER_OF_RUNS) $(INCLUDE) $(SRC) --std=gnu99 -Wl,-Bstatic,-T,dhry.lds,-Map,firmware.map,--strip-debug -lgcc -lc -lnosys
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin

periphs.h: periphs_tmp.h
	is_diff=`diff -q $@ $<`; if [ 'is_diff' ]; then cp $< $@; fi
	@rm periphs_tmp.h

periphs_tmp.h:
	$(foreach p, $(PERIPHERALS), $(shell echo "#define $p_BASE (1<<$P) |($p<<($P-N_SLAVES_W))" >> $@) )

clean: 
	@rm -rf firmware.bin firmware.elf firmware.map *.hex ../periphs.h

.PHONY: run clean subs periphs_tmp.h
