# SAGA eCommerce - Development Environment Setup Guide

## Overview

This guide helps developers set up their local development environment for the SAGA Telecom eCommerce platform. Follow these steps to get coding quickly with the modular monolith architecture.

## Prerequisites

### Required Software

**1. .NET 9.0 SDK**
- Download: [https://dotnet.microsoft.com/download/dotnet/9.0](https://dotnet.microsoft.com/download/dotnet/9.0)
- Verify installation: `dotnet --version` (should show 9.0.x)

**2. IDE/Editor (Choose One)**
- **Visual Studio 2022** (17.8 or later) - Recommended for Windows
- **JetBrains Rider** - Cross-platform, excellent for modular projects
- **Visual Studio Code** with C# extension - Lightweight option

**3. Database**
- **SQL Server Developer Edition** (initial development)
- **PostgreSQL 15+** (future migration target)
- **SQL Server Management Studio** or **Azure Data Studio**

**4. Git**
- Latest version from [git-scm.com](https://git-scm.com/)
- Configure with your GitHub credentials

**5. Optional but Recommended**
- **Docker Desktop** (for database containers)
- **Postman** or **Insomnia** (API testing)
- **GitHub CLI** (`gh`) for project management

## Environment Setup

### Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/Nuuday/saga-ecommerce-service.git
cd saga-ecommerce-service

# Verify you're on the main branch
git branch
```

### Step 2: Database Setup

**Option A: SQL Server Local (Quick Start)**
```bash
# Install SQL Server Express LocalDB (if not already installed)
# Download from Microsoft website

# Connection string will be:
# Server=(localdb)\\MSSQLLocalDB;Database=SagaEcommerce;Trusted_Connection=true;
```

**Option B: Docker SQL Server (Recommended)**
```bash
# Run SQL Server in Docker
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
   -p 1433:1433 --name saga-sqlserver \
   -d mcr.microsoft.com/mssql/server:2022-latest

# Connection string:
# Server=localhost,1433;Database=SagaEcommerce;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true;
```

**Option C: PostgreSQL (Future Target)**
```bash
# Run PostgreSQL in Docker
docker run --name saga-postgres \
   -e POSTGRES_PASSWORD=yourpassword \
   -e POSTGRES_DB=sagaecommerce \
   -p 5432:5432 -d postgres:15

# Connection string:
# Host=localhost;Port=5432;Database=sagaecommerce;Username=postgres;Password=yourpassword;
```

### Step 3: Configuration Setup

**Create appsettings.Development.json**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=SagaEcommerce;Trusted_Connection=true;MultipleActiveResultSets=true"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Information"
    }
  },
  "MultiTenant": {
    "DefaultTenant": "default",
    "TenantHeaderName": "X-Tenant-Id"
  },
  "FastEndpoints": {
    "IncludeAbstractValidators": true,
    "SerializerOptions": {
      "PropertyNamingPolicy": "CamelCase"
    }
  },
  "ExternalServices": {
    "ProductService": {
      "BaseUrl": "https://localhost:7001",
      "ApiKey": "dev-api-key"
    },
    "IdentityService": {
      "BaseUrl": "https://localhost:7002",
      "Authority": "https://localhost:7002"
    }
  }
}
```

### Step 4: Environment Variables

**Create .env file (optional for Docker)**
```env
DB_SERVER=localhost
DB_PORT=1433
DB_NAME=SagaEcommerce
DB_USER=sa
DB_PASSWORD=YourStrong@Passw0rd
ASPNETCORE_ENVIRONMENT=Development
```

### Step 5: Build and Run

```bash
# Restore NuGet packages
dotnet restore

# Build the solution
dotnet build

# Run database migrations (when available)
dotnet ef database update --project src/Host

# Run the application
dotnet run --project src/Host

# Verify it's running
curl https://localhost:7000/health
```

## Project Structure Understanding

### Solution Layout
```
saga-ecommerce-service/
├── src/
│   ├── Host/                          # API host application
│   │   ├── Program.cs                 # Application entry point
│   │   ├── appsettings.json          # Configuration
│   │   └── Controllers/               # FastEndpoints controllers
│   ├── Shared/                        # Shared kernel
│   │   ├── Domain/                    # Domain entities and interfaces
│   │   ├── Infrastructure/            # Cross-cutting infrastructure
│   │   └── Application/               # Application services
│   └── Modules/                       # Feature modules
│       ├── Catalog/                   # Product catalog module
│       ├── Channel/                   # Channel management module
│       ├── TenantManagement/          # Multi-tenant functionality
│       └── [Other modules]/
├── tests/
│   ├── UnitTests/
│   ├── IntegrationTests/
│   └── E2ETests/
├── docs/                              # Documentation
└── .github/                           # GitHub workflows
```

### Key Concepts

**1. Modular Monolith**
- Each module is self-contained
- Modules communicate via well-defined interfaces
- Shared kernel provides common functionality

**2. Multi-Tenancy**
- Tenant isolation via TenantId column
- Header-based tenant resolution
- All entities inherit from ITenantAware

**3. FastEndpoints**
- REST API endpoints without traditional controllers
- Built-in validation and serialization
- Type-safe request/response handling

## IDE-Specific Setup

### Visual Studio 2022

**Required Extensions:**
- EntityFramework Core Power Tools
- GitHub Copilot (if available)
- SonarLint

**Configuration:**
1. **Tools** → **Options** → **Text Editor** → **C#** → **Code Style**
2. **Import** team code style settings (when available)
3. **Configure** solution-level NuGet package management

### JetBrains Rider

**Recommended Plugins:**
- .NET Core User Secrets
- Docker Integration
- Database Navigator

**Configuration:**
1. **File** → **Settings** → **Build, Execution, Deployment** → **NuGet**
2. **Enable** package restore on build
3. **Configure** code inspection settings

### Visual Studio Code

**Required Extensions:**
```bash
# Install C# extension pack
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.vscode-dotnet-runtime
code --install-extension formulahendry.dotnet-test-explorer
code --install-extension ms-vscode.vscode-json
```

**Workspace Settings (.vscode/settings.json):**
```json
{
  "dotnet.defaultSolution": "saga-ecommerce-service.sln",
  "files.exclude": {
    "**/bin": true,
    "**/obj": true
  },
  "editor.formatOnSave": true,
  "omnisharp.enableEditorConfigSupport": true
}
```

## Development Workflow

### Daily Development Process

**1. Start of Day**
```bash
# Update from main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name

# Start application with hot reload
dotnet watch run --project src/Host
```

**2. Development Loop**
```bash
# Make changes to code
# Tests run automatically on save (with dotnet watch)
# API automatically reloads on file changes

# Run specific tests
dotnet test tests/UnitTests/Modules.Catalog.Tests/

# Check code formatting
dotnet format
```

**3. End of Day**
```bash
# Commit your changes
git add .
git commit -m "feat: implement product search endpoint"

# Push to remote
git push origin feature/your-feature-name

# Create PR when ready
gh pr create --title "Product search implementation" --body "Implements basic product search with filtering"
```

### Testing Strategy

**Unit Tests**
```bash
# Run all unit tests
dotnet test tests/UnitTests/

# Run specific module tests
dotnet test tests/UnitTests/Modules.Catalog.Tests/

# Generate coverage report
dotnet test --collect:"XPlat Code Coverage"
```

**Integration Tests**
```bash
# Start test database
docker-compose -f docker-compose.test.yml up -d

# Run integration tests
dotnet test tests/IntegrationTests/

# Cleanup
docker-compose -f docker-compose.test.yml down
```

### API Testing

**Using curl:**
```bash
# Health check
curl https://localhost:7000/health

# Get products (with tenant header)
curl -H "X-Tenant-Id: tenant1" https://localhost:7000/api/catalog/products

# Create product
curl -X POST https://localhost:7000/api/catalog/products \
  -H "Content-Type: application/json" \
  -H "X-Tenant-Id: tenant1" \
  -d '{"name":"Test Product","price":29.99}'
```

**Using Postman:**
1. Import the Postman collection (when available)
2. Set environment variables for base URL and tenant ID
3. Use collection runner for API testing

## Troubleshooting

### Common Issues

**1. Build Failures**
```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Clean and rebuild
dotnet clean
dotnet restore
dotnet build
```

**2. Database Connection Issues**
```bash
# Check SQL Server is running
docker ps  # for Docker
# or
services.msc  # for Windows services

# Test connection
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd
```

**3. Port Conflicts**
```bash
# Check what's using port 7000
netstat -ano | findstr :7000  # Windows
lsof -i :7000                 # macOS/Linux

# Change port in launchSettings.json if needed
```

**4. Package Restore Issues**
```bash
# Clear package cache
rm -rf ~/.nuget/packages  # macOS/Linux
rmdir /s ~/.nuget/packages  # Windows

# Restore packages
dotnet restore --force
```

### Getting Help

**Internal Resources:**
- Team Slack channel: #saga-ecommerce-dev
- Architecture documentation: `/docs/technical/`
- Code review guidelines: `/docs/technical/code-review.md`

**External Resources:**
- [FastEndpoints Documentation](https://fast-endpoints.com/)
- [.NET 9 Documentation](https://docs.microsoft.com/dotnet/)
- [Entity Framework Core](https://docs.microsoft.com/ef/core/)

## Performance Tips

### Development Performance

**1. Use Solution Filters**
- Create .slnf files for working on specific modules
- Reduces IDE load time and build time

**2. Enable Hot Reload**
```bash
# Enable hot reload for faster development
dotnet watch run --project src/Host --property WarningLevel=0
```

**3. Parallel Test Execution**
```bash
# Run tests in parallel
dotnet test --parallel
```

### Database Performance

**1. Connection Pooling**
- Configured automatically in Entity Framework
- Monitor connection counts in development

**2. Query Optimization**
- Enable EF Core query logging
- Use Include() carefully for related data
- Consider read-only queries for reports

## Security Considerations

### Development Security

**1. Secrets Management**
```bash
# Initialize user secrets
dotnet user-secrets init --project src/Host

# Set connection string
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "YourConnectionString" --project src/Host

# Set API keys
dotnet user-secrets set "ExternalServices:ProductService:ApiKey" "dev-api-key" --project src/Host
```

**2. HTTPS in Development**
```bash
# Trust development certificate
dotnet dev-certs https --trust
```

**3. Environment Isolation**
- Never commit secrets to repository
- Use different databases for development/testing
- Separate tenant data even in development

## Ready to Code!

### Next Steps

1. ✅ **Complete this setup guide**
2. 🏗️ **Run the initial solution build**
3. 🔧 **Create your first module endpoint**
4. 🧪 **Write your first test**
5. 🚀 **Submit your first PR**

### Quick Verification Checklist

- [ ] .NET 9.0 SDK installed and verified
- [ ] Repository cloned and building
- [ ] Database running and accessible
- [ ] Application starts without errors
- [ ] Health endpoint returns 200 OK
- [ ] IDE configured with required extensions
- [ ] Tests run successfully
- [ ] Hot reload working

**🎉 You're ready to build the SAGA eCommerce platform!**

---

**Estimated Setup Time:** 30-45 minutes  
**Prerequisites:** Basic C# and .NET knowledge  
**Support:** Contact team leads for environment issues