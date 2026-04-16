#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/programs/drift/src"
OUT="$ROOT/drift_perp_futures_context.md"

cat > "$OUT" <<'EOF'
# Drift Protocol v2 - Perpetual Futures File Map

All paths relative to `programs/drift/src/`

## 1. Market State & Account Structures

| File | Level | Description |
|------|-------|-------------|
| `state/perp_market.rs` | CRITICAL | PerpMarket + AMM structs, MarketStatus, ContractType, PoolBalance |
| `state/user.rs` | CRITICAL | User account, PerpPosition, Order, OrderType, SpotPosition |
| `state/state.rs` | CRITICAL | Global State, FeeStructure, FeeTier, OracleGuardRails |
| `state/margin_calculation.rs` | CRITICAL | MarginCalculation, MarginContext, MarginCalculationMode |
| `state/oracle.rs` | CRITICAL | OraclePriceData, OracleSource, HistoricalOracleData, StrictOraclePrice |
| `state/perp_market_map.rs` | IMPORTANT | PerpMarketMap loader, MarketSet for writable markets |
| `state/oracle_map.rs` | IMPORTANT | OracleMap - loads/caches oracle accounts |
| `state/spot_market.rs` | IMPORTANT | SpotMarket - collateral markets for PnL settlement |
| `state/order_params.rs` | IMPORTANT | OrderParams struct, PostOnlyParam, ModifyOrderParams |
| `state/fulfillment.rs` | IMPORTANT | PerpFulfillmentMethod enum (AMM vs Match) |
| `state/paused_operations.rs` | IMPORTANT | PerpOperation bitflags for granular pause controls |
| `state/events.rs` | IMPORTANT | All event/record types emitted on-chain |
| `state/spot_market_map.rs` | SUPPORTING | SpotMarketMap loader |
| `state/user_map.rs` | SUPPORTING | UserMap for loading maker accounts |
| `state/fill_mode.rs` | SUPPORTING | FillMode enum |
| `state/settle_pnl_mode.rs` | SUPPORTING | SettlePnlMode enum |
| `state/liquidation_mode.rs` | SUPPORTING | LiquidatePerpMode |
| `state/high_leverage_mode_config.rs` | SUPPORTING | High-leverage mode config |
| `state/pyth_lazer_oracle.rs` | SUPPORTING | Pyth Lazer oracle format |
| `state/traits.rs` | SUPPORTING | Size trait and MarketIndexOffset |
| `state/fulfillment_params/drift.rs` | SUPPORTING | Internal match fulfillment params |
| `state/fulfillment_params/openbook_v2.rs` | SUPPORTING | OpenBook v2 integration |
| `state/fulfillment_params/phoenix.rs` | SUPPORTING | Phoenix DEX integration |
| `state/fulfillment_params/serum.rs` | SUPPORTING | Serum DEX integration |

## 2. Math (Pure Computation)

| File | Level | Description |
|------|-------|-------------|
| `math/constants.rs` | CRITICAL | All precision constants: PRICE, BASE, QUOTE, MARGIN |
| `math/amm.rs` | CRITICAL | AMM math: calculate_price, calculate_swap_output, TWAP |
| `math/amm_spread.rs` | CRITICAL | Dynamic spread: inventory, volatility, oracle-based |
| `math/position.rs` | CRITICAL | Position valuation: base_asset_value, PnL with oracle/AMM |
| `math/pnl.rs` | CRITICAL | Core PnL: exit_value vs entry_value |
| `math/orders.rs` | CRITICAL | Order math: AMM fill amount, position deltas, limit prices |
| `math/matching.rs` | CRITICAL | Maker/taker matching: do_orders_cross, fill calculation |
| `math/fulfillment.rs` | CRITICAL | determine_perp_fulfillment_methods - AMM vs Match priority |
| `math/funding.rs` | CRITICAL | Funding rate: long/short rates, capping, payment calc |
| `math/margin.rs` | CRITICAL | Margin engine: requirement calc, IMF, size premium |
| `math/liquidation.rs` | CRITICAL | Liquidation math: margin shortage, fees, multipliers |
| `math/fees.rs` | CRITICAL | Fee calc: taker fee, maker rebate, filler reward |
| `math/oracle.rs` | CRITICAL | Oracle validity: staleness, volatility, divergence |
| `math/auction.rs` | IMPORTANT | Dutch auction pricing for market orders |
| `math/amm_jit.rs` | IMPORTANT | AMM JIT: protocol participates in maker fills |
| `math/repeg.rs` | IMPORTANT | Repeg math: cost to adjust peg |
| `math/cp_curve.rs` | IMPORTANT | Constant-product curve: update_k, budgeted_k_scale |
| `math/bankruptcy.rs` | IMPORTANT | Bankruptcy detection |
| `math/quote_asset.rs` | SUPPORTING | Reserve <-> asset conversion with peg |
| `math/spot_balance.rs` | SUPPORTING | Spot balance math for collateral |
| `math/safe_math.rs` | SUPPORTING | Checked arithmetic (SafeMath trait) |
| `math/casting.rs` | SUPPORTING | Safe numeric type casting |
| `math/bn.rs` | SUPPORTING | U192 big number type |
| `math/helpers.rs` | SUPPORTING | get_proportion_u128 and numeric helpers |
| `math/stats.rs` | SUPPORTING | TWAP, rolling sum, weighted average |
| `math/fuel.rs` | SUPPORTING | Fuel (incentive points) calculations |
| `math/spot_swap.rs` | SUPPORTING | Spot swap pricing for liquidation swaps |

