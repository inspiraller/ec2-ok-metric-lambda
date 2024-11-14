import { defineConfig } from "vitest/config";

// import { fileURLToPath } from "url";
import path from "path";

export const options = {
  plugins: [],
  test: {
    globals: true,
    environment: "node",
    exclude: [
      '**/node_modules/**',
      '**/dist/**',
      '**/.{idea,git,cache,output,temp}/**',
    ],
    coverage: {
      include: ['src'],
      exclude: ['**/*.cy.*']
    }
  },
  resolve: {
    
    alias: {
      '@': path.resolve(__dirname, 'src'),
      // "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
}
export default defineConfig(options);
