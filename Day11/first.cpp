#include <stdint.h>
#include <iostream>
#include <ostream>
#include <fstream>
#include <string>
#include <memory>
#include <cmath>

class Stone{
    private:
        uint64_t value;
        Stone* next;

    public:
        Stone(int64_t number) {
            this->value = number;
            this->next = nullptr;
        }

        int64_t getValue () {
            return this->value;
        }

        Stone* getNext() {
            return this->next;
        }

        void setNext(Stone* nextStone) {
            this->next = nextStone;
        }

        friend std::ostream& operator<<(std::ostream& os, const Stone& s) {
            os << s.value;
            if (s.next !=nullptr) {
                os << " " << *s.next;
            }

            return os;
        }

        void blink() {
            if (this->value == 0) {
                this->value = 1;
                return;
            }
            auto digits = std::floor(std::log10(this->value)) + 1.0;
            if ((int) digits %2 == 0) {
                auto first = (int64_t) (this->value / pow(10, digits/2));
                auto second = (int64_t) (this->value % (int) pow(10, digits/2));
                // std::cout<< "Split " << this->value << " into " << first << " and " << second << std::endl;
                auto next = this->next;
                this->value = first;
                this->next = new Stone(second);
                if (this->next == nullptr) {
                    std::cerr << "Error allocating pointer"<<std::endl;
                }
                this->next->setNext(next);
                return;
            }
            this->value = value * 2024;
            return;
        }
};



Stone* parseInput(char* filename) {
    Stone* current =nullptr;
    Stone* last =nullptr;
    Stone* head =nullptr;

    std::cout << "Reading file: " << filename << std::endl;
    std::ifstream myfile( filename, std::ios_base::in);

    int64_t temp;
    while (myfile >> temp)    {
        // std::cout<< "Got value: "<< temp << std::endl;
        current = new Stone(temp);
        if (last != nullptr) {
            last->setNext(current);
        } else {
            head = current;
        }
        last = current;
    }

    return head;
}

void blink(Stone* current) {

    while(current != nullptr) {
        auto next = current->getNext();
        current->blink();
        current = next;
    }
}

int count(Stone* current) {
    int result = 0;
    while(current != nullptr) {
        result += 1;
        current = current->getNext();
    }
    return result;
}

int main(int argc, char* argv[]) {
    auto head = parseInput(argv[1]);

    std::cout << *head << std::endl;
    for(int i = 1; i <= 25; i++) {
        blink(head);
        std::cout << "After " << i << " iterations, there are " << count(head) << " stones." << std::endl;
    }
    return 0;
}
