TARGET = proy_1
CC = gcc
AS = gcc
RM = rm -f
ASFLAGS = -O0 -g -c

.PHONY: all
all: $(TARGET)

proy_1: proy_1.o input.o

proy_1.o: proy_1.s

input.o: input.s

.PHONY: clean
clean:
	$(RM) *.o $(TARGET)
