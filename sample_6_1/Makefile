# Makefile

MAIN=ckt

# all
all: ${MAIN}.vcd

# user definitiones
VLFILES=decoder.v ${MAIN}.v
# user dependencies
decoder.sfl: decoder.sfh
ckt.nsl: decoder.sfh

# system definitiones
NSLC=./nc.sh
IVERILOG=iverilog
VVP=vvp
RM=/bin/rm
RM_F=/bin/rm -f --

# suffix rules
.SUFFIXES: .vcd .vvp .v .nsl .sfl
.sfl.v:
	${NSLC} -sfl_only -f $< -sim > $@ || ( stat=$$? ; ${RM} $@ ; exit $$stat )
.nsl.v:
	${NSLC} -f $< -sim > $@ || ( stat=$$? ; ${RM} $@ ; exit $$stat )
.v.vvp:
	${IVERILOG} -o $@ $>
.vvp.vcd:
	${VVP} $<

# main dependencies
${MAIN}.vvp: ${VLFILES}
# special rule for main
${MAIN}.v:
	${NSLC} -f $> -verisim2 -target ${MAIN} -start_init 100 -sim > $@ || ( stat=$$? ; ${RM} $@ ; exit $$stat )

# clean
clean:
	${RM_F} ${MAIN}.vcd ${MAIN}.vvp ${VLFILES}
