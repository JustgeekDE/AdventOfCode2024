#include <stdio.h>
#include <stdlib.h>

#define FILE_OPEN_FAILURE 1

int parseInput(char* filename) {
    printf("Loading file %s\n", filename);

    FILE *file;
    char buffer[256]; 

    file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file");
        return FILE_OPEN_FAILURE;
    }

    printf("Parsing data\n");
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("Data: %s", buffer); // Print each line
    }

    fclose(file);

    return 0;
}

int main(int argc, char* argv[]) {
   return parseInput("example.txt");
}
