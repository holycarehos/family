# Family — Hedera‑powered Web3 Healthcare Platform

Family is a decentralized healthcare and fertility platform that connects patients, clinics, and donors through secure on‑chain workflows. It uses Hedera Testnet (EVM) for trust, auditability, and programmable payments, with decentralized identity and optional AI assistance for care coordination.

## Features
- Patient booking and confirmations with on‑chain awareness
- Hospital/clinic dashboard for managing requests and workflows
- Sperm donation and fertility treatment forms with clear eligibility and compensation
- NFT data marketplace primitives (list, buy, sell modals)
- Wallet connection via RainbowKit/Wagmi; payments and prices in HBAR (and USDC where noted)
- Hedera Testnet (EVM) integration (Chain ID 296)
- Decentralized identity flows (Veramo/CHEQD, Verida session)
- IPFS via Pinata (uploads and gateway support)
- Optional AI assistant endpoints (Groq) for fertility guidance

## Tech stack
- Next.js 15 (App Router) + React 19 + TypeScript
- Tailwind CSS, Radix UI
- Wagmi + viem + RainbowKit
- Hedera Testnet (EVM) RPC via HashIO
- Veramo, Verida session, Pinata (IPFS)
- Foundry (Solidity) for smart contracts

## Project structure at higher level
- src/app — Next.js App Router pages (booking, dashboard, forms, hospital)
- src/components — UI components (NFT modals, forms, etc.)
- src/app/contexts — RainbowKit/Wagmi setup
- src/contract — Web3 provider and addresses
- src/lib — Integrations (Pinata, Verida, handlers)
- public/images — static assets

## Prerequisites
- Node.js 18+ (or 20+ recommended)
- PNPM 8+ (recommended) or npm/yarn
- A browser wallet (e.g., MetaMask) configured for Hedera Testnet

Hedera Testnet network settings:
- RPC: https://testnet.hashio.io/api
- Chain ID: 296
- Symbol: HBAR
- Explorer: https://hashscan.io/testnet


## Family System Architecture

```
+------------------------------------------------------------------------------------+
|                                   Browser (Next.js)                                |
| - src/app pages & UI components (Header, forms, modals, FertilityAI)               |
+------------------------------+------------------------------+----------------------+
                               |                              |
                               v                              v
+------------------------------+------------------------------+      +---------------+
| RainbowKit + Wagmi + viem (wallet connect, writeContract)  |      | Next.js API  |
| src/app/contexts/rainbowkit.tsx                            |      | Routes       |
+------------------------------+------------------------------+      | /api/*       |
                               |                                     +-------+------+
                               |                                             |
                               v                                             v
+-------------------------------------------------------------+     +-----------------------------+
| Hedera EVM (HashIO RPC) — Smart Contracts (Foundry)         |     | External Services           |
| Family-smartContract/smartContract:                         |     | - Groq LLM (LangChain)      |
| - HealthDataNFT, ProfileImageNFT, HRS, MarketPlace,         |     | - Pinata IPFS (uploads)     |
|   Process/Factory, HospitalRequest/Factory, Reward, etc.    |     | - Verida API (optional)     |
+-------------------------------------------------------------+     | - CHEQD/Veramo (optional)   |
                                                                      +-----------------------------+

Notes:
- Contract ABIs under src/contract/abi; web3 client in src/contract/web3.ts (env-driven addresses)
- Transaction modal uses wagmi/viem; receipts may be fetched via /api/transaction/[hash]
```

## Data Flow Diagram

