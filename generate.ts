export default async function generate() {
  // TODO generate deconfig.gen.ts
}

// Run directly if called as a script
if (import.meta.main) {
  const results = await generate();
  console.log(results);
}
