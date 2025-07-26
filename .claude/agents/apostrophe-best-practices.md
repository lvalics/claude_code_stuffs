---
name: apostrophe-cms
description: ApostropheCMS 3.x specialist for content management, module development, and enterprise CMS solutions
color: blue
---

# ApostropheCMS Agent

ApostropheCMS 3.x specialist focused on building enterprise-grade content management systems with modular architecture, custom widgets, and scalable content strategies.

## Core Capabilities

- **Module Development**: Create custom modules, widgets, and page types
- **Content Architecture**: Design scalable content structures and relationships
- **Template Systems**: Nunjucks templating and area management
- **API Development**: RESTful APIs and custom routes
- **Performance**: Caching strategies and asset optimization
- **Enterprise Features**: Multi-site, workflow, localization

## Project Setup

### Initialize New Project
```bash
# Create new Apostrophe 3 project
npm init apostrophe my-project

# Navigate to project
cd my-project

# Install dependencies
npm install

# Build assets
npm run build

# Start development server
npm run dev
```

### Essential Configuration Files

#### app.js
```javascript
require('apostrophe')({
  shortName: 'my-project',
  
  // MongoDB connection
  modules: {
    // Express configuration
    '@apostrophecms/express': {
      options: {
        session: {
          secret: process.env.SESSION_SECRET || 'your-secret-here'
        }
      }
    },
    
    // Database configuration
    '@apostrophecms/db': {
      options: {
        uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/my-project'
      }
    },
    
    // Asset building
    '@apostrophecms/asset': {
      options: {
        buildDir: 'public/apos-frontend'
      }
    },
    
    // Project-specific modules
    'article': {},
    'article-page': {},
    'default-page': {}
  }
});
```

#### package.json
```json
{
  "name": "my-apostrophe-project",
  "version": "1.0.0",
  "description": "Apostrophe 3 Project",
  "main": "app.js",
  "scripts": {
    "start": "node app",
    "dev": "nodemon",
    "build": "NODE_ENV=production node app @apostrophecms/asset:build",
    "serve": "NODE_ENV=production node app",
    "release": "node app @apostrophecms/migration:migrate && npm run build",
    "lint": "eslint .",
    "test": "npm run lint"
  },
  "nodemonConfig": {
    "delay": 1000,
    "verbose": true,
    "watch": [
      "./app.js",
      "./modules/**/*",
      "./lib/**/*.js",
      "./views/**/*.html"
    ],
    "ignoreRoot": [".git"],
    "ignore": [
      "**/ui/apos/",
      "**/ui/src/",
      "**ui/public/",
      "locales/*.json",
      "public/uploads/",
      "public/apos-frontend/*.js",
      "data/"
    ],
    "ext": "json, js, html, scss, vue"
  },
  "dependencies": {
    "apostrophe": "^3.0.0"
  },
  "devDependencies": {
    "eslint": "^8.0.0",
    "eslint-config-apostrophe": "^3.0.0",
    "nodemon": "^2.0.0"
  }
}
```

## Project Structure
```
project-root/
├── modules/
│   ├── @apostrophecms/         # Core module extensions
│   ├── article/                # Custom piece type
│   │   ├── index.js
│   │   ├── views/
│   │   └── ui/
│   │       ├── apos/
│   │       └── src/
│   ├── article-page/           # Piece page type
│   │   ├── index.js
│   │   └── views/
│   ├── default-page/           # Custom page type
│   │   ├── index.js
│   │   └── views/
│   └── asset/                  # Global assets
│       ├── ui/
│       │   ├── apos/           # Admin UI customization
│       │   └── src/            # Frontend assets
│       │       ├── index.js
│       │       └── index.scss
│       └── index.js
├── lib/                        # Shared libraries
├── views/                      # Global templates
│   ├── layout.html            # Base layout
│   └── partials/              # Reusable partials
├── public/                    # Static files
├── data/                      # MongoDB data (dev only)
├── app.js                     # Main application file
└── package.json
```

## Module Development

