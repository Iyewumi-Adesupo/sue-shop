import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,          // ✅ Keep your port
    strictPort: true,    // ✅ Keep strict mode
    proxy: {
      '/api': 'http://localhost:8000',  // ✅ Add this to forward backend API requests
    },
  },
})