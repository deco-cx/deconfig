import "std/dotenv/load.ts";
import { config, metrics, setup } from "./deconfig.gen.ts";

export type Config = {
  foo: string;
  bar: number;
};

await setup();

console.log(config); // { server: { foo: "bar", bar: 123 } }
console.log(metrics());
