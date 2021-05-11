//
// Created by Steven on 5/10/2021.
//

#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char** argv) {

    printf(1, "proc 2 (pid: %d)\n", getpid());

    set_prior(8);
    int i,k;
    for (i = 0; i < 43000; ++i) {
        asm("nop");
        for (k = 0; k < 43000; ++k) {
            asm("nop");
        }
    }

    exit();
}