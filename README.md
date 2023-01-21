# Dynamic edge configuration management

`deconfig` is an **edge-native** deno configuration management framework for building edge applications that can be safely and dynamically configured at runtime, without a redeploy.

Developers integrate `deconfig` to allow business users to change the configuration of distributed edge systems independently, with full auditability and rollback capability.

To run deconfig you need two services:

- A running `deno` application (we recommend using [deno deploy](https://deno.com/deploy)).
- A running [Supabase](https://supabase.io) database for config storage.

## Use cases

There are multiple use cases for `deconfig`, for example:

- **Acess token and secret management**

  - `deconfig` allows developers to distribute access tokens and secrets to running deno applications without exposing them in source code, while allowing for different tokens to be used in different environments.

- **Personalization and A/B testing**

  - `deconfig` allows developers to use configuration to personalize the experience for each user, and measure the impact of each version on user behaviour by tracking the active configurations for each request.

- **Configuration as code**

  - `deconfig` allows developers to express strongly-typed schemas for their application configuration using TypeScript.

## Getting started

`deconfig` requires a running [Supabase](https://supabase.io) database to store configuration data with a schema like this:

```typescript
export interface ConfigInstance<Config> {
  id: number;
  created_at: Date;
  active: boolean;
  key: string;
  value?: Config;
  description?: string;
}
```

There is a `table.sql` script in the root of this repository that you can use to create the table in your database.

You can also use our managed platform at [deco.cx](https://deco.cx) to get started in seconds. Create an account and follow the instructions to create a new site. Every deco site already support `deconfig` out of the box.

Define the following environment variables:

```bash
SUPABASE_ACCOUNT=your-supabase-account
SUPABASE_KEY=your-supabase-anon-key
```

We maintain a demo public database for testing purposes and open source projects. Please do not use it for production applications. Credentials are in the `.env` file. Obviously, **all configuration saved to this public database is public and can be read by anyone. Do not store sensitive data.** For production applications, we recommend using your own Supabase database, or creating a free site at [deco.cx](https://deco.cx).

Then, add deconfig to your import map:

```json
// import_map.json
{
  "imports": {
    "deconfig": "https://deno.land/x/deconfig/0.1.0/mod.ts"
  }
}
```

You can now import it in your application and use it to get and set configuration:

```typescript
// server.ts
import { get, getAll, has, set } from "deconfig";

export type Config = {
  VTEX?: {
    account: string;
    token: string;
  };
  Shopify?: {
    account: string;
    token: string;
  };
};

// This is the key that will be used to store the config in the database.
const key = import.meta.url;

// You should `get()` your config at the start of each request cycle.
// Only the first-ever request pays a latency price. 
// All other requests are served from memory with a stale-while-revalidate caching strategy.
let config = await get<Config>(key);

// Typed according to Config
console.log(config); // {VTEX: {account: "myaccount", token: "mytoken"}}

// When settting a new value, every other deno instance will be updated immediately.
config.VTEX.token = "mytoken2"
set(key, config)
```

From now on, whenever you `set` the value of any property in `config`, it will be immediately  
(1) saved to the database and  
(2) updated in all running isolates in your deploy.

Congratulations, you just declared your first globally distributed, edge-native configuration!

## The deco.cx platform

`deconfig` is part of the [deco.cx](https://deco.cx) platform, which is a set of tools and services that allow developers to build and deploy edge-native, high-performance commerce experiences. All [deco.cx](https://deco.cx) sites are built with `deconfig`, so you can use it in production today. Our free plan is perfect for small projects.
