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
        std::shared_ptr<Stone> next;

        void blink_next() {
            if(this->next != nullptr) {
                this->next->blink();
            }
        }

    public:
        Stone(int64_t number) {
            this->value = number;
            this->next = nullptr;
        }

        int64_t getValue () {
            return this->value;
        }

        std::shared_ptr<Stone> getNext() {
            return this->next;
        }

        void setNext(std::shared_ptr<Stone> nextStone) {
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
                this->blink_next();
                return;
            }
            auto digits = std::floor(std::log10(this->value)) + 1.0;
            if ((int) digits %2 == 0) {
                auto first = (int64_t) (this->value / pow(10, digits/2));
                auto second = (int64_t) (this->value % (int) pow(10, digits/2));
                // std::cout<< "Split " << this->value << " into " << first << " and " << second << std::endl;
                auto next = this->next;
                this->value = first;
                this->next = std::make_shared<Stone>(second);
                if (this->next == nullptr) {
                    std::cerr << "Error allocating pointer"<<std::endl;
                }
                this->next->setNext(next);
                if(next != nullptr) {
                    next->blink();
                }
                return;
            }
            this->value = value * 2024;
            this->blink_next();
            return;
        }

        int64_t count(int64_t initialValue) {
            if(this->next == nullptr) {
                return initialValue + 1;
            }
            return this->next->count(initialValue+1);
        }
};



std::shared_ptr<Stone>  parseInput(char* filename) {
    std::shared_ptr<Stone> current =nullptr;
    std::shared_ptr<Stone> last =nullptr;
    std::shared_ptr<Stone> head =nullptr;

    std::cout << "Reading file: " << filename << std::endl;
    std::ifstream myfile( filename, std::ios_base::in);

    int64_t temp;
    while (myfile >> temp)    {
        // std::cout<< "Got value: "<< temp << std::endl;
        current = std::make_shared<Stone>(temp);
        if (last != nullptr) {
            last->setNext(current);
        } else {
            head = current;
        }
        last = current;
    }

    return head;
}

int main(int argc, char* argv[]) {
    auto head = parseInput(argv[1]);

    std::cout << *head << std::endl;
    for(int i = 1; i <= 25; i++) {
        head->blink();
        std::cout << "After " << i << " iterations, there are " << head->count(0) << " stones." << std::endl;
        // if (i< 7) {
        //     std::cout << *head << std::endl;            
        // }
    }
    return 0;
}
