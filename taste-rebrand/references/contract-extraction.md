# Phase 1: Extracting CONTRACT.md

Rebrand mode only. `CONTRACT.md` is the single most important document this pipeline produces in that mode, because everything in Phase 4 is built against it. Treat gaps in it as your own liability, not the client's: if a route is not documented and Phase 4 breaks it, that is a process failure here, not an unpredictable accident.

## Detection steps, stack-agnostic

Do not assume the stack. Work through these in order and stop assuming as soon as there is evidence.

1. **Frontend framework.** `package.json` dependencies (`next`, `react`, `vue`, `svelte`, `@angular/core`), or none of them (`index.html` plus vanilla JS and CSS). Confirm with the bundler config: `vite.config`, `next.config`, `angular.json`.
2. **Styling system.** Tailwind config? CSS-in-JS (`styled-components`, `emotion`)? CSS Modules? Plain global CSS? This decides how `brand/tokens.css` gets wired in.
3. **Backend framework and where it lives.** Same repo (`/api`, `/server`, Next.js API routes, a `backend/` folder) or a separate service behind an API base URL in env vars? Common signatures: `express`, `fastify`, Next API routes, `django`, `flask`, `fastapi`, `rails`, or Supabase and Firebase as a backend-as-a-service with no custom server at all.
4. **Database and ORM.** `prisma/schema.prisma`, a `drizzle` config, SQLAlchemy models, Mongoose schemas, or a hosted service reached through SDK calls scattered across the code.
5. **Auth mechanism.** `next-auth` or `auth.js` config, Clerk, Supabase Auth or Firebase Auth SDK usage, a custom JWT (`jsonwebtoken`, cookie sessions), or OAuth provider config. Trace the full flow: where login happens, what is stored (cookie, localStorage, session), how protected routes check it.
6. **Deployment target and env vars.** `.env.example` or `.env.sample` only; never read a real `.env`. Then `vercel.json`, `netlify.toml`, a Dockerfile. List every env var name and its purpose, never its value.
7. **Third-party integrations.** Payment (Stripe, Paddle, LemonSqueezy), email (Resend, SendGrid, Postmark), analytics, file storage (S3, Cloudinary, UploadThing), LLM providers. Each has request and response contracts the frontend depends on.

## What CONTRACT.md must contain

Sections, each a table where possible.

**API routes.** Method, path, auth required (yes or no, and the mechanism), request shape, response shape, consuming components in the current frontend. Taken from the actual handler code, not from route names; read the handler body to confirm the real shapes, including error responses.

**Auth flow.** Step by step: where login and signup happen, what request is sent, what comes back, where the token or session is stored client-side, how later requests attach it, how logout works, how expiry and refresh are handled.

**Data models.** Every model relevant to what the frontend renders: fields, types, relationships. From the schema file or migrations, not inferred from frontend usage, which is usually incomplete.

**Third-party integrations.** Which service, what for, which frontend flows depend on it. For example: "Stripe Checkout, triggered from `components/PricingCard.tsx`, redirects to `/success` on completion."

**Env vars.** Name and purpose only. Never values.

## The hard rule this file enforces

Once `CONTRACT.md` is written, Phase 4 treats every line in it as something that keeps working identically after the rebuild. If the new design genuinely needs a change here, say an API response needs one more field to support a new element, that is a **flagged breaking change** for the Phase 5 review, never a silent edit. Update `CONTRACT.md` itself only when a breaking change has been explicitly approved, so it always reflects the real current contract, old or new.
