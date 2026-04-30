#define RURAL_TAX 500 // Daily mint at dawn. Floor at/above RURAL_TAX_POP_HIGH effective players.
#define RURAL_TAX_LOWPOP 750 // Daily mint at/below RURAL_TAX_POP_LOW effective players.
#define RURAL_TAX_POP_LOW 12 // At or below this active player count, RURAL_TAX_LOWPOP applies.
#define RURAL_TAX_POP_HIGH 50 // At or above this active player count, RURAL_TAX applies. Linearly interpolated between.
#define TREASURY_TICK_AMOUNT 6 MINUTES
