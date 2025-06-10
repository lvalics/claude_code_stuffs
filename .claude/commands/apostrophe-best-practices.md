# ApostropheCMS Development Best Practices

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
    "ignoreRoot": [
      ".git"
    ],
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

#### .env
```bash
# MongoDB
MONGODB_URI=mongodb://localhost:27017/my-project

# Server
PORT=3000
NODE_ENV=development

# Session
SESSION_SECRET=your-random-secret-here

# Admin
APOS_ADMIN_PASSWORD=admin-password

# S3 (optional)
APOS_S3_BUCKET=
APOS_S3_SECRET=
APOS_S3_KEY=
APOS_S3_REGION=

# Email
APOS_EMAIL_FROM=noreply@example.com
APOS_EMAIL_TRANSPORT=smtp://username:password@smtp.example.com
```

#### .gitignore
```
node_modules/
data/
public/uploads/
public/apos-frontend/
.env
.env.local
*.log
.DS_Store
.nyc_output/
coverage/
.idea/
.vscode/
*.swp
*.swo
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
│   ├── css/
│   ├── js/
│   └── images/
├── data/                      # MongoDB data (dev only)
├── app.js                     # Main application file
├── package.json
├── .env
└── README.md
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

### Creating a Page Type
```javascript
// modules/default-page/index.js
module.exports = {
  extend: '@apostrophecms/page-type',
  
  options: {
    label: 'Default Page'
  },
  
  fields: {
    add: {
      main: {
        type: 'area',
        label: 'Main Content',
        options: {
          widgets: {
            '@apostrophecms/rich-text': {},
            '@apostrophecms/image': {},
            '@apostrophecms/video': {},
            '@apostrophecms/html': {},
            'two-column': {}
          }
        }
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

### Page Template
```html
{# modules/default-page/views/page.html #}
{% extends "layout.html" %}

{% block content %}
  <div class="container">
    <h1>{{ data.page.title }}</h1>
    {% area data.page, 'main' %}
  </div>
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

## Frontend Assets

### JavaScript
```javascript
// modules/asset/ui/src/index.js
export default () => {
  // Self-executing function for Apostrophe frontend
  
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
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
          target.scrollIntoView({ behavior: 'smooth' });
        }
      });
    });
  });
};
```

### SCSS
```scss
// modules/asset/ui/src/index.scss

// Variables
$primary-color: #0066cc;
$text-color: #333;
$font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;

// Base styles
body {
  font-family: $font-family;
  color: $text-color;
  line-height: 1.6;
  margin: 0;
}

// Layout
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

// Two column widget
.two-column-widget {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin: 2rem 0;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

// Navigation
nav {
  background: $primary-color;
  padding: 1rem 0;
  
  .nav-menu {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    
    a {
      color: white;
      text-decoration: none;
      padding: 0.5rem 1rem;
      
      &:hover,
      &.active {
        background: rgba(255, 255, 255, 0.1);
      }
    }
  }
}
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
node app @apostrophecms/db:export

# Import database
node app @apostrophecms/db:import

# List migrations
node app @apostrophecms/migration:list

# Create new migration
node app @apostrophecms/migration:create
```

### Asset Management
```bash
# Clear asset cache
rm -rf public/apos-frontend/*
npm run build

# Sync public assets to S3 (if configured)
node app @apostrophecms/attachment:sync-to-uploadfs
```

## Performance Optimization

### Caching Strategy
```javascript
// modules/@apostrophecms/page/index.js
module.exports = {
  options: {
    cache: {
      page: {
        // Cache pages for 1 hour
        maxAge: 60 * 60
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
          const { title, content } = self.apos.launder.sanitize(req.body, {
            title: 'string',
            content: 'string'
          });
          
          // Process sanitized input
        }
      }
    };
  }
};
```

## Testing

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
      slug: 'test-article'
    });
    
    assert(article._id);
    assert.equal(article.title, 'Test Article');
  });
});
```

## Common Modules

### Essential Apostrophe Modules
- **@apostrophecms/piece-type**: Base for content types
- **@apostrophecms/page-type**: Base for page types
- **@apostrophecms/widget-type**: Base for widgets
- **@apostrophecms/rich-text-widget**: WYSIWYG editor
- **@apostrophecms/image-widget**: Image management
- **@apostrophecms/video-widget**: Video embeds
- **@apostrophecms/form**: Form builder
- **@apostrophecms/sitemap**: XML sitemap
- **@apostrophecms/redirect**: URL redirects
- **@apostrophecms/seo**: SEO tools

### Community Modules
- **apostrophe-blog**: Blog functionality
- **apostrophe-events**: Event management
- **apostrophe-workflow**: Content workflow
- **apostrophe-elasticsearch**: Search integration