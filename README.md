# Dynamic edge configuration management

`deconfig` is an **edge-native** deno configuration management framework for building fast and personalized edge applications that can be dynamically configured at runtime without a redeploy.

Applications developers integrate `deconfig` to allow business users to change the configuration of distributed edge systems safely, with full auditability and rollback capability.

## Use cases

There are multiple use cases for `deconfig`, for example:

- **Acess token and secret management**

  - `deconfig` allows developers to distribute access tokens and secrets to running deno applications without exposing them in source code, while allowing for different tokens to be used in different environments.

- **Personalization and A/B testing**

  - `deconfig` allows developers to use configuration to personalize the experience for each user, and measure the impact of each version on user behaviour by tracking the active configurations for each request.

- **Configuration as code**

  - `deconfig` allows developers to express strongly-typed schemas for their application configuration using TypeScript and leverage a rich set of tools (including full auto-generated web editor) to manage and deploy configuration changes.

## Getting started

To start using `deconfig`, you directly import the `config` from `https://config.deco.cx/{site}`. If you don't have a site, create a free one at [deco.cx](https://deco.cx).

```typescript
// commerce.ts
import { get, set } from "https://config.deco.cx/{YOUR_SITE}";

// Exporting your configuration schema automatically generates a web editor at config.deco.cx/{site}
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

const config = await get<Config>(import.meta.url);

// Returns the string configured at config.deco.cx/{site}/commerce.ts
console.log(config.VTEX.account); 

config.VTEX.account = "my-new-account";

await set<Config>(import.meta.url, config)

// Whenever the configuration is updated, the value of config.VTEX.account will be pushed to all running isolates on deno deploy
console.log(config.VTEX.account); // "my-new-account" in other isolates
```

From now on, whenever a user changes the value of `VTEX.account` in `deconfig`, the value of `config.VTEX.account` will be updated automatically in all running instances of your application across the deno deploy platform. Congratulations, you just declared your first globally distributed, edge-native configuration!

## Config data schema

Every `deconfig` configuration instance follows this schema:

```typescript
export interface ConfigInstance<Config> {
  id: string;
  key: string;
  active: boolean;
  value?: Config;
  description?: string;
  priority?: number;
}
```

A key is required but not unique. You may have different configurations with the same key.

## Self-hosting

We are working to make the `deconfig` service available as a self-contained docker image for self-hosting by Q2 2023. In the meantime, you can use our hosted version at [deco.cx](https://deco.cx).

## The deco.cx platform

`deconfig` is part of the `deco.cx` platform, which is a set of tools and services that allow developers to build and deploy edge-native, high-performance commerce experiences. All deco.cx sites are built with `deconfig`, so you can use it in production today. Our free plan is perfect for small projects.
