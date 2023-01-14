import { get } from "deconfig";

export type Config = {
  foo: string;
  bar: number;
};

const config = get<Config>(import.meta.url);

console.log(config);
