# dev_container_setup
fast devcontainer setup with shared postgres db dockerized
# 🚀 Backbone DevContainer Environment

A complete, production-ready development environment with database connectivity, schema management, and modern development tools. Get from zero to coding in under 2 minutes!

## ⚡ Quick Start

### Option 1: One-Command Setup (Fastest)
```bash
# Create new project directory
mkdir my_new_project && cd my_new_project

# Run the setup script
bash setup-devcontainer.sh my_new_project

# Configure environment
cp .env.template .env
# Edit .env and update POSTGRES_PASSWORD

# Open in VS Code and reopen in container
code .
# Ctrl+Shift+P → "Dev Containers: Reopen in Container"
```

### Option 2: Download Script First
```bash
# Download the setup script
wget https://path-to-your-script/setup-devcontainer.sh
chmod +x setup-devcontainer.sh

# Run with your project name
./setup-devcontainer.sh ecommerce_api
```

## 🎯 What You Get

### Complete Development Stack
- **Python 3.12** with FastAPI, SQLAlchemy, pytest, and more
- **Node.js LTS** with TypeScript, ESLint, Prettier
- **PostgreSQL client** tools for database interaction
- **Git, Docker, GitHub CLI** for version control and deployment

### Database Integration
- **Automatic connection** to backbone_db_dev PostgreSQL container
- **Schema management** tools for multi-project organization
- **Connection testing** with built-in diagnostics
- **SQLTools integration** for VS Code database queries

### Code Quality Tools
- **Python**: Black, isort, flake8, mypy, pre-commit hooks
- **JavaScript/TypeScript**: ESLint, Prettier, TypeScript compiler
- **Git hooks**: Automated code formatting and linting
- **Testing**: pytest, jest with coverage reporting

### VS Code Extensions
- Python development (Pylance, formatters, linters)
- JavaScript/TypeScript development
- Database tools (PostgreSQL, SQLTools)
- Git integration (GitLens)
- Code formatting and quality tools

## 📁 Project Structure

After running the setup script, you'll have:

```
my_new_project/
├── .devcontainer/
│   ├── devcontainer.json      # DevContainer configuration
│   ├── post-create.sh         # Environment setup script
│   ├── database-test.py       # Database connection tester
│   ├── schema-tools.py        # Schema management utility
│   └── bashrc-append          # Shell customizations
├── src/
│   ├── api/                   # API endpoints
│   ├── models/                # Database models
│   ├── services/              # Business logic
│   └── utils/                 # Utility functions
├── tests/
│   ├── unit/                  # Unit tests
│   └── integration/           # Integration tests
├── docs/                      # Documentation
├── scripts/                   # Utility scripts
├── config/                    # Configuration files
├── migrations/                # Database migrations
├── requirements.txt           # Python dependencies
├── package.json              # Node.js dependencies
├── .env.template             # Environment template
├── .gitignore                # Git ignore rules
└── .pre-commit-config.yaml   # Code quality hooks
```

## 🗄️ Database Schema Management

Each project gets its own schema within the shared `backbone_dev` database:

```
backbone_dev (database)
├── public (shared utilities)
├── project_alpha (your project)
├── project_beta (another project)
└── shared_services (common services)
```

### Schema Commands
```bash
# List all schemas
schema-list

# Create new project schema
schema-create my_project --description "My awesome project"

# Drop schema (with confirmation)
schema drop old_project

# Test database connection
dbtest

# Connect to database directly
db_connect
```

## 🔧 Prerequisites

### Required
1. **Docker Desktop** running on your host machine
2. **VS Code** with Dev Containers extension installed
3. **PostgreSQL backbone_db_dev** container running

### Database Setup
Ensure your backbone_db_dev container is running:

```yaml
# docker-compose.yml
services:
  dev-postgres:
    image: postgres:15-alpine
    container_name: backbone_db_dev
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "${POSTGRES_PORT:-5433}:5432"
    volumes:
      - /hdd/backbonde_db:/var/lib/postgresql/data
    networks:
      - backbone-dev-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  backbone-dev-network:
    external: true
```

## ⚙️ Environment Configuration

### Required Environment Variables (.env)
```bash
# Database Configuration
POSTGRES_DB=backbone_dev
POSTGRES_USER=backbone_user
POSTGRES_PASSWORD=your_secure_password_here
POSTGRES_PORT=5433

# Project Configuration
PROJECT_SCHEMA=my_project
NODE_ENV=development
```

### Optional Configuration
```bash
# API Settings
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=true

# Security (for production)
SECRET_KEY=your-secret-key
JWT_SECRET=your-jwt-secret
JWT_EXPIRE_HOURS=24
```

## 🛠️ Development Workflow

### Initial Setup
```bash
# Install dependencies
pip install -r requirements.txt
npm install

# Set up code quality tools
pre-commit install

# Test database connection
dbtest

# Create your project schema
schema-create my_project
```

