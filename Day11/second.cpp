#include <stdint.h>
#include <iostream>
#include <ostream>
#include <fstream>
#include <string>
#include <memory>
#include <cmath>
#include <map>


int printDB(std::map<int64_t, int64_t> current) {
    int result = 0;
    std::map<int64_t, int64_t>::iterator it;

    std::cout << "DB content:" << std::endl;
    for (it = current.begin(); it != current.end(); it++)    {
        auto value = it->first;
        auto count = it->second;

        std::cout << value <<": " << count <<std::endl;
    }
    return result;
}

auto insert(std::map<int64_t, int64_t> &database, int64_t value, int64_t count) {
         if (database.find(value) == database.end()) {
             database[value] = 0;
         }
         database[value] = database[value] + count;
}


auto parseInput(char* filename ) {
    std::map<int64_t, int64_t> database;
    std::cout << "Reading file: " << filename << std::endl;
    std::ifstream myfile( filename, std::ios_base::in);

    int64_t temp;
    while (myfile >> temp)    {
         insert(database, temp, 1);
    }
    printDB(database);
    return database;
}

auto blink(std::map<int64_t, int64_t> current) {
    std::map<int64_t, int64_t> newDb;
    std::map<int64_t, int64_t>::iterator it;

    for (it = current.begin(); it != current.end(); it++)    {
        auto value = it->first;
        auto count = it->second;

        if (value == 0) {
            insert(newDb, 1, count);
            continue;
        }

        auto digits = std::floor(std::log10(value)) + 1.0;
        if ((int) digits %2 == 0) {
            auto first = (int64_t) (value / pow(10, digits/2));
            auto second = (int64_t) (value % (int) pow(10, digits/2));
            insert(newDb, first, count);
            insert(newDb, second, count);
            continue;
        }
        insert(newDb, value*2024, count);
    }
    return newDb;
}

auto count(std::map<int64_t, int64_t> current) {
    int64_t result = 0;
    std::map<int64_t, int64_t>::iterator it;

    for (it = current.begin(); it != current.end(); it++)    {
        auto count = it->second;
        result += count;
    }
    return result;
}

int main(int argc, char* argv[]) {
    auto db = parseInput(argv[1]);
    for(int i = 1; i <= 75; i++) {
        db = blink(db);
        std::cout << "After " << i << " iterations, there are " << count(db) << " stones." << std::endl;
    }
    return 0;
}
