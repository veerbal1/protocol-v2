# LEARNING STATE

## Current Position
- Ring: 3 of 26
- Active Concept: 10-14 (The robot trader: counterparty problem, AMM, constant product, reserves, peg)
- Status: In Progress

## Progress Overview

### PHASE 1 - THE WORLD
- [x] Ring 1: Trading, futures, perpetual, exchange -- COMPLETED
- [x] Ring 2: Long, short, PnL, collateral, margin, leverage -- COMPLETED

### PHASE 2 - THE ENGINE
- [ ] Ring 3: AMM, constant product, price from reserves, peg -- IN PROGRESS
- [ ] Ring 4: Solana accounts, four pillars, precision, safe math

### PHASE 3 - THE TRADE
- [ ] Ring 5: PerpPosition struct, base/quote, direction
- [ ] Ring 6: Order struct, types, lifecycle, reduce-only, post-only
- [ ] Ring 7: Dutch auctions, keepers, fill flow, fees-on-fill
- [ ] Ring 8: Position updates: open/increase/decrease/close

### PHASE 4 - THE PRICING ENGINE
- [ ] Ring 9: AMM internals: reserves, sqrt_k, exposure, OI, bounds
- [ ] Ring 10: Oracles, price feeds, TWAP, strict pricing
- [ ] Ring 11: Spreads: what they are, bid/ask, asymmetry
- [ ] Ring 12: Living spreads: inventory, volatility, revenue retreat

### PHASE 5 - ONGOING COSTS
- [ ] Ring 13: Fee flow, accumulation, pools, total_fee_minus_distributions
- [ ] Ring 14: Funding rate, mark vs oracle, asymmetry, capping

### PHASE 6 - RISK
- [ ] Ring 15: Spot as collateral: SpotPosition, scaled_balance, get_token_value
- [ ] Ring 16: PnL calculation: exit - entry, AMM and oracle valuation
- [ ] Ring 17: Per-position margin: types, ratios, IMF, size premium
- [ ] Ring 18: Portfolio margin: PnL weights, aggregation, total collateral
- [ ] Ring 19: PnL settlement: pool, +/-, imbalance, margin check
- [ ] Ring 20: Liquidation: triggers, partial, fees, statuses
- [ ] Ring 21: Bankruptcy, social loss, insurance fund, contract tiers

### PHASE 7 - AMM HEALTH
- [ ] Ring 22: Repeg, K updates, AMM JIT
- [ ] Ring 23: Matching engine, fulfillment methods, crossing

### PHASE 8 - ADVANCED
- [ ] Ring 24: LP system: shares, sqrt_k, settlement, rebase
- [ ] Ring 25: Market lifecycle: statuses, pauses, expiry, delisting
- [ ] Ring 26: Special modes & infrastructure: high leverage, isolated, prediction, guard rails, events, full spot deep dive, DEX

## Mastery Notes

### Ring 1
- User knows long/short conceptually at a basic/UI level but does NOT actively trade perps. Do not assume trader intuition for PnL math, funding, liquidations, etc. Verify from scratch.
- Initial sticking point: "how can someone sell a promise for something they don't have?" -- landed once reframed as "a recorded bet in a database whose value tracks an external price." The word "promise" confused them; "bet" / "agreement" stuck.
- BREAKTHROUGH at Ring 1 close: user independently derived the counterparty matching problem -- "if I'm long $50, someone must be short $50; how does the protocol find exact opposite amounts among thousands of traders?" This IS the motivating question for the entire AMM (Rings 3, 9-12) and matching engine (Ring 23). They think at the system-design level, not just mechanics -- lean into this.
- Analogy that worked: "rain is independent, it happens on its own" -- user used this to explain that the underlying asset's price is separate from the bet. Reuse this framing when we introduce oracles (Ring 10).
- User prefers the word "bet" over "promise" -- stick with "bet" / "agreement" going forward.

### Ring 2
- Entered Ring 2 with the stock-market short-selling mental model ("Bob borrowed BTC, sold at $50k, rebought at $45k, kept the difference"). Classic perp-learner trap. Corrected by asking them to spot the contradiction with Ring 1 ("if longs don't touch real BTC, why would shorts?"). Landed cleanly.
- Ideas 5 (long/short) and 6 (PnL) now locked in. User understands: direction is just a sign, PnL flows between long and short as price moves, no asset is ever physically exchanged.
- Moving to idea 7 (collateral). Per the plan, this is where Ring 2 slows down -- collateral/margin/leverage are the genuinely new material for this user.
- Ring 2 closed out cleanly. User tends to give TERSE but CORRECT answers ("10,000", "trader a still alive"). Don't mistake brevity for shallow understanding -- they track the math, they just don't always spell it out. When they're terse, fill in the math on paper for the record, then keep moving.
- User asked to skip the collateral/margin check question ("i understand, let's move") but passed the follow-up leverage-math verification cleanly. They're pacing themselves; trust it but still verify at ring boundaries.
- STYLE PREFERENCE (explicit, mid-Ring-3): user wants pure atomic Socratic -- one variable per question, no multi-part questions, no explanation dumps, no recapping lists of ideas. Ask, wait, push one layer deeper. Don't spoon-feed answers. If they use jargon, make them define it first. Keep the ring framework (required by CLAUDE.md) but tighten style sharply within it.

## Vocabulary Unlocked
- trading, buying, selling
- future (a bet on what a price WILL be)
- perpetual (a bet that never expires)
- exchange / marketplace / middleman (the program that holds money, tracks bets, forces payouts)
- bet / agreement (the record that tracks a position's value)
- long (bet that price goes up)
- short (bet that price goes down)
- PnL / profit and loss (money flowing between sides as price moves; drains from loser's collateral, adds to winner's)
- collateral (locked deposit guaranteeing you can pay if you lose; USDC on Drift)
- margin / margin requirement (required collateral-to-size ratio, enforced before a bet can open; stored as margin_ratio_initial per market)
- leverage (bet size / collateral ratio; inverse of margin; e.g. 5% margin = up to 20x leverage)
- liquidation (teaser only: forcible bet closure before collateral hits zero; full topic in Ring 20)

## Next Up
- Current ring (Ring 3) covers: the counterparty problem (already derived by user in Ring 1), AMM, constant product (x*y=k), how an AMM prices from reserves, peg multiplier.
- This is the ring the user has been hungry for since their Ring 1 breakthrough. Open Ring 3 by explicitly calling back their question -- they earned this payoff.
- Teaser for Ring 4: once AMM concepts click, we go on-chain: Solana accounts, the four pillars (State/PerpMarket/CollateralMarket/User), fixed-point precision, safe math.
