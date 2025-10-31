#!/bin/bash

# DevContainer Setup Script for Node.js + Python Development
# Usage: bash setup-devcontainer.sh [project_name]

set -e

PROJECT_NAME=${1:-"my_project"}

echo "🚀 Setting up DevContainer environment for project: $PROJECT_NAME"
echo "=================================================="

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p .devcontainer
mkdir -p {src,tests,docs,scripts,config}
mkdir -p {src/{api,models,services,utils},tests/{unit,integration}}

# Create devcontainer.json
echo "⚙️  Creating devcontainer.json..."
cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "Node.js + Python Development Environment",
  "image": "mcr.microsoft.com/devcontainers/python:1-3.12-bullseye",
  
  "runArgs": [
    "--init",
    "--env-file",
    "${localWorkspaceFolder}/.env"
  ],

  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "nodeGypDependencies": true,
      "version": "lts"
    },
    "ghcr.io/devcontainers/features/git:1": {
      "ppa": true,
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/github-cli:1": {
      "installDirectlyFromGitHubRelease": true,
      "version": "latest"
    }
  },

  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.flake8",
        "ms-vscode.vscode-typescript-next",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "eamodio.gitlens"
      ],
      
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python",
        "python.linting.enabled": true,
        "python.linting.flake8Enabled": true,
        "[python]": {
          "editor.defaultFormatter": "ms-python.black-formatter",
          "editor.formatOnSave": true,
          "editor.codeActionsOnSave": {
            "source.organizeImports": "explicit"
          }
        },
        "[javascript]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode",
          "editor.formatOnSave": true
        },
        "[typescript]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode",
          "editor.formatOnSave": true
        },
        "editor.rulers": [88, 120],
        "files.trimTrailingWhitespace": true,
        "files.insertFinalNewline": true,
        "terminal.integrated.defaultProfile.linux": "bash"
      }
    }
  },

  "forwardPorts": [3000, 5000, 8000, 8080],
  
  "portsAttributes": {
    "3000": {
      "label": "Frontend Dev Server",
      "onAutoForward": "notify"
    },
    "5000": {
      "label": "Python/Flask App", 
      "onAutoForward": "notify"
    },
    "8000": {
      "label": "Python/Django App",
      "onAutoForward": "notify"  
    },
    "8080": {
      "label": "Alternative Web Server",
      "onAutoForward": "notify"
    }
  },

  "remoteUser": "vscode",
  "containerUser": "vscode",
  "shutdownAction": "stopContainer",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspaces/${localWorkspaceFolderBasename},type=bind,consistency=cached",
  "workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}"
}
EOF

# Create .env.template for reference
echo "📝 Creating .env.template..."
cat > .env.template << EOF
# Project Configuration
PROJECT_NAME=$PROJECT_NAME
NODE_ENV=development
PYTHONPATH=/workspaces

# Database Configuration (configure when ready)
# DATABASE_HOST=host.docker.internal
# DATABASE_PORT=5433
# DATABASE_NAME=your_database_name
# DATABASE_USER=your_database_user
# DATABASE_PASSWORD=your_database_password
EOF

# Create requirements.txt
echo "📄 Creating requirements.txt..."
cat > requirements.txt << 'EOF'
# Core web framework
fastapi>=0.104.0
uvicorn[standard]>=0.24.0
pydantic>=2.5.0
python-dotenv>=1.0.0

# Database (install when needed)
sqlalchemy>=2.0.0
alembic>=1.13.0
psycopg2-binary>=2.9.0
asyncpg>=0.29.0

# HTTP client
httpx>=0.25.0
requests>=2.31.0

# Development dependencies
pytest>=7.4.0
pytest-cov>=4.1.0
pytest-asyncio>=0.21.0
black>=23.9.0
isort>=5.12.0
flake8>=6.1.0
mypy>=1.7.0
pre-commit>=3.5.0

# Data processing
pandas>=2.1.0
python-multipart>=0.0.6
EOF

# Create package.json
echo "📄 Creating package.json..."
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Development project: $PROJECT_NAME",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit"
  },
  "devDependencies": {
    "@types/node": "^20.9.0",
    "typescript": "^5.2.0",
    "ts-node": "^10.9.0",
    "nodemon": "^3.0.0",
    "eslint": "^8.54.0",
    "prettier": "^3.1.0",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.0"
  },
  "dependencies": {
    "express": "^4.18.0",
    "dotenv": "^16.3.0"
  }
}
EOF

# Create .gitignore
echo "📄 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Environment variables
.env
.env.local
.env.*.local

# Dependencies
node_modules/
__pycache__/
*.py[cod]
*$py.class

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
env/
ENV/

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Database
*.db
*.sqlite

# Coverage reports
htmlcov/
.coverage
.pytest_cache/

# Jupyter Notebook
.ipynb_checkpoints

# Cache
.cache/
.mypy_cache/
.pytest_cache/
EOF

# Create a simple README
echo "📄 Creating README.md..."
cat > README.md << EOF
# $PROJECT_NAME

Development environment with Node.js and Python support.

## Setup

1. Copy environment template:
   \`\`\`bash
   cp .env.template .env
   \`\`\`

2. Open in VS Code:
   \`\`\`bash
   code .
   \`\`\`

3. Reopen in container:
   - Press \`Ctrl+Shift+P\`
   - Select "Dev Containers: Reopen in Container"
   - Wait for setup to complete

## Database Connection

Configure database connection in \`.env\` file when ready.
EOF

echo ""
echo "✅ DevContainer setup completed!"
echo ""
echo "📁 Project: $PROJECT_NAME"
echo ""
echo "📋 Files created:"
echo "   • .devcontainer/devcontainer.json"
echo "   • .env.template"
echo "   • requirements.txt"
echo "   • package.json"
echo "   • .gitignore"
echo "   • README.md"
echo ""
echo "📝 Next steps:"
echo "   1. cp .env.template .env"
echo "   2. code ."
echo "   3. Reopen in Container (Ctrl+Shift+P)"
echo "   4. Configure database connection later in .env"
echo ""
