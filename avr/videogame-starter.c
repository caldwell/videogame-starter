// Copyright (c) 2014 David Caldwell <david@porkrind.org>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <stdbool.h>

#define PLAYER1_IN_PIN  0
#define PLAYER2_IN_PIN  1
#define PLAYER1_OUT_PIN 2
#define PLAYER2_OUT_PIN 3
#define COIN_OUT_PIN    4

bool player1_pressed() { return PINC & 1<<PLAYER1_IN_PIN; }
bool player2_pressed() { return PINC & 1<<PLAYER2_IN_PIN; }
void pulse_output(unsigned pin)
{
    PORTC &= ~(1<<pin);
    _delay_ms(250);
    PORTC |= 1<<pin;
    _delay_ms(250);
}
void insert_coin()   { pulse_output(COIN_OUT_PIN); }
void press_player1() { pulse_output(PLAYER1_OUT_PIN); }
void press_player2() { pulse_output(PLAYER2_OUT_PIN); }

int main(void)
{
    DDRC = 1<<DDC4 | 1<<DDC5;

    for(;;) {
        if (player1_pressed()) {
            insert_coin();
            press_player1();
        }
        if (player2_pressed()) {
            insert_coin();
            insert_coin();
            press_player2();
        }
    }

    return 0;   /* never reached */
}