### Daily Development
```bash
# Start development server (Python)
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Start development server (Node.js)
npm run dev

# Run tests
pytest                    # Python tests
npm test                 # Node.js tests

# Code formatting
black .                  # Python formatting
npm run format          # JavaScript formatting

# Linting
flake8 .                # Python linting
npm run lint            # JavaScript linting
```

### Database Operations
```bash
# Create migration (SQLAlchemy)
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Create migration (Prisma)
npx prisma migrate dev --name description

# Generate Prisma client
npx prisma generate
```

## 🔍 Useful Aliases

The environment includes many helpful aliases:

### Git Shortcuts
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git log --oneline

### Development Shortcuts
- `ll` - detailed file listing
- `..` / `...` - navigate up directories
- `ni` - npm install
- `nr` - npm run
- `pytest` - run Python tests

### Database Shortcuts
- `dbtest` - test database connection
- `db_connect` - connect to database with psql
- `db_status` - check database status
- `schema-list` - list all schemas
- `schema-create` - create new schema

## 🚨 Troubleshooting

### Database Connection Issues
```bash
# Check if backbone_db_dev container is running
docker ps | grep backbone_db_dev

# Verify network exists
docker network ls | grep backbone-dev-network

# Test connection
dbtest

# Check environment variables
env | grep -E "(POSTGRES|DATABASE)"
```

### DevContainer Issues
```bash
# Rebuild container
# Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# Check Docker logs
docker logs backbone_db_dev

# Verify network connectivity
ping backbone_db_dev  # from inside container
```

### Common Solutions
1. **Database connection fails**: Ensure backbone_db_dev container is running on backbone-dev-network
2. **Permission errors**: Check database user permissions in PostgreSQL
3. **Network issues**: Verify backbone-dev-network exists: `docker network create backbone-dev-network`
4. **Container build fails**: Try rebuilding with "Rebuild Container" command

## 📊 Port Forwarding

The DevContainer automatically forwards these ports:

| Port | Service | Description |
|------|---------|-------------|
| 3000 | Frontend | React/Vue development server |
| 5000 | Python | Flask application |
| 8000 | Python | Django/FastAPI application |
| 8080 | Alternative | Additional web server |

## 🔐 Security Notes

- **Never commit `.env` files** - they contain sensitive credentials
- **Use strong passwords** for database connections
- **Keep `.env.template`** for documentation and team setup
- **Review permissions** when deploying to production

## 🎯 Best Practices

### Project Organization
- Use **snake_case** for schema names (`user_management`, `ecommerce_api`)
- Keep **migrations** separate per project
- Use **shared_services** schema for common utilities
- Maintain **consistent naming** across projects

### Development Workflow
- **Create feature branches** for new development
- **Run tests** before committing (`pre-commit` handles this)
- **Use schema isolation** to avoid conflicts between projects
- **Document APIs** with FastAPI/OpenAPI automatic documentation

### Database Management
- **Back up data** before major schema changes
- **Use migrations** for all database changes
- **Test locally** before applying to shared databases
- **Monitor schema sizes** and optimize as needed

## 🚀 Advanced Usage

### Multiple Projects
Each project can have its own schema within the same database:

```python
# Project A uses schema 'ecommerce'
DATABASE_URL = "postgresql://user:pass@host/db?options=-csearch_path%3Decommerce"

# Project B uses schema 'blog'
DATABASE_URL = "postgresql://user:pass@host/db?options=-csearch_path%3Dblog"
```

### Cross-Schema Queries
```sql
-- Access tables from other schemas
SELECT * FROM shared_services.audit_logs 
WHERE schema_name = 'ecommerce';

-- Join across schemas
SELECT u.*, a.action 
FROM ecommerce.users u
JOIN shared_services.audit_logs a ON u.id = a.user_id;
```

### Custom Extensions
Add project-specific tools to `.devcontainer/post-create.sh`:

```bash
# Install additional Python packages
pip install --user custom-package

# Install additional Node.js packages
npm install -g custom-cli-tool

# Set up project-specific aliases
echo "alias myapp='python src/main.py'" >> ~/.bashrc
```

## 📝 Contributing

To improve this DevContainer setup:

1. **Fork the repository**
2. **Make your changes** to the setup scripts
3. **Test thoroughly** with a new project
4. **Submit a pull request** with description of improvements

## 📞 Support

If you encounter issues:

1. **Check the troubleshooting section** above
2. **Review environment variables** and database connectivity
3. **Check Docker and VS Code logs** for specific errors
4. **Create an issue** with detailed error information

---

## 🎉 Happy Coding!

You now have a complete, professional development environment that scales with your projects. The schema-based organization keeps everything clean and isolated while sharing common infrastructure.

**Total setup time: ~2 minutes**  
**Time to first commit: ~5 minutes**

Start building amazing things! 🚀

