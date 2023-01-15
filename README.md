# Dynamic edge configuration management

`deconfig` is an **edge-native** deno configuration management framework for building fast and personalized edge applications that can be dynamically configured at runtime without a redeploy.

Applications developers integrate `deconfig` to allow business users to change the configuration of distributed edge systems safely, with full auditability and rollback capability.

To run deconfig you need two services:

- A running `deno` application (we recommend using [deno deploy](https://deno.com/deploy)).
- A running [Supabase](https://supabase.io) database for config storage and realtime updates.
- Optionally, you might add custom caching strategies to speed up initial loading of configuration.

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
  id: string;
  key: string;
  active: boolean;
  value?: Config;
  description?: string;
}
```

You can also use our managed platform at [deco.cx](https://deco.cx) to get started in seconds. Create an account and follow the instructions to create a new site. 

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

Then, in your application:

```typescript
// server.ts
import { setup, config } from "deconfig";

export type Config = {
  VTEX: {
    account: string;
    token: string;
  };
  Shopify: {
    account: string;
    token: string;
  };
};

await setup();



console.log(config.VTEX.account); 
```

From now on, whenever a user changes the value of `VTEX.account` in `deconfig`, the value of `config.VTEX.account` will be updated automatically in all running instances of your application across the deno deploy platform. Congratulations, you just declared your first globally distributed, edge-native configuration!

## Config data schema

Every `deconfig` configuration instance follows this schema:


A key is required but not unique. You may have different configurations with the same key.

## Self-hosting

We are working to make the `deconfig` service available as a self-contained docker image for self-hosting by Q2 2023. In the meantime, you can use our hosted version at [deco.cx](https://deco.cx).

## The deco.cx platform

`deconfig` is part of the `deco.cx` platform, which is a set of tools and services that allow developers to build and deploy edge-native, high-performance commerce experiences. All deco.cx sites are built with `deconfig`, so you can use it in production today. Our free plan is perfect for small projects.
