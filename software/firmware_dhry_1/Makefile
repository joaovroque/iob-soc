ROOT_DIR:=../..
include ../software.mk

#additional compiler flags
CFLAGS+=--specs=nano.specs -Wl,-Bstatic,-T,../template.lds,-Map,firmware.map,--strip-debug

#SUBMODULES

#cache
ifeq ($(USE_DDR),1)
include $(CACHE_DIR)/software/software.mk
endif

#peripherals (embedded)
$(foreach p, $(PERIPHERALS), $(eval include $(SUBMODULES_DIR)/$p/software/embedded/embedded.mk))


NUMBER_OF_RUNS = 100

#HEADERS
HDR+= dhry.h periphs.h

#SOURCES
SRC+= dhry_1.c dhry_2.c stdlib.c syscalls.c firmware.S

#RULES
run: firmware.elf

firmware.elf: ../template.lds $(HDR) $(SRC)
	$(TOOLCHAIN_PREFIX)gcc -o $@ $(CFLAGS) $(DEFINE) -DRISCV -DTIME -DNUMBER_OF_RUNS=$(NUMBER_OF_RUNS) $(INCLUDE) $(SRC) -lgcc -lc -lnosys	
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin

#peripherals' base addresses
periphs.h: periphs_tmp.h
	is_diff=`diff -q $@ $<`; if [ 'is_diff' ]; then cp $< $@; fi
	@rm periphs_tmp.h

periphs_tmp.h:
	$(foreach p, $(PERIPHERALS), $(shell echo "#define $p_BASE (1<<$P) |($p<<($P-N_SLAVES_W))" >> $@) )

clean:
	@rm -rf firmware.bin firmware.elf firmware.map *.hex ../periphs.h *~

.PHONY: run clean subs periphs_tmp.h
