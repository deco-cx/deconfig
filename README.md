# This project is paused! ⚠️

We are starting the implementation of `deconfig` inside of `live` so we have more speed to evolve. When we feel it is stable enough to be used outside of our context, we will open-source the configuration-syncing part of the engine here. Hopefully this year :)

Cheers!

------

# Dynamic edge configuration management

`deconfig` is an **edge-native** deno configuration management framework for building deno applications that can be safely and dynamically configured at runtime, without a redeploy.

Developers may use `deconfig` to allow business users to change the behavior of distributed edge systems with autonomy, while retaining full auditability and rollback capability.

Start by defining a `configs/` folder inside your deno app with one or more `<config>.ts` files. Each file exports a `config domain`, a typed value which determines the format of saved configuration, as well as validation and pre-processing rules. A domain may contain unlimited `config instances`, each with different `keys` and `values`. They can be `active` or not, which determines their visibility in default queries.

While `config domains` are bound to the repository's lifecycle and require a deploy to change, `config instances` are saved in the database and can be altered in realtime, with changes reflecting instantly on your running edge application thanks to Deno Deploy's [`BroadcastChannel` API](https://deno.com/deploy/docs/runtime-broadcast-channel).

In essence, you would use `deconfig` to store, in-memory, all of the configuration data that your application needs, and to immediately propagate configuration changes to all running isolates, while storing a detailed audit of config changes.

To use deconfig you need two services:

- A running `deno` application that uses the configuration.
- A running SQL database for configuration persistence.

## Getting started

`deconfig` requires a SQL database to store configuration data with a schema like this:

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

**Pro Tip:** You can also use our managed platform at [deco.cx](https://deco.cx) to get started in seconds. Create an account and follow the instructions to create a new site. Every deco site already supports `deconfig` out of the box.

Add deconfig to your import map:

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
