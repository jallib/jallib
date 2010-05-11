// setup of oscillator.

#define FOSC 14745600                 /* External clock input frequency (must be between 10 MHz and 25 MHz) */

#define USE_PLL 1                     /* 0 = do not use on-chip PLL,
                                         1 = use on-chip PLL) */
#define PLL_MUL 4                     /* PLL multiplication factor (1 to 32) */
#define PLL_DIV 2                     /* PLL division factor (1, 2, 4, or 8) */