```
+=========================================+
| A) On-chain transaction (Hedera EVM)    |
+=========================================+
+--------------------+     +-------------------------------+     +------------------------------+
| Client (Browser)   | --> | RainbowKit/Wagmi (sign+send)  | --> | Hedera EVM (HashIO RPC)      |
| TransactionModal   |     | wagmi useWriteContract        |     | Smart Contracts (Foundry)     |
+---------+----------+     +---------------+---------------+     +---------------+--------------+
          |                                  |                                     ^
          |<---------------------------------+                                     |
          |    tx hash / useWaitForTransactionReceipt (poll)                       |
          |                                                                         |
+--------------------+     +--------------------------------------+     +------------------------------+
| Client (optional)  | --> | Server: viem.getTransactionReceipt   | --> | Hedera EVM (receipt/logs)    |
| Confirm receipt    |     |                                      |     | -> back to Client UI         |
+--------------------+     +--------------------------------------+     +------------------------------+

+==========================+
| B) File upload to IPFS   |
+==========================+
+--------------------+     +----------------------+     +--------------------+     +------------------+
| Client (Browser)   | --> | POST /api/file       | --> | Pinata IPFS        | --> | Gateway URL      |
| formData(file)     |     | Pinata SDK           |     | -> CID             |     | -> Client uses   |
+--------------------+     +----------------------+     +--------------------+     +------------------+

+==========================+
| C) AI chat               |
+==========================+
+--------------------+     +------------------------------+     +-----------------------+
| Client (Browser)   | --> | POST /api/fertility-ai/chat  | --> | LangChain + Groq LLM  |
| FertilityAI widget |     |                              |     | -> response to Client |
+--------------------+     +------------------------------+     +-----------------------+

+================================+
| D) Identity (optional flows)   |
+================================+
+--------------------+  <----->  +----------------------+      and/or      +-------------------+
| Client (Browser)   |           | Verida API           |                  | CHEQD / Veramo    |
| DID/VC, calendar   |           | calendar/events/LLM  |                  | DID / VC verify   |
+--------------------+           +----------------------+                  +-------------------+

+==========================+
| E) Recommendations       |
+==========================+
+--------------------+     +--------------------------------------+     +-------------------+
| Client (Browser)   | --> | POST /api/fertility-ai/recommendations | --> | Filtered response |
+--------------------+     +--------------------------------------+     +-------------------+
```

## Environment variables
Create a .env.local file in the project root. Minimal variables to run the UI locally (placeholders are ok for non‑contract flows):

- NEXT_PUBLIC_RPC_URL=https://testnet.hashio.io/api
- NEXT_PUBLIC_APP_URL=http://localhost:3000
- RAINBOW_KIT_PROJECT_ID=your_walletconnect_project_id

Optional/integrations (use real values if you enable these flows):
- PINATA_JWT=...
- NEXT_PUBLIC_GATEWAY_URL=...
- GROQ_API_KEY=...
- VERIDA_API_ENDPOINT=...
- VERIDA_APP_DID=...
- SESSION_SECRET=complex_password_at_least_32_characters_long

Contract addresses (set if you’re exercising on‑chain features; placeholders are fine for basic UI):
- NEXT_PUBLIC_FIXED_ORACLE_PRICE_ADDRESS=
- NEXT_PUBLIC_AIAGENT_FACTORY_ADDRESS=
- NEXT_PUBLIC_ENTRY_POINT_ADDRESS=
- NEXT_PUBLIC_HEALTH_DATA_NFT_ADDRESS=
- NEXT_PUBLIC_HOSPITAL_REQUEST_CONTRACT_ADDRESS=
- NEXT_PUBLIC_HOSPITAL_REQUEST_FACTORY_ADDRESS=
- NEXT_PUBLIC_HRS_ADDRESS=
- NEXT_PUBLIC_MARKETPLACE_ADDRESS=
- NEXT_PUBLIC_PROFILE_IMAGE_NFT_ADDRESS=
- NEXT_PUBLIC_PROCESS_ADDRESS=
- NEXT_PUBLIC_PROCESS_FACTORY_ADDRESS=
- NEXT_PUBLIC_VERIFICATION_ADDRESS=
- NEXT_PUBLIC_REWARD_ADDRESS=

## Quick start (local)
1) Install dependencies

```bash
pnpm install
```

2) Start the development server

```bash
pnpm dev
```

Open http://localhost:3000

3) Build and run in production mode

```bash
pnpm build
pnpm start
```

## Wallet & network
- The app uses RainbowKit/Wagmi. When you connect a wallet, choose Hedera Testnet.
- If your wallet doesn’t have Hedera Testnet configured, add it using the settings above (Chain ID 296).

## Smart contracts (optional)
Contracts live under:
- Family-smartContract/smartContract

Use Foundry:
- RPC (foundry.toml): hedera_testnet = "https://testnet.hashio.io/api"
- Deploy workflow: create a broadcast or script using your testnet private key and RPC (see Hedera docs for EVM deploys on testnet).

## Troubleshooting
- Wallet not connecting or wrong network: ensure Hedera Testnet (chain 296) is selected.
- Env errors at startup: verify .env.local values. You can leave contract addresses empty for UI‑only flows.
- Build errors: clear cache and rebuild: `rm -rf .next && pnpm build`.

## License
This project is provided as‑is for demonstration and development purposes under MIT License.
