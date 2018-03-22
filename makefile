all: semaphore.o
	
semaphore.o: semaphore.asm
	nasm -f elf64 -o semaphore.o semaphore.asm

clean:
	rm -rf semaphore.o