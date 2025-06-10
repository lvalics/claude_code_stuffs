# Docker Development Best Practices

## Docker Basics

### Installation Check
```bash
# Check Docker version
docker --version
docker version

# Check Docker Compose version
docker-compose --version

# Verify installation
docker run hello-world

# System information
docker info
```

## Dockerfile Best Practices

### Basic Dockerfile Structure
```dockerfile
# Use specific version tags, not 'latest'
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy dependency files first (better layer caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Change ownership
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Use exec form for ENTRYPOINT/CMD
CMD ["node", "server.js"]
```

### Multi-stage Build Example
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app

# Install production dependencies
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy built application from build stage
COPY --from=builder /app/dist ./dist

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Python Dockerfile Example
```dockerfile
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Create non-root user
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
```

### Java Dockerfile Example
```dockerfile
# Build stage
FROM maven:3.8-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /app/target/*.jar app.jar

# Create non-root user
RUN useradd -m -u 1001 appuser
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Docker Compose

### Basic docker-compose.yml
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
    depends_on:
      - db
      - redis
    volumes:
      - ./uploads:/app/uploads
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Development vs Production Compose
```yaml
# docker-compose.yml (base)
version: '3.8'

services:
  web:
    build: .
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: myapp

# docker-compose.dev.yml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    command: npm run dev

  db:
    ports:
      - "5432:5432"

# docker-compose.prod.yml
version: '3.8'

services:
  web:
    image: myapp:latest
    ports:
      - "80:3000"
    environment:
      - NODE_ENV=production
    restart: always

  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: always

volumes:
  postgres_data:
```

## Common Docker Commands

### Container Management
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Start/stop container
docker start container_name
docker stop container_name

# Remove container
docker rm container_name

# Remove all stopped containers
docker container prune

# View container logs
docker logs container_name
docker logs -f container_name  # Follow logs

# Execute command in container
docker exec -it container_name bash
docker exec container_name ls -la

# Copy files to/from container
docker cp file.txt container_name:/path/to/destination
docker cp container_name:/path/to/file.txt .
```

### Image Management
```bash
# List images
docker images

# Build image
docker build -t myapp:latest .
docker build -t myapp:latest -f Dockerfile.prod .

# Tag image
docker tag myapp:latest myapp:v1.0.0

# Push to registry
docker push username/myapp:latest

# Pull from registry
docker pull username/myapp:latest

# Remove image
docker rmi image_name

# Remove unused images
docker image prune
docker image prune -a  # Remove all unused images
```

### Docker Compose Commands
```bash
# Start services
docker-compose up
docker-compose up -d  # Detached mode

# Start with specific compose files
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Stop services
docker-compose down
docker-compose down -v  # Also remove volumes

# View logs
docker-compose logs
docker-compose logs -f service_name

# Rebuild services
docker-compose build
docker-compose up --build

# Scale service
docker-compose up --scale web=3

# Execute command in service
docker-compose exec web bash
docker-compose run web npm test

# View running services
docker-compose ps
```

## .dockerignore
```
# Version control
.git
.gitignore

# Documentation
README.md
docs/
*.md

# Development files
.env.local
.env.*.local
docker-compose.dev.yml

# Dependencies
node_modules/
npm-debug.log
yarn-error.log

# Build artifacts
dist/
build/
*.log

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Test files
coverage/
.nyc_output/
```

## Environment Variables

### Using .env files
```bash
# .env file
DATABASE_URL=postgresql://user:pass@localhost:5432/myapp
REDIS_URL=redis://localhost:6379
API_KEY=secret_key
```

### Docker Compose with .env
```yaml
version: '3.8'

services:
  web:
    image: myapp
    env_file:
      - .env
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
```

### Runtime environment variables
```bash
# Pass environment variables
docker run -e NODE_ENV=production -e API_KEY=secret myapp

# Use env file
docker run --env-file .env myapp
```

## Networking

### Create custom network
```bash
# Create network
docker network create myapp-network

# Run containers on network
docker run --network myapp-network --name db postgres
docker run --network myapp-network --name web myapp

# List networks
docker network ls

# Inspect network
docker network inspect myapp-network
```

### Docker Compose networking
```yaml
version: '3.8'

services:
  web:
    build: .
    networks:
      - frontend
      - backend

  db:
    image: postgres
    networks:
      - backend

  nginx:
    image: nginx
    networks:
      - frontend

networks:
  frontend:
  backend:
```

## Volume Management

### Types of volumes
```bash
# Named volumes (managed by Docker)
docker run -v mydata:/data myapp

# Bind mounts (host directory)
docker run -v /host/path:/container/path myapp

# Anonymous volumes
docker run -v /data myapp
```

### Volume commands
```bash
# Create volume
docker volume create mydata

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mydata

# Remove volume
docker volume rm mydata

# Remove unused volumes
docker volume prune
```

## Health Checks

### Dockerfile health check
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

### Docker Compose health check
```yaml
version: '3.8'

services:
  web:
    build: .
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 40s
```

## Security Best Practices

1. **Use official base images**
2. **Specify exact versions, not 'latest'**
3. **Run as non-root user**
4. **Minimize layers and image size**
5. **Don't store secrets in images**
6. **Scan images for vulnerabilities**
7. **Use multi-stage builds**
8. **Set resource limits**

### Resource limits example
```yaml
version: '3.8'

services:
  web:
    build: .
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

## Debugging

### Debug commands
```bash
# Inspect container
docker inspect container_name

# View container processes
docker top container_name

# View resource usage
docker stats

# View container filesystem changes
docker diff container_name

# Debug failed build
docker build --no-cache -t myapp .
docker build --progress=plain -t myapp .

# Run with debugging
docker run -it --rm myapp sh
```

## Production Deployment

### Registry usage
```bash
# Docker Hub
docker login
docker tag myapp:latest username/myapp:latest
docker push username/myapp:latest

# Private registry
docker login registry.example.com
docker tag myapp:latest registry.example.com/myapp:latest
docker push registry.example.com/myapp:latest
```

### Docker Swarm basics
```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml myapp

# List services
docker service ls

# Scale service
docker service scale myapp_web=3

# Update service
docker service update --image myapp:v2 myapp_web
```

## Optimization Tips

1. **Order Dockerfile commands from least to most frequently changing**
2. **Combine RUN commands to reduce layers**
3. **Use .dockerignore to exclude unnecessary files**
4. **Clean up package manager caches**
5. **Use alpine images when possible**
6. **Remove unnecessary dependencies**
7. **Use specific COPY instead of COPY .**
8. **Leverage build cache effectively**