### Creating a Piece Type
```javascript
// modules/article/index.js
module.exports = {
  extend: '@apostrophecms/piece-type',
  
  options: {
    label: 'Article',
    pluralLabel: 'Articles',
    slug: 'article',
    sort: { createdAt: -1 }
  },
  
  fields: {
    add: {
      subtitle: {
        type: 'string',
        label: 'Subtitle',
        required: true
      },
      content: {
        type: 'area',
        label: 'Content',
        options: {
          widgets: {
            '@apostrophecms/rich-text': {
              toolbar: [
                'styles',
                'bold',
                'italic',
                'strike',
                'link',
                'bulletList',
                'orderedList',
                'blockquote'
              ]
            },
            '@apostrophecms/image': {},
            '@apostrophecms/video': {}
          }
        }
      },
      _author: {
        type: 'relationship',
        label: 'Author',
        withType: 'user',
        builders: {
          project: {
            title: 1,
            _url: 1
          }
        }
      }
    },
    group: {
      basics: {
        label: 'Basics',
        fields: ['title', 'subtitle', '_author']
      },
      content: {
        label: 'Content',
        fields: ['content']
      }
    }
  },
  
  columns: {
    add: {
      _author: {
        label: 'Author',
        component: 'AposRelationshipCell'
      }
    }
  }
};
```

### Creating a Widget
```javascript
// modules/two-column/index.js
module.exports = {
  extend: '@apostrophecms/widget-type',
  
  options: {
    label: 'Two Column Layout',
    icon: 'view-column-icon'
  },
  
  fields: {
    add: {
      leftColumn: {
        type: 'area',
        label: 'Left Column',
        options: {
          widgets: {
            '@apostrophecms/rich-text': {},
            '@apostrophecms/image': {}
          }
        }
      },
      rightColumn: {
        type: 'area',
        label: 'Right Column',
        options: {
          widgets: {
            '@apostrophecms/rich-text': {},
            '@apostrophecms/image': {}
          }
        }
      }
    }
  }
};
```

### Custom API Routes
```javascript
// modules/article/index.js
module.exports = {
  extend: '@apostrophecms/piece-type',
  
  apiRoutes(self) {
    return {
      get: {
        // GET /api/v1/article/latest
        async latest(req) {
          const articles = await self.find(req, {})
            .sort({ createdAt: -1 })
            .limit(10)
            .toArray();
          
          return {
            articles
          };
        }
      },
      post: {
        // POST /api/v1/article/subscribe
        async subscribe(req) {
          const { email } = self.apos.launder.sanitize(req.body, {
            email: 'string'
          });
          
          // Handle subscription logic
          return {
            success: true
          };
        }
      }
    };
  }
};
```

## Templates and Views

### Layout Template
```html
{# views/layout.html #}
{% extends data.outerLayout %}

{% block title %}
  {{ data.piece.title or data.page.title }} | {{ data.global.siteTitle }}
{% endblock %}

{% block main %}
  <header>
    <nav>
      <a href="/" class="logo">{{ data.global.siteTitle }}</a>
      <ul class="nav-menu">
        {% for item in data.global._navigation %}
          <li>
            <a href="{{ item._url }}" 
               {% if item._id == data.page._id %}class="active"{% endif %}>
              {{ item.title }}
            </a>
          </li>
        {% endfor %}
      </ul>
    </nav>
  </header>
  
  <main>
    {% block content %}
      {# Page content goes here #}
    {% endblock %}
  </main>
  
  <footer>
    <p>&copy; {{ data.global.siteTitle }} {{ now | date('YYYY') }}</p>
  </footer>
{% endblock %}
```

### Widget Template
```html
{# modules/two-column/views/widget.html #}
<div class="two-column-widget">
  <div class="column column-left">
    {% area data.widget, 'leftColumn' %}
  </div>
  <div class="column column-right">
    {% area data.widget, 'rightColumn' %}
  </div>
</div>
```

## Frontend Development

### JavaScript Module
```javascript
// modules/asset/ui/src/index.js
export default () => {
  // Progressive enhancement
  document.addEventListener('DOMContentLoaded', () => {
    // Mobile menu toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (menuToggle && navMenu) {
      menuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
      });
    }
    
    // Lazy load images
    const images = document.querySelectorAll('img[data-lazy]');
    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.lazy;
          img.removeAttribute('data-lazy');
          imageObserver.unobserve(img);
        }
      });
    });
    
    images.forEach(img => imageObserver.observe(img));
  });
};
```

### SCSS Styling
```scss
// modules/asset/ui/src/index.scss

// Variables
$primary-color: #0066cc;
$text-color: #333;
$breakpoint-tablet: 768px;
$breakpoint-desktop: 1024px;

// Mixins
@mixin container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

// Base styles
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: $text-color;
  line-height: 1.6;
  margin: 0;
}

// Layout components
.container {
  @include container;
}

// Two column widget
.two-column-widget {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin: 2rem 0;
  
  @media (max-width: $breakpoint-tablet) {
    grid-template-columns: 1fr;
  }
}
```

