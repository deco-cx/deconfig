# Boost your storefront, boost your sales

Boost is an **edge-first** deno meta-framework for super fast and personalized storefronts.

- Choose from dozens of optimized **loader functions** to fetch data from popular APIs — VTEX, Shopify, Magento, Oracle, Nuvemshop and thousands of others, or build your own to fetch data from any API you want.
- Setup your **theme** to quickly match your own brand — spacing, colors, fonts and sizes — and add as much or as little custom CSS as you need.
- Select from hundreds of existing **UI sections** for your storefront that automatically adapt to your theme — product details, shelf, banner, carousel — to display that data, or create your own with [Preact](https://preactjs.com) (JSX/HTML) and [Twind](https://twind.dev) (CSS).
- Create **flags** to adapt your rendering configuration for each request. Code your own `matcher` functions to decide if any given request should activate a flag, then react to flag value in sections and loaders.

**Loaders** return, and **Sections** accept, well-typed `props` that adhere to [schema.org](https://schema.org) standards, so they are easily interchangeable and can be used in any other project. For example, a `Product Shelf` section can display products from `VTEX Search API` or `Shopify Products API`, by simply changing the loader function.

All function types, **Loaders**, **Sections** and **Matchers**, are configurable by end-users through the [deco.cx](https://deco.cx) admin panel. Developers `export interface Props {}` and that is automatically converted to a web form for end-users to configure.

All pages are **server-side rendered** on demand, so your storefront will only execute the code it needs to render the current request and return the minimal HTML and JS necessary for maximum performance.

All loaders have automatic stale caching, queing and retrying, so your storefront will always be fast and reliable.

## More coming soon
