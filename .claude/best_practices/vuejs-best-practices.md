# Vue.js Development Best Practices

This document outlines the best practices for developing frontend applications using Vue.js, specifically with the Jezweb recommended stack: **Vite, Vuetify, Tailwind CSS, and Pinia**.

## 1. Project Setup

### Prerequisites
- Node.js (v18 or higher)
- npm or yarn

### Create New Project with Vite
Always use Vite for scaffolding new Vue.js projects. It provides a significantly faster development experience than the older Vue CLI.

```bash
# Create a new Vue.js project with TypeScript support
npm create vite@latest my-vue-app -- --template vue-ts

# Navigate to the project directory
cd my-vue-app

# Install dependencies
npm install

# Start the development server
npm run dev```

## 2. Essential Configuration

### `package.json`
Define clear and consistent scripts for common tasks.

```json
{
  "name": "my-vue-app",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc --noEmit && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.js,.jsx,.cjs,.mjs,.ts,.tsx --fix --ignore-path .gitignore",
    "format": "prettier --write src/"
  },
  "dependencies": {
    "vue": "^3.3.4",
    "vue-router": "^4.2.4",
    "pinia": "^2.1.6",
    "vuetify": "^3.3.15",
    "tailwindcss": "^3.3.3",
    "axios": "^1.5.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^4.3.4",
    "vite": "^4.4.9",
    "typescript": "^5.2.2",
    "vue-tsc": "^1.8.11",
    "eslint": "^8.49.0",
    "eslint-plugin-vue": "^9.17.0",
    "prettier": "^3.0.3"
  }
}
```

### `vite.config.ts`
Configure Vite to work with your backend and set up useful aliases.

```typescript
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vuetify from 'vite-plugin-vuetify';
import path from 'path';

export default defineConfig({
  plugins: [
    vue(),
    vuetify({ autoImport: true }), // Enables automatic component importing for Vuetify
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 8080, // Frontend port
    proxy: {
      // Proxy API requests to the FastAPI backend
      '/api': {
        target: 'http://localhost:8000', // Your FastAPI backend URL
        changeOrigin: true,
      },
    },
  },
});
```

## 3. Project Structure

A well-organized project structure is key to maintainability.

```
src/
├── api/                  # API communication layer (e.g., using Axios)
│   └── index.ts
├── assets/               # Static assets (fonts, images)
├── components/           # Reusable UI components (Dumb components)
│   ├── common/           # General-purpose components (buttons, inputs)
│   └── layout/           # Layout components (Navbar, Sidebar, Footer)
├── router/               # Vue Router configuration
│   └── index.ts
├── stores/               # Pinia state management stores
│   ├── userStore.ts
│   └── authStore.ts
├── styles/               # Global styles and Tailwind CSS config
│   └── main.css
├── utils/                # Utility functions
├── views/                # Page components (Smart components)
│   ├── HomeView.vue
│   └── LoginView.vue
├── App.vue               # Root Vue component
└── main.ts               # Application entry point
```

## 4. Core Concepts & Best Practices

### Component Development (Vue.js)
- **Always use `<script setup>`:** It's the standard for Composition API, offering better performance, type inference, and less boilerplate.
- **Smart vs. Dumb Components:**
    - **Smart Components (Views):** Live in `/views`. They are route-level components responsible for fetching data and managing state.
    - **Dumb Components (UI):** Live in `/components`. They receive data via props and emit events. They should not have their own complex state.
- **Props:** Use TypeScript interfaces to define props for strong typing.
- **Events:** Use `defineEmits` for clear, type-safe event definitions.

```vue
<!-- Example: /components/common/BaseButton.vue -->
<script setup lang="ts">
interface Props {
  label: string;
  color?: string;
}

const props = withDefaults(defineProps<Props>(), {
  color: 'primary',
});

const emit = defineEmits<{
  (e: 'click'): void;
}>();

function handleClick() {
  emit('click');
}
</script>

<template>
  <v-btn :color="props.color" @click="handleClick" class="font-bold">
    {{ props.label }}
  </v-btn>
</template>
```