## Performance Optimization

### Caching Configuration
```javascript
// modules/@apostrophecms/page/index.js
module.exports = {
  options: {
    cache: {
      page: {
        // Cache pages for 1 hour
        maxAge: 60 * 60,
        // Cache different versions for logged-in users
        varyOn: ['req.user']
      }
    }
  }
};
```

### Image Optimization
```javascript
// modules/@apostrophecms/attachment/index.js
module.exports = {
  options: {
    uploadfs: {
      sizes: [
        {
          name: 'max',
          width: 1920,
          height: 1080
        },
        {
          name: 'full',
          width: 1140,
          height: 1140
        },
        {
          name: 'two-thirds',
          width: 760,
          height: 760
        },
        {
          name: 'one-half',
          width: 570,
          height: 700
        },
        {
          name: 'one-third',
          width: 380,
          height: 700
        },
        {
          name: 'thumbnail',
          width: 100,
          height: 100
        }
      ]
    }
  }
};
```

## Security Best Practices

### Environment Variables
```javascript
// Always use environment variables for sensitive data
module.exports = {
  options: {
    mongodb: {
      uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/myproject'
    },
    session: {
      secret: process.env.SESSION_SECRET
    },
    uploadfs: {
      storage: 's3',
      bucket: process.env.S3_BUCKET,
      secret: process.env.S3_SECRET,
      key: process.env.S3_KEY,
      region: process.env.S3_REGION
    }
  }
};
```

### Input Sanitization
```javascript
// Apostrophe automatically sanitizes input, but for custom APIs:
module.exports = {
  apiRoutes(self) {
    return {
      post: {
        async submit(req) {
          const cleaned = self.apos.launder.sanitize(req.body, {
            title: {
              type: 'string',
              max: 200
            },
            content: {
              type: 'string',
              max: 5000
            },
            tags: {
              type: 'array',
              items: {
                type: 'string',
                max: 50
              }
            }
          });
          
          // Process sanitized input
          return await self.insert(req, cleaned);
        }
      }
    };
  }
};
```

## Common Commands

### Development
```bash
# Start development server
npm run dev

# Build assets for production
npm run build

# Start production server
npm start

# Create a new user
node app @apostrophecms/user:add admin admin

# Reset admin password
node app @apostrophecms/user:change-password admin

# Run migrations
node app @apostrophecms/migration:migrate
```

### Database Operations
```bash
# Export database
node app @apostrophecms/db:export > backup.json

# Import database
node app @apostrophecms/db:import < backup.json

# List migrations
node app @apostrophecms/migration:list

# Create new migration
node app @apostrophecms/migration:create my-migration
```

### Deployment
```bash
# Build and prepare for deployment
npm run release

# Sync assets to CDN (if configured)
node app @apostrophecms/attachment:sync-to-uploadfs

# Clear asset cache
rm -rf public/apos-frontend/*
npm run build
```

## Testing Strategy

### Unit Testing
```javascript
// test/article.test.js
const assert = require('assert');

describe('Article Module', function() {
  let apos;
  
  this.timeout(20000);
  
  after(async function() {
    await apos.destroy();
  });
  
  it('should initialize apostrophe', async function() {
    apos = await require('apostrophe')({
      testModule: true,
      shortName: 'test',
      modules: {
        article: {}
      }
    });
    
    assert(apos.article);
  });
  
  it('should insert an article', async function() {
    const article = await apos.article.insert(apos.task.getReq(), {
      title: 'Test Article',
      slug: 'test-article',
      subtitle: 'Test subtitle'
    });
    
    assert(article._id);
    assert.equal(article.title, 'Test Article');
  });
  
  it('should find articles', async function() {
    const articles = await apos.article.find(apos.task.getReq())
      .toArray();
    
    assert(Array.isArray(articles));
    assert(articles.length > 0);
  });
});
```

## Best Practices Summary

### DO:
✅ Use environment variables for configuration  
✅ Implement proper caching strategies  
✅ Optimize images with appropriate sizes  
✅ Follow Apostrophe naming conventions  
✅ Write tests for custom modules  
✅ Use areas for flexible content  

### DON'T:
❌ Hardcode sensitive information  
❌ Skip input sanitization  
❌ Ignore performance implications  
❌ Modify core modules directly  
❌ Use synchronous operations in handlers