## 3. Controllers (Execution / State Mutation)

| File | Level | Description |
|------|-------|-------------|
| `controller/orders.rs` | CRITICAL | Main orchestrator: place/fill/cancel perp orders |
| `controller/position.rs` | CRITICAL | Position updates: open/close/increase/decrease |
| `controller/amm.rs` | CRITICAL | AMM execution: swap, update_spreads, formulaic_update_k |
| `controller/funding.rs` | CRITICAL | settle_funding_payment, update_funding_rate |
| `controller/pnl.rs` | CRITICAL | settle_pnl against PnL pool |
| `controller/liquidation.rs` | CRITICAL | All liquidation types: perp, spot, bankruptcy |
| `controller/repeg.rs` | IMPORTANT | Re-peg AMM to oracle |
| `controller/lp.rs` | IMPORTANT | LP share operations: settle, rebase |
| `controller/isolated_position.rs` | IMPORTANT | Isolated margin position transfers |
| `controller/spot_balance.rs` | IMPORTANT | Spot balance updates for PnL/revenue pools |
| `controller/pnl/delisting.rs` | IMPORTANT | Delisting-specific PnL settlement |
| `controller/spot_position.rs` | SUPPORTING | Spot position balance updates |
| `controller/insurance.rs` | SUPPORTING | Insurance fund management |
| `controller/token.rs` | SUPPORTING | SPL token transfers |
| `controller/pda.rs` | SUPPORTING | PDA derivation |

## 4. Instruction Handlers (Entrypoints)

| File | Level | Description |
|------|-------|-------------|
| `instructions/user.rs` | CRITICAL | User: place/cancel orders, deposit, withdraw, settle |
| `instructions/keeper.rs` | CRITICAL | Keeper: fill orders, update funding, liquidate |
| `instructions/admin.rs` | IMPORTANT | Admin: initialize markets, update params |
| `instructions/optional_accounts.rs` | IMPORTANT | load_maps - AccountMaps from remaining_accounts |
| `instructions/constraints.rs` | SUPPORTING | Anchor account validation constraints |

## 5. Validation

| File | Level | Description |
|------|-------|-------------|
| `validation/order.rs` | IMPORTANT | Order validation by type |
| `validation/margin.rs` | IMPORTANT | Margin ratio parameter validation |
| `validation/perp_market.rs` | SUPPORTING | Perp market config validation |
| `validation/position.rs` | SUPPORTING | Position invariant validation |
| `validation/fee_structure.rs` | SUPPORTING | Fee structure bounds checking |
| `validation/user.rs` | SUPPORTING | User account validation |

## 6. Program Entrypoint

| File | Level | Description |
|------|-------|-------------|
| `lib.rs` | CRITICAL | Program entrypoint, instruction routing |
| `error.rs` | SUPPORTING | ErrorCode enum |

---

**Totals:** 80 files (30 CRITICAL, 22 IMPORTANT, 28 SUPPORTING)
EOF

echo "Done: $OUT ($(wc -l < "$OUT" | tr -d ' ') lines, $(du -h "$OUT" | cut -f1))"
