# Node.js Development Best Practices

## Project Setup

### Initialize New Project
```bash
npm init -y
# or with more interactive setup
npm init
```

### Package Managers
- **npm**: Default, comes with Node.js
- **yarn**: Alternative with better performance and lockfile
- **pnpm**: Efficient disk space usage

### Essential Configuration Files

#### package.json
```json
{
  "name": "project-name",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix",
    "format": "prettier --write \"src/**/*.js\"",
    "build": "babel src -d dist",
    "typecheck": "tsc --noEmit"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

#### .gitignore
```
node_modules/
dist/
build/
.env
.env.local
.env.*.local
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.DS_Store
*.log
coverage/
.nyc_output/
```

#### .eslintrc.json
```json
{
  "env": {
    "node": true,
    "es2021": true
  },
  "extends": ["eslint:recommended"],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-console": ["warn", { "allow": ["warn", "error"] }]
  }
}
```

## Common Commands

### Development
```bash
# Install dependencies
npm install

# Install specific package
npm install express
npm install --save-dev nodemon

# Run development server
npm run dev

# Run production
npm start

# Check for outdated packages
npm outdated

# Update packages
npm update

# Audit for vulnerabilities
npm audit
npm audit fix
```

### Testing
```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test -- --coverage
```

### Code Quality
```bash
# Run linter
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Type checking (if using TypeScript)
npm run typecheck
```

## Project Structure
```
project-root/
├── src/
│   ├── index.js          # Entry point
│   ├── config/           # Configuration files
│   ├── controllers/      # Route controllers
│   ├── models/          # Data models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── utils/           # Utility functions
│   └── middleware/      # Custom middleware
├── tests/
│   ├── unit/           # Unit tests
│   ├── integration/    # Integration tests
│   └── e2e/           # End-to-end tests
├── public/            # Static files
├── docs/              # Documentation
├── scripts/           # Build/deployment scripts
├── .env.example       # Environment variables template
├── package.json
├── package-lock.json
├── README.md
└── .gitignore
```

## Dependencies Management

### Production vs Development Dependencies
```bash
# Production dependencies
npm install express mongoose dotenv

# Development dependencies
npm install --save-dev nodemon jest eslint prettier
```

### Security Best Practices
- Keep dependencies updated
- Use `npm audit` regularly
- Use exact versions in production
- Review dependency licenses
- Minimize dependency count

## Environment Variables
```bash
# .env file
NODE_ENV=development
PORT=3000
DATABASE_URL=mongodb://localhost:27017/myapp
JWT_SECRET=your-secret-key
```

### Loading Environment Variables
```javascript
// Load at the very beginning
require('dotenv').config();

// Or with ES modules
import dotenv from 'dotenv';
dotenv.config();
```

## Error Handling

### Global Error Handler
```javascript
// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    message: err.message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// Unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});
```

## Performance Optimization

### Best Practices
- Use async/await for asynchronous operations
- Implement proper caching strategies
- Use compression middleware
- Enable CORS appropriately
- Use PM2 for production process management
- Monitor memory usage and leaks

### Production Checklist
- [ ] Environment variables secured
- [ ] Error logging configured
- [ ] Security headers implemented
- [ ] Rate limiting enabled
- [ ] Input validation in place
- [ ] SQL/NoSQL injection prevention
- [ ] XSS protection enabled
- [ ] HTTPS enforced
- [ ] Dependencies updated
- [ ] Tests passing
- [ ] Documentation updated

## Debugging

### Debug Commands
```bash
# Debug with Node.js inspector
node --inspect src/index.js

# Debug with breakpoints
node --inspect-brk src/index.js

# Debug with VS Code
# Add launch.json configuration
```

### Logging
```javascript
// Use a proper logging library
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}
```

## Common Libraries

### Web Frameworks
- **Express**: Minimal and flexible
- **Fastify**: High performance
- **Koa**: Modern and lightweight
- **NestJS**: Enterprise-grade TypeScript

### Database
- **MongoDB**: mongoose, mongodb
- **PostgreSQL**: pg, sequelize
- **MySQL**: mysql2, sequelize
- **Redis**: redis, ioredis

### Testing
- **Jest**: Testing framework
- **Mocha**: Test runner
- **Chai**: Assertion library
- **Supertest**: HTTP testing

### Utilities
- **Lodash**: Utility functions
- **Axios**: HTTP client
- **Joi**: Data validation
- **Bcrypt**: Password hashing
- **JWT**: jsonwebtoken
- **Nodemailer**: Email sending