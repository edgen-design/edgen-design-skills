# Edgen Naming Glossary

Use these standard names for Edgen screens and components. When a layer matches a known screen or component, use the exact name from this list — do not invent alternatives.

## Billing & Subscription Screens

| Screen | Standard Name |
|--------|--------------|
| Manage Billing (plan details view) | `ManageBilling/Layout` |
| Cancel Subscription (active subscriptions list) | `CancelSubscription/Layout` |
| Purchase Success | `PurchaseSuccess/Layout` |
| Payment History (receipt list) | `ManageBilling/Layout` (same feature, different sub-view) |

## Billing & Subscription Components

| Component | Standard Name |
|-----------|--------------|
| Subscription card — Stripe | `SubscriptionCard/Stripe` |
| Subscription card — Apple Pay (Pro) | `SubscriptionCard/ApplePay-Pro` |
| Subscription card — Apple Pay (Expert) | `SubscriptionCard/ApplePay-Expert` |
| Subscription card — Google Play (Pro) | `SubscriptionCard/GooglePlay-Pro` |
| Subscription card — Google Play (Expert) | `SubscriptionCard/GooglePlay-Expert` |
| Subscription card body (wrapper) | `SubscriptionCard/Body` |
| Subscription card info (left side) | `SubscriptionCard/Info` |
| Subscription card action (button area) | `SubscriptionCard/Action` |
| Subscription list container | `SubscriptionList` |
| Billing table (plan/amount/date rows) | `BillingTable` |
| Billing table row | `BillingTable/Row` |
| Active plan section | `ActivePlan` |
| Active plan card | `ActivePlan/Card` |
| Active plan info | `ActivePlan/Info` |
| Active plan detail (next payment) | `ActivePlan/Detail` |
| Active plan action (cancel button) | `ActivePlan/Action` |
| Payment history section | `PaymentHistory` |
| Payment history header | `PaymentHistory/Header` |
| Payment history table | `PaymentHistory/Table` |
| Payment history list | `PaymentHistory/List` |
| Single payment record | `PaymentRecord/Default` |
| Payment record amount | `PaymentRecord/Amount` |
| Cancel subscription button | `CancelButton` |
| Purchase success header | `SuccessHeader` |
| Purchase success icon | `SuccessHeader/Icon` |
| Purchase success text | `SuccessHeader/Text` |
| Rewards section | `RewardsSection` |
| Rewards section header | `RewardsSection/Header` |
| Rewards section title | `RewardsSection/Title` |
| Reward card — one-time Aura | `RewardCard/OneTimeAura` |
| Reward card — daily Aura | `RewardCard/DailyAura` |
| Reward card value | `RewardCard/Value` |
| Reward card number | `RewardCard/Number` |

## Screens (Tab-level)

| Screen | Standard Name |
|--------|--------------|
| Home tab (Alpha Picks) — default/US market | `Home/Default` |
| Home tab — HK market view | `Home/HKMarket` |
| Home tab — ETF view | `Home/ETF` |
| Home tab — Crypto market view | `Home/CryptoMarket` |
| Alpha Picks tab | `AlphaPicks` |
| App Store / Skills tab | `AppStore` |
| Community / UGC tab | `Community` |
| Personal Agent / CIO tab | `CIOChat` |
| Quests tab | `Quests` |
| Portfolio page | `Portfolio` |
| Stock Detail page | `StockDetail` |
| Token Ranking page | `TokenRanking` |
| Onboarding | `Onboarding` |
| Settings | `Settings` |
| Profile | `Profile` |
| Notifications | `Notifications` |

## Common States

Always append state after `/`:
- `/Default`
- `/Loading`
- `/Empty`
- `/Error`
- `/Locked` (paywall)
- `/Expanded`
- `/Collapsed`
- `/Active`
- `/Inactive`

Example: `AlphaPicks/Loading`, `Card/Locked`, `Modal/Error`

## Common Components

| Component | Standard Name |
|-----------|--------------|
| Alpha Pick card | `AlphaCard` |
| Stock card (Home tab picks list) | `StockCard/Default` |
| Stock card outer wrapper | `StockCard/Body` |
| Stock card inner content area | `StockCard/Content` |
| Stock card info row (ticker + name) | `StockCard/InfoRow` |
| Stock card price row | `StockCard/PriceRow` |
| Stock card return/gain badge | `StockCard/ReturnBadge` |
| Stock card bottom row | `StockCard/BottomRow` |
| Stock card change info | `StockCard/ChangeInfo` |
| Stock ticker row | `StockRow` |
| CIO chat bubble (AI) | `ChatBubble/AI` |
| CIO chat bubble (user) | `ChatBubble/User` |
| Skill card in App Store | `SkillCard` |
| Quest card | `QuestCard` |
| Bottom navigation bar | `BottomNav` |
| Top navigation / header | `TopNav` |
| Search bar | `SearchBar` |
| Filter pill / chip | `FilterChip` |
| Paywall / unlock prompt | `Paywall` |
| Price tag | `PriceTag` |
| Return badge (% gain/loss) | `ReturnBadge` |
| Analyst rating | `AnalystRating` |
| Chart (general) | `Chart` |
| Sparkline (mini chart) | `Sparkline` |
| Avatar / profile picture | `Avatar` |
| Notification dot | `Badge/Dot` |
| Unread count badge | `Badge/Count` |
| Section header with title | `SectionHeader` |
| Divider line | `Divider` |
| Bottom sheet / drawer | `BottomSheet` |
| Modal / popup | `Modal` |
| Toast notification | `Toast` |
| Empty state illustration | `EmptyState` |
| Loading skeleton | `Skeleton` |

## Background Elements

| Element | Standard Name |
|---------|--------------|
| Gradient background | `BG/Gradient` |
| Blur backdrop | `BG/Blur` |
| Dark overlay | `BG/Overlay` |
| Solid background | `BG/Base` |
| Glow effect | `BG/Glow` |

## Layout Containers

| Container | Standard Name |
|-----------|--------------|
| Page root frame | Use screen name directly, e.g. `AlphaPicks/Default` |
| Scrollable list | `List` |
| List item | `List/Item` |
| Grid | `Grid` |
| Header area | `Header` |
| Content area | ❌ Never use bare `Content` — use `FeatureName/Layout` instead |
| Footer area | `Footer` |
| Left column | `Col/Left` |
| Right column | `Col/Right` |
