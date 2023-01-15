export function get<T>(_: string): T {
  return {
    foo: "foo",
    bar: 42,
  } as T;
}

export function set<T>(_: string, value: T): void {
  console.log("set", value);
}
