# Python Flask Application with Users and Products API

## 📋 Overview

This is a Python Flask application that provides RESTful API endpoints for managing users and products. The application returns JSON responses and includes a comprehensive CI/CD pipeline with both SAST and DAST security testing, automated testing, security scanning, and deployment.

## 🔍 Security Testing Implementation

### ✅ **SAST (Static Application Security Testing) - IMPLEMENTED**

**Your pipeline includes these SAST tools:**

1. **Hadolint** - SAST for Dockerfile
   - Scans Dockerfile for security misconfigurations and best practices
   - Identifies security issues in container configuration

2. **Gitleaks** - SAST for Secrets Detection
   - Scans codebase for accidentally committed secrets, API keys, tokens
   - Prevents credential leakage in version control

3. **Ruff** - SAST for Code Quality
   - Python code linting that can identify security-related code issues
   - Catches potential security anti-patterns in Python code

4. **Trivy** - SAST for Container Images
   - Scans built Docker images for known vulnerabilities in OS packages and dependencies
   - Identifies CVEs in your containerized application

### ✅ **DAST (Dynamic Application Security Testing) - IMPLEMENTED**

**Your pipeline includes these DAST tools:**

1. **OWASP ZAP** - Full DAST Implementation
   - Performs active scanning against your running application
   - Tests for OWASP Top 10 vulnerabilities:
     - SQL Injection
     - Cross-Site Scripting (XSS)
     - Cross-Site Request Forgery (CSRF)
     - Security misconfigurations
     - Broken authentication
   - Tests the actual running application, not just the code

2. **Container Smoke Tests** - Runtime Security Validation
   - Verifies the application starts correctly and responds to requests
   - Health check validation ensures basic functionality

## 🛡️ **Comprehensive Security Coverage**

### **SAST Coverage:**
- **✅ Code** (Python via Ruff)
- **✅ Configuration** (Dockerfile via Hadolint) 
- **✅ Secrets** (Entire repo via Gitleaks)
- **✅ Dependencies** (Container image via Trivy)

### **DAST Coverage:**
- **✅ Running Application** (Web app via OWASP ZAP)
- **✅ Runtime Behavior** (Container via smoke tests)
- **✅ API Endpoints** (All exposed endpoints via ZAP)

## 🏗️ Application Architecture

### Project Structure
```
.
├── Dockerfile
├── README.md
├── app
│   ├── __init__.py
│   ├── main.py
│   ├── routes
│   │   ├── __init__.py
│   │   ├── product_routes.py
│   │   └── user_routes.py
│   └── services
│       ├── __init__.py
│       ├── product_service.py
│       └── user_service.py
├── requirements.txt
└── run.py
```

## 🔧 Application Setup

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python run.py

# Or using Flask directly
flask run --host=0.0.0.0 --port=5000
```

### Docker Development
```bash
# Build the image
docker build -t python-app .

