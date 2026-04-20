# LEARNING STATE

## Current Position
- Ring: 5 of 26
- Active Concept: 20-24 (PerpPosition struct, base/quote amounts, direction)
- Status: In Progress (signed base + signed quote locked in; fees/break-even pending)

## Progress Overview

### PHASE 1 - THE WORLD
- [x] Ring 1: Trading, futures, perpetual, exchange -- COMPLETED
- [x] Ring 2: Long, short, PnL, collateral, margin, leverage -- COMPLETED

### PHASE 2 - THE ENGINE
- [x] Ring 3: AMM, constant product, price from reserves, peg -- COMPLETED
- [x] Ring 4: Solana accounts, four pillars, precision, safe math -- COMPLETED

### PHASE 3 - THE TRADE
- [ ] Ring 5: PerpPosition struct, base/quote, direction -- IN PROGRESS
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

### Ring 3
- User independently derived FOUR major concepts: (1) x*y=k with y/x = price, correctly mapping y=USDC, x=BTC; (2) virtual reserves insight -- "AMM does not actually have any BTC reserve, just collateral" -- caught this on their own, usually a taught concept not a derived one; (3) arbitrage as a gap-closer -- "won't traders long to capture the 50k vs 55k gap?"; (4) peg-induced instant PnL redistribution -- "if peg moves, longs win instantly and shorts lose instantly."
- Teaching pattern that worked: stress-test the user's "simple oracle-only AMM" hypothesis with a concrete pile-in scenario ($100 long x 1M traders x 20% move = $20M owed). Made them FEEL why a curve is needed. They derived the mechanism from the pain.
- CONFUSION MODE: user shuts down with "no idea what you are telling" when a scenario has too many variables at once (1M traders + $5M + oracle ticks in one question). Fix: one variable at a time. One trader, one move. Scale up in separate turns.
- Self-aware: user explicitly flagged "partially understand, not solid" and later "what if there are hidden parts I don't know" -- honor this, do audits at ring close. They prefer honesty over false completion.
- Mini-callbacks landed well: when user asked "is this x*y?" mid-derivation, parking the formula for one more atomic step ("price moves which direction?") forced them to verbalize the mechanism BEFORE seeing the formula name. Do this again.
- Vocabulary introduced at Ring 3 close: `mark_price` (the AMM's quoted price = (y/x) * peg_multiplier), `slippage` (teaser -- own trade moves price; full math Ring 9).
- Forward refs planted for Rings 9 (price impact), 10 (oracles), 11 (bid/ask spread), 14 (funding rate), 22 (repeg cost/triggers), 24 (where virtual reserves come from / LPs). Don't let these become vapor -- resurface each when its ring opens.

### Ring 5 (in progress)
- Opening move: "minimum info to compute PnL a week later" -- user initially listed collateral + leverage + entry + direction. Used the PnL arithmetic check ($200 on long 10 SOL, $100->$120) to make them SEE that collateral/leverage didn't appear in the formula. They self-identified entry + direction as the ones they actually used. Worked cleanly.
- Size was the hidden one -- they implicitly used "× 10" but didn't list "size" originally. Caught it when asked where the 10 came from. Small gap, fast fix.
- Signed encoding (+10 long, -10 short): derived instantly and unprompted. "+means long, - means short" -- no resistance.
- Quote-as-notional-not-collateral: user asked the right question ("is quote direct collateral or leverage included amount?") -- that's a real design-level instinct. Framed the $100 vs $1000 scenario; they picked $1000 correctly.
- Sign of quote: FIRST INSTINCT WRONG -- guessed long=+quote, short=-quote. Before pushing further, user flagged CONFUSION explicitly: "im not seeing full picture... we studying in chunks and a lot of questions. Do you think about this?" -- good self-advocacy. Honor it.
- RESPONSE: zoomed out and delivered the full two-field layout as a table (base_asset_amount + quote_asset_amount, signed, opposite signs, IN=+ OUT=-). Did NOT force the derivation when they were confused. This user tolerates atomic style well on solid ground (Rings 3-4) but asks for the map when genuinely lost. Track this -- pattern is "atomic until stuck, then give the frame."
- STYLE CALIBRATION: atomic Socratic works, but not as a religion. When user says "I'm confused / missing context," deliver the frame immediately, then return to atomic. Mid-ring reframes are fine -- they are NOT admissions of failure, they are part of the method for this user.
- Still pending in Ring 5: (a) confirm the sign-flip intuition is now locked (ask a short verification), (b) introduce quote_entry_amount vs quote_break_even_amount (they differ because of fees; forward ref Ring 7), (c) note that PositionDirection enum exists for ORDER flow but is NOT stored on PerpPosition (the signed base IS the direction storage).

### Ring 4
- User entered with working Solana baseline: already knew PDAs, program ownership, lamports-as-SOL-atomic-unit. Did NOT need to teach these -- confirmed and leveraged directly.
- Derived fixed-point representation unprompted: "multiply by a large scaler, store as big int, divide back on use." One atomic push was enough.
- Also derived the tradeoff unprompted: "bigger scaler = more precision, more bytes" -- correct. Add overflow risk as my own overlay.
- Nailed the scaler-matches-native-unit insight: "SOL = 10^9 lamports, can't split further, so BASE_PRECISION = 10^9." This is the real reason BASE ≠ QUOTE precision; they got it on first ask.
- Caught the numerical guardrail: when I gave price × size ~ 10^15, they noted "this will not overflow" before I baited them into it. Track this -- they check magnitudes, don't just trust handed numbers.
- Knew `checked_*` functions by name. Also independently proposed "don't calc everything in one line, break into 2-at-a-time intermediates" -- that's a real Drift pattern. Confirmed their instinct.
- Minor calibration: they said `checked_mul` "throws error." Actual return is Option<T>; error conversion via `ok_or(ErrorCode)?`. Noted but did not belabor.
- Pacing: Ring 4 moved fast (6-7 atomic beats total). Continue this tempo when user has existing adjacent knowledge; slow back down on genuinely new material (Ring 5 entry-vs-break-even, Ring 7 auctions, etc.).
- Four pillars delivered as a table at the end -- user grouped fine. No confusion about State vs PerpMarket vs SpotMarket vs User. They correctly placed AMM reserves in PerpMarket on first ask.

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
- AMM (automated market maker -- always-available robot counterparty)
- reserves / virtual reserves (x = base, y = quote; purely accounting numbers on a perp AMM, no actual BTC anywhere)
- constant product / x*y=k (the curve: as one reserve drops, the other must rise to keep product constant; price never runs out, just gets arbitrarily expensive)
- liquidity (implicitly: the size of the reserves; thicker reserves = less price impact per trade)
- peg / peg_multiplier (scalar knob in the price formula: mark_price = (y/x) * peg_multiplier; aligns AMM baseline to real-world oracle price)
- mark price (the AMM's quoted price from its formula)
- slippage (teaser only: own trade moves the price against you; full math Ring 9)
- arbitrage (user-derived: traders capture the AMM-oracle gap, which also closes the gap)
- funding rate (teaser only: indirect ongoing gap-closer; full topic Ring 14)
- repeg / repeg cost (teaser only: peg updates cost the AMM when net-exposed, paid from fee pool; full mechanics Ring 22)
- account (the universal Solana storage unit; everything -- wallets, tokens, program state -- is an account)
- PDA (program-derived address; account owned by a program with no private key, program writes freely)
- four pillars (Drift's top-level account layout: State singleton, PerpMarket per perp, SpotMarket per collateral token, User per trader subaccount)
- State / PerpMarket / SpotMarket / User (the four account types; PerpMarket holds the AMM reserves + peg + sqrt_k for its market)
- fixed-point / scaler (store decimal numbers as integers by multiplying by a fixed power of 10)
- PRICE_PRECISION = 10^6 (Drift's standard multiplier for prices)
- BASE_PRECISION = 10^9 (matches SOL's native 10^9 lamport granularity)
- QUOTE_PRECISION = 10^6 (matches USDC's native 10^6 atomic granularity)
- overflow / silent wrapping (u64 max ~1.8×10^19; Rust release-mode overflow wraps silently -- catastrophic for money math)
- checked_mul / checked_add / checked_sub / checked_div (arithmetic that returns Option<T>; None on overflow)
- ok_or(ErrorCode::MathError)? (Drift's idiom: convert Option → Result → bubble up)
- u64 (the 64-bit unsigned integer type; holds up to ~1.8×10^19)
- position record (the stored data that describes a bet: two signed numbers tracking what flowed between you and the AMM)
- base_asset_amount (signed i64 on PerpPosition; sign = direction, magnitude = size of exposure in base-asset atomic units; + = received base, − = gave up base)
- quote_asset_amount (signed i64 on PerpPosition; tracks cash flow through the trade; always OPPOSITE sign to base; stores NOTIONAL not collateral)
- signed encoding (collapsing "size + direction" into a single signed integer; Drift uses this for every position record)
- IN/OUT sign convention (from the position's perspective: what you RECEIVED is positive, what you GAVE UP is negative; applies to both base and quote)

## Next Up
- Ring 5 is MID-FLIGHT. Done so far: (1) derived the minimum 3 fields (size, entry, direction) via PnL arithmetic; (2) collapsed size+direction into one signed field (base_asset_amount); (3) established quote_amount stores NOTIONAL not collateral ($1000 vs $100 scenario); (4) delivered the two-field layout as a table after user asked for a zoom-out.
- IMMEDIATE NEXT BEAT when resuming: verify the sign-flip intuition is locked. Ask a short mirror question -- e.g. "you open SHORT 5 SOL at $200. What do base_asset_amount and quote_asset_amount store?" Correct answers: base = -5, quote = +1000. If they nail it, move on.
- After that: introduce quote_entry_amount (what quote WAS at open, before fees) vs quote_break_even_amount (the quote level needed to net-zero including fees paid). They start equal; they drift apart as fees accumulate. This is the bridge to Ring 7 (fee flow on fills).
- Also mention: PositionDirection enum exists in code for ORDER flow (Ring 6), but is NOT stored on PerpPosition -- the signed base IS the direction storage on the position record. Quick callout, not a beat.
- Source file to reveal AFTER the above: `programs/drift/src/state/user.rs` (PerpPosition struct). User can read the actual fields and match to what they derived.
- Style note (seared in from this sub-session): atomic Socratic is the default, but this user will explicitly say "I'm confused, missing context" when they need the map. Do NOT resist -- deliver the frame immediately, then return to atomic. This is not failure of the method, it IS the method for them.
- Forward refs to resurface when their ring opens: Ring 7 (entry vs break-even via fees -- IMMINENT, hit it next ring), Ring 9 (price impact, sqrt_k, open interest), Ring 10 (oracle mechanics), Ring 11 (bid/ask spread), Ring 14 (funding rate, last_cumulative_funding_rate on PerpPosition), Ring 22 (repeg), Ring 24 (LPs / virtual reserve origination).
