#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#define FILE_OPEN_FAILURE 1
#define ASCENDING 1
#define DESCENDING -1


typedef struct DataRow{
    uint8_t size;
    uint8_t* data;
    struct DataRow* next;

} DataRow;

uint8_t getNrOfNumbers(char* line){

    char* current = line;
    uint8_t count = 1;
    while (*line != '\0') {
        if (*line == ' ' ) {
            count++;
        }
        line++;
    }
    return count;

}

DataRow* parseLine(char* line) {
    uint8_t nrOfNumbers = getNrOfNumbers(line);

    DataRow *data = malloc(sizeof(DataRow));
    data->data = malloc(sizeof(uint8_t) * nrOfNumbers);
    data->size = nrOfNumbers;
    data->next = NULL;
    
    uint8_t* number = data->data;
    char* ptr = line;

    while (sscanf(ptr, "%2" SCNu8, number) == 1) {
            number++;

            char *next_space = strchr(ptr, ' ');
            if (next_space == NULL) {
                break; // No more spaces, exit the loop
            }
            ptr = next_space + 1;
        }

    return data;

}

int parseInput(char* filename, DataRow** head) {
    printf("Loading file %s\n", filename);

    FILE *file;
    char buffer[256]; 
    DataRow* current;
    DataRow* last = NULL;

    file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file");
        return FILE_OPEN_FAILURE;
    }

    printf("Parsing data\n");
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        current = parseLine(buffer);
        if (last != NULL){
            last->next = current;
        } else {
            *head = current;
        }
        last = current;
    }

    fclose(file);

    return 0;
}

void printData(DataRow* data) {
    printf("Size %d: ", data->size);
    for(uint8_t i=0; i <= data->size; i++) {
        printf(" %d", data->data[i]);
    }
    // printf("\n");
}

uint16_t isSafe(DataRow* data) {
    int8_t direction = 0;

    for(uint8_t i=1; i < data->size; i++) {
        int8_t difference = data->data[i] - data->data[i-1];
        if (difference == 0) {
            return 0;
        }
        // printf("%d: %d - %d = %d\n",i, data->data[i], data->data[i-1],difference);

        if (difference < 0) {
            if (difference < -3) {
                return 0;
            }
            if (direction == ASCENDING) {
                return 0;
            }
            direction = DESCENDING;
        } else {
            if (difference > 3) {
                return 0;
            }
            if (direction == DESCENDING) {
                return 0;
            }
            direction = ASCENDING;
        }
    }
    printData(data);
    printf(" is safe\n");
    return 1;

}


uint16_t calculateSafeReadings(DataRow* data) {
    uint16_t safeReadings = 0;
    uint16_t count = 0;

    while (data != NULL) {
        
        safeReadings += isSafe(data);
        data = data->next;
        count++;
    }
    printf("Checked %d inputs\n", count);
    return safeReadings;
}

int main(int argc, char* argv[]) {
    DataRow* data;
    if(parseInput(argv[1], &data) != 0){
        return 1;
    }
    uint16_t result = calculateSafeReadings(data);
    printf("Got %d safe readings\n", result);


    return 0;
}