### UI Library (Vuetify)
- **Leverage Automatic Imports:** The `vite-plugin-vuetify` handles importing only the components you use, keeping the bundle size small.
- **Theming:** Define your application's theme (colors, fonts) in a dedicated file (e.g., `src/plugins/vuetify.ts`) and import it in `main.ts`.
- **Use Vuetify Layouts:** Use `v-layout`, `v-app-bar`, `v-main`, etc., to structure your application's main layout in `App.vue`.

### Styling (Tailwind CSS)
- **Utility-First:** Embrace the utility-first approach. Style directly in your templates. This increases development speed and reduces the need for custom CSS files.
- **Combine with Vuetify:** Use Tailwind classes to fine-tune the styling of Vuetify components.
- **Use `@apply` Sparingly:** For complex, repeated sets of utilities, you can use the `@apply` directive in your `styles/main.css` file to create custom reusable classes.

```html
<!-- Example of combining Vuetify and Tailwind -->
<v-card class="p-4 rounded-lg shadow-lg hover:shadow-xl transition-shadow">
  <h3 class="text-xl font-bold text-gray-800">Card Title</h3>
  <p class="mt-2 text-gray-600">This card uses both Vuetify and Tailwind.</p>
</v-card>
```

### Routing (Vue Router)
- **Lazy Loading:** Always lazy-load your route components. This creates separate chunks for each route, significantly improving initial load time.

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    name: 'Home',
    // Lazy-loaded component
    component: () => import('@/views/HomeView.vue'),
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/LoginView.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
```

### State Management (Pinia)
- **Centralize Global State:** Use Pinia to manage state that is shared across multiple components (e.g., authenticated user info, theme settings).
- **Structure Your Stores:** Create one file per logical store in the `/stores` directory.
- **Access Stores:** Use the `useMyStore()` function within your components' `<script setup>` block.

```typescript
// src/stores/userStore.ts
import { defineStore } from 'pinia';

interface User {
  id: string;
  name: string;
  email: string;
}

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null as User | null,
    isLoading: false,
  }),
  getters: {
    isLoggedIn: (state) => !!state.user,
  },
  actions: {
    async fetchUser(id: string) {
      this.isLoading = true;
      try {
        // const response = await api.getUser(id); // API call
        // this.user = response.data;
      } catch (error) {
        console.error('Failed to fetch user', error);
      } finally {
        this.isLoading = false;
      }
    },
  },
});
```

### API Communication
- **Create a Service Layer:** Do not make API calls directly from components. Abstract them into a dedicated service layer in the `/api` directory. This makes your code more modular and easier to test.
- **Use an API Client:** Use a library like `axios` to create a pre-configured client that handles base URLs, headers, and interceptors.

```typescript
// src/api/index.ts
import axios from 'axios';
import { useAuthStore } from '@/stores/authStore'; // Assuming an auth store for the token

const apiClient = axios.create({
  baseURL: '/api', // Uses the proxy we set up in vite.config.ts
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add a request interceptor to include the auth token
apiClient.interceptors.request.use(config => {
  const authStore = useAuthStore();
  const token = authStore.token; // Get token from Pinia store
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default apiClient;
```

## 5. Authentication with Clerk

- **Use Clerk's Vue Components:** Leverage Clerk's pre-built components like `<SignIn />`, `<SignUp />`, and `<UserProfile />` for a fast and secure implementation.
- **Manage Session State:** Use Clerk's composables (`useUser`, `useAuth`) to get user information and authentication state.
- **Protect Routes:** Use a navigation guard in `router/index.ts` to protect routes that require authentication.
- **Authenticated API Calls:** Use an interceptor (as shown in the API section) to attach the JWT provided by Clerk to every outgoing API request.

## 6. Testing

- **Use Vitest:** It's the modern, Vite-native unit testing framework. It's fast and has a Jest-compatible API.
- **Test Component Behavior:** Write tests that simulate user interactions (clicks, input) and assert the expected outcome, rather than testing implementation details.
- **Mock Dependencies:** Mock API calls and Pinia stores to isolate the component you are testing.

## 7. Deployment

- **Build for Production:** Run `npm run build`. This will create a highly optimized set of static files in the `/dist` directory.
- **Hosting:** Deploy the contents of the `/dist` folder to a static hosting provider like **Cloudflare Pages** or **Vercel**.