# Dynamic edge configuration management

`deconfig` is an **edge-native**, **fully-typed** deno configuration management framework for building fast and personalized edge applications that can be safely and dynamically configured at runtime without a redeploy.

Applications developers integrate `deconfig` to allow business users to change the configuration of distributed edge systems safely, with full auditability and rollback capability.

To run deconfig you need two services:

- A running `deno` application (we recommend using [deno deploy](https://deno.com/deploy)).
- A running [Supabase](https://supabase.io) database for config storage and realtime updates.

Optionally, you might add custom caching strategies to speed up initial loading of configuration.

## Use cases

There are multiple use cases for `deconfig`, for example:

- **Acess token and secret management**

  - `deconfig` allows developers to distribute access tokens and secrets to running deno applications without exposing them in source code, while allowing for different tokens to be used in different environments.

- **Personalization and A/B testing**

  - `deconfig` allows developers to use configuration to personalize the experience for each user, and measure the impact of each version on user behaviour by tracking the active configurations for each request.

- **Configuration as code**

  - `deconfig` allows developers to express strongly-typed schemas for their application configuration using TypeScript and leverage a rich set of tools (including full auto-generated web editor on deco.cx) to manage and deploy configuration changes.

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

Either way, define the following environment variables:

```bash
SUPABASE_ACCOUNT=your-supabase-account
SUPABASE_KEY=your-supabase-anon-key
```

We maintain a demo public database for testing purposes and open source projects. Please do not use it for production applications. Credentials are in the `.env` file. Obviously, **all configuration saved to this public database is public and can be read by anyone. Do not store sensitive data.** For production applications, we recommend using your own Supabase database, or create a free site at [deco.cx](https://deco.cx).

Then, add deconfig to your import map:

```json
// import_map.json
{
  "imports": {
    "deconfig": "https://deno.land/x/deconfig/0.1.0/mod.ts"
  }
}
```

Then, write a file that exports a type named `Config`:

```typescript
// server.ts
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
```

Now, run the `generate.ts` script to discover all files with configuration types:

```bash
deno run -A https://deno.land/x/deconfig/generate.ts
```

This will generate the `deconfig.gen.ts` file, which contains the `deconfig` runtime. Whenever you configuration format changes, you should re-run this script to update the runtime.

You can now import it in your application and use it to setup the connection and get the configuration:

```typescript
// server.ts
import { setup, get } from "./deconfig.gen.ts";

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

// Initial setup gets latest config from database. 
// With a dedicated supabase in a region near your users, this should be <100ms.
// This is the only latency overhead — all subsequent reads are in-memory.
const config = await setup();

// Or, later, for example inside a request cycle.
const config = get();

// Fully typed according to Config!
console.log(config); // {server: {VTEX: {account: "myaccount", token: "mytoken"}}

// Config is always read in-memory - the key is the path of the file where it was defined.
// In this case, if the file is called `server.ts`, the key is `server`.
const {account, token} = config.server.VTEX; 
```

From now on, whenever a user changes the value of `VTEX.account` in your `deconfig` database, the value of `config.VTEX.account` will be updated automatically in all running instances of your application across the deno deploy platform. Congratulations, you just declared your first globally distributed, edge-native configuration!

## How to ensure saved configs are correctly typed?

For now, `deconfig` does not handle validation of the `value` json field. We recommend adding a layer of validation before saving the configuration, but that is currently outside the scope of this project, since it would mean choosing one validation library over another, which is not a decision we want to make for you. At [deco.cx](https://deco.cx), we use `deno doc` for type extraction and then convert that into JSON schemas for validation. We may open source this in the future.

## The deco.cx platform

`deconfig` is part of the [deco.cx](https://deco.cx) platform, which is a set of tools and services that allow developers to build and deploy edge-native, high-performance commerce experiences. All [deco.cx](https://deco.cx) sites are built with `deconfig`, so you can use it in production today. Our free plan is perfect for small projects.