# Run the container
docker run -p 5000:5000 python-app
```

## 🧪 Testing & Code Coverage

### Current Testing Status

**⚠️ Note: This application currently does not include unit tests.** This can be planned improvement for future development.

### Code Coverage with coverage.py

While there are no unit tests yet, you can set up code coverage analysis to prepare for future test implementation:

#### Basic Coverage Setup

**Install coverage.py:**
```bash
pip install coverage
```

**Create `.coveragerc` configuration:**
```ini
[run]
source = app
omit = 
    */__pycache__/*
    */tests/*
    */venv/*
    */virtualenv/*

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    if self.debug:
    raise AssertionError
    raise NotImplementedError
    if 0:
    if __name__ == .__main__.:

[html]
directory = htmlcov
```

#### Running Basic Coverage Analysis

Even without tests, you can analyze code structure:

```bash
# Check which files would be measured
coverage run --include="app/*" -m flask routes

# Generate report showing uncovered files
coverage report
coverage html
```

### Future Testing Improvements Planned

1. **Unit Tests** - Test individual components and services
2. **Integration Tests** - Test API endpoints and database interactions
3. **Test Coverage** - Achieve >80% code coverage
4. **SonarQube Integration** - Code quality and security analysis

## 🐳 Docker Configuration

### Dockerfile Analysis

```dockerfile
# Use a slim Python base image for a smaller image size
FROM python:3.9-slim-buster

# Set environment variables for Python optimization
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire application code into the container
COPY . .

# Change ownership of the app directory to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the port your application listens on 
EXPOSE 5000

# Add healthcheck using urllib (built-in, no extra dependencies needed)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health', timeout=2)" || exit 1

# Define the command to run your application
CMD ["python", "-c", "from app.main import app; app.run(host='0.0.0.0', port=5000)"]
```

### 🔒 Security Features in Dockerfile
- **Non-root user**: Application runs as `appuser` instead of root
- **Slim base image**: Reduced attack surface using `python:3.9-slim-buster`
- **Environment hardening**: Python-specific security settings
- **Health checks**: Built-in container health monitoring
- **Minimal dependencies**: Uses built-in `urllib` for health checks

## 🏥 Health Check Implementation

The application includes a health check endpoint at `/health` that is used by:

1. **Docker HEALTHCHECK** instruction
2. **CI/CD pipeline** for smoke testing
3. **Kubernetes** for liveness and readiness probes

### Health Check Code
```python
@app.route('/health')
def health_check():
    return {'status': 'healthy', 'service': 'running'}, 200
```

## 🔄 CI/CD Pipeline

This repository includes a comprehensive GitHub Actions workflow that automates security testing and deployment:

### 📋 **Security Testing Pipeline Flow**

```
Code Commit
    ↓
SAST Phase:
├── Gitleaks (Secrets in code)
├── Hadolint (Dockerfile security)  
├── Ruff (Python code quality)
└── Trivy (Container vulnerabilities)
    ↓
Build & Deploy Test Environment
    ↓
DAST Phase:
├── OWASP ZAP (Running application scanning)
├── Smoke Tests (Runtime validation)
└── Health Checks (Service availability)
    ↓
Security Reports Generated
```

### Pipeline Jobs

#### 1. **Build & Security Scan**
- **Dockerfile Linting**: `hadolint` for best practices
- **Python Linting**: `ruff` for code quality
- **Secrets Detection**: `gitleaks` to prevent credential leakage
- **Container Vulnerability Scan**: `Trivy` for security vulnerabilities
- **Dynamic Security Testing**: `OWASP ZAP` for web application security

#### 2. **Testing & Validation**
- **Container Smoke Test**: Builds and runs the container
- **Health Check Validation**: Verifies `/health` endpoint
- **Application Testing**: Ensures API endpoints are functional

#### 3. **Registry Push**
- **Google Container Registry**: Pushes to GCR with version tags
- **Image Tagging**: Tags with Git SHA and `latest`

#### 4. **GitOps Deployment**
- **Automatic Updates**: Updates Kubernetes manifests in [mounirbasta/k8s](https://github.com/mounirbasta/k8s)
- **ArgoCD Integration**: Triggers automatic deployments

### 🛡️ Security Scanning Details

#### **Gitleaks** (Secrets Detection)
- Scans entire codebase for accidentally committed secrets
- Prevents API keys, passwords, and tokens from being exposed

#### **Trivy** (Vulnerability Scanner)
- Comprehensive container image vulnerability database
- Scans for known CVEs in operating system and application dependencies

#### **OWASP ZAP** (Web Application Security)
- Dynamic application security testing
- Tests for OWASP Top 10 vulnerabilities including:
  - SQL Injection
  - Cross-Site Scripting (XSS)
  - Cross-Site Request Forgery (CSRF)
  - Security misconfigurations

#### **Hadolint** (Dockerfile Security)
- Analyzes Dockerfile for security best practices
- Ensures minimal attack surface and proper user permissions

### 🔐 Required Secrets

The pipeline requires these GitHub Secrets:

| Secret Name | Purpose |
|-------------|---------|
| `GCP_SA_KEY` | Google Cloud Service Account JSON key for GCR access |
| `GITOPS_PAT` | GitHub Personal Access Token for updating k8s repository |

## 🚀 Deployment Flow

1. **Code Commit** → Triggers GitHub Actions workflow
2. **SAST Validation** → Static security analysis of code and configuration
3. **Container Build** → Docker image built with security best practices
4. **DAST Validation** → Dynamic security testing of running application
5. **Testing** → Smoke tests and health checks verify application functionality
6. **Registry Push** → Image pushed to Google Container Registry
7. **GitOps Update** → Kubernetes manifests automatically updated
8. **ArgoCD Sync** → Automatic deployment to Kubernetes cluster

## 🔍 Development

### Code Structure
- **`app/main.py`**: Application factory and health check route
- **`app/routes/`**: API route definitions
- **`app/services/`**: Business logic and data services
- **`run.py`**: Application entry point

### Adding New Endpoints
1. Create route in `app/routes/`
2. Add service logic in `app/services/`
3. Register blueprint in `app/main.py`

## 🚧 Future Improvements

### Testing & Quality (Future)
- [ ] Add unit tests using pytest
- [ ] Implement integration tests
- [ ] Set up code coverage with coverage.py
- [ ] Integrate SonarQube for code quality analysis
- [ ] Add performance testing
- [ ] Implement API contract testing

### Security Enhancements (Future)
- [ ] Implement dependency scanning with Snyk or Dependabot

### Code Coverage Setup (Future)
When tests are added, configure coverage.py:

```bash
# Install testing dependencies
pip install pytest pytest-cov coverage

# Run tests with coverage
pytest --cov=app --cov-report=html --cov-report=xml

# Generate detailed reports
coverage run -m pytest
coverage report -m
coverage html
```

## 📝 Notes

- The application uses Flask blueprints for modular route organization
- All endpoints return JSON responses
- Health check endpoint is essential for container orchestration
- The CI/CD pipeline ensures comprehensive security with both SAST and DAST
- GitOps approach enables automated Kubernetes deployments
- **Unit tests and code coverage can be planned improvements** - currently the focus is on security scanning and functional testing
- Coverage.py can be used to measure test coverage once unit tests are implemented

This Python application demonstrates modern development practices with comprehensive SAST and DAST security testing, automated deployment through a robust CI/CD pipeline. The security testing covers both static code analysis and dynamic runtime testing for complete application security.
