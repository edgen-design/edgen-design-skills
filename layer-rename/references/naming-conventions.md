# Figma Layer Naming Conventions

## Format
- English, PascalCase, use `/` for hierarchy (max 3 levels)
- No spaces, no auto-generated IDs (Frame 123, Group 456, Ellipse 15)

## Patterns

| Type | Pattern | Examples |
|------|---------|---------|
| Screen / Frame | Feature/State | `AlphaPicks/Default`, `Portfolio/Loading`, `Modal/Error` |
| Screen layout wrapper | Feature/Layout | `ManageBilling/Layout`, `CancelSubscription/Layout` |
| Container (generic) | Role | `Header`, `Footer`, `Nav`, `Sidebar`, `SubscriptionList` |
| Card | ComponentName/Variant | `SubscriptionCard/Stripe`, `SubscriptionCard/ApplePay`, `PlanCard/Monthly` |
| Background | BG/Type | `BG/Gradient`, `BG/Blur`, `BG/Overlay`, `BG/Glow` |
| Button | Button/Variant | `Button/Primary`, `Button/Ghost`, `Button/Disabled` |
| Icon | Icon/Name | `Icon/Arrow`, `Icon/Logo`, `Icon/ChevronRight` |
| Text / Label | Label/Role | `Label/Title`, `Label/Desc`, `Label/Tag`, `Label/Price` |
| Image | Img/Role | `Img/Avatar`, `Img/Cover`, `Img/Thumbnail` |
| Chart element | Chart/Type | `Chart/Bar`, `Chart/Line`, `Chart/AxisX`, `Chart/Legend` |
| Divider / Line | Divider | `Divider` (never add numbers — same name = one reusable component) |
| Input | Input/State | `Input/Default`, `Input/Focused`, `Input/Error` |
| Tag / Badge | Tag/Type | `Tag/Bullish`, `Tag/New`, `Badge/Count` |

## FigmaToCode Rules (Critical)

These rules ensure one-click code generation produces clean, reusable components:

### Rule 1: Never use numbered suffixes for list items
❌ `SubscriptionList/Row`, `SubscriptionList/Row-2`, `SubscriptionList/Row-3`
✅ `SubscriptionCard/Stripe`, `SubscriptionCard/ApplePay`, `SubscriptionCard/GooglePlay`

Reason: FigmaToCode uses the name as the component name. Numbered names produce meaningless `Row2`, `Row3` components. Variant names produce a single `SubscriptionCard` component with props.

### Rule 2: Same name only if structure AND context are identical
If `Card/Info` appears 5 times inside the same feature (e.g. 5 SubscriptionCards), keep them all `Card/Info` — same component.

But if `Card/Info` appears in two different features with different structures:
❌ `Card/Info` in ManageBilling + `Card/Info` in AlphaPicks (different structure = conflict)
✅ `SubscriptionCard/Info` in ManageBilling
✅ `AlphaCard/Info` in AlphaPicks

Rule: Always prefix card sub-elements with their parent feature name when they appear across multiple features.

### Rule 3: Avoid generic "Content" as a top-level wrapper
❌ `Content` (used in 7 different screens → 7 different `Content` components in code)
✅ `ManageBilling/Layout`, `CancelSubscription/Layout`, `PurchaseSuccess/Layout`

Reason: The layout wrapper name becomes the root component name in generated code.

### Rule 4: Dividers never need numbers
❌ `Divider`, `Divider-2`, `Divider-3`
✅ `Divider`, `Divider`, `Divider`

Reason: All dividers are the same component. FigmaToCode generates one `Divider` component.

### Rule 5: Infer variant name from text content, not position
Look at the text content inside a repeating list item to infer its variant:
- Text says "Stripe" → `SubscriptionCard/Stripe`
- Text says "Apple Pay" → `SubscriptionCard/ApplePay`
- Text says "Google Play" → `SubscriptionCard/GooglePlay`
- Text says "Monthly" / "3m" → `PlanCard/Monthly`
- Text says "Quarterly" → `PlanCard/Quarterly`
- Text says "Annual" → `PlanCard/Annual`

## General Rules
- Infer meaning from: position in hierarchy, sibling names, text content inside node
- If a layer is already semantic (clear meaning, no ID), skip it
- Bottom-level decorative shapes with a named parent → skip
- Max rename depth: go as deep as needed but keep names meaningful
