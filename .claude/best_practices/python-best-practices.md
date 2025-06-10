# Python Development Best Practices

## Project Setup

### Virtual Environment
```bash
# Create virtual environment
python -m venv venv
# or
python3 -m venv venv

# Activate virtual environment
# On Windows
venv\Scripts\activate
# On macOS/Linux
source venv/bin/activate

# Deactivate when done
deactivate
```

### Project Initialization
```bash
# Create project structure
mkdir project-name
cd project-name
git init
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Create requirements files
touch requirements.txt
touch requirements-dev.txt
touch .gitignore
touch README.md
```

### Essential Configuration Files

#### .gitignore
```
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Virtual Environment
venv/
env/
ENV/

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

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.hypothesis/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Environment variables
.env
.env.local

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version

# mypy
.mypy_cache/
.dmypy.json
dmypy.json
```

#### pyproject.toml
```toml
[tool.black]
line-length = 88
target-version = ['py38']

[tool.isort]
profile = "black"
line_length = 88

[tool.pytest.ini_options]
minversion = "6.0"
addopts = "-ra -q --strict-markers"
testpaths = ["tests"]

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

#### setup.py (for packages)
```python
from setuptools import setup, find_packages

setup(
    name="project-name",
    version="0.1.0",
    author="Your Name",
    author_email="your.email@example.com",
    description="A short description",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/project-name",
    packages=find_packages(exclude=["tests", "tests.*"]),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.8",
    install_requires=[
        # List your dependencies here
    ],
)
```

## Common Commands

### Package Management
```bash
# Install packages
pip install package-name
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Save dependencies
pip freeze > requirements.txt

# Upgrade pip
pip install --upgrade pip

# List installed packages
pip list

# Show package info
pip show package-name

# Uninstall package
pip uninstall package-name
```

### Code Quality
```bash
# Format code with Black
black .

# Sort imports with isort
isort .

# Lint with flake8
flake8 .

# Type checking with mypy
mypy .

# All-in-one with pre-commit
pre-commit run --all-files
```

### Testing
```bash
# Run tests with pytest
pytest

# Run with coverage
pytest --cov=src tests/

# Run specific test file
pytest tests/test_module.py

# Run tests matching pattern
pytest -k "test_pattern"

# Verbose output
pytest -v

# Show print statements
pytest -s
```

## Project Structure
```
project-root/
├── src/
│   └── package_name/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── models/
│       │   └── __init__.py
│       ├── services/
│       │   └── __init__.py
│       ├── utils/
│       │   └── __init__.py
│       └── api/
│           └── __init__.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── unit/
│   │   └── __init__.py
│   ├── integration/
│   │   └── __init__.py
│   └── fixtures/
├── docs/
├── scripts/
├── requirements.txt
├── requirements-dev.txt
├── setup.py
├── pyproject.toml
├── .gitignore
├── .env.example
├── README.md
├── LICENSE
└── Makefile
```

## Dependency Management

### Requirements Files
```bash
# requirements.txt - Production dependencies
flask==2.3.0
sqlalchemy==2.0.0
python-dotenv==1.0.0

# requirements-dev.txt - Development dependencies
-r requirements.txt
pytest==7.4.0
pytest-cov==4.1.0
black==23.7.0
flake8==6.1.0
mypy==1.5.0
pre-commit==3.3.3
```

### Using Poetry (Alternative)
```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Initialize project
poetry new project-name
# or in existing project
poetry init

# Add dependencies
poetry add flask sqlalchemy

# Add dev dependencies
poetry add --group dev pytest black flake8

# Install dependencies
poetry install

# Run commands
poetry run python main.py
poetry run pytest
```

## Environment Variables

### Using python-dotenv
```python
# .env file
DEBUG=True
DATABASE_URL=postgresql://user:pass@localhost/dbname
SECRET_KEY=your-secret-key
API_KEY=your-api-key

# Load in Python
from dotenv import load_dotenv
import os

load_dotenv()

DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'
DATABASE_URL = os.getenv('DATABASE_URL')
SECRET_KEY = os.getenv('SECRET_KEY')
```

## Error Handling

### Exception Handling Best Practices
```python
import logging

logger = logging.getLogger(__name__)

class CustomError(Exception):
    """Base exception for this module"""
    pass

class ValidationError(CustomError):
    """Raised when validation fails"""
    pass

def risky_operation():
    try:
        # Risky code
        result = perform_operation()
    except SpecificError as e:
        logger.error(f"Specific error occurred: {e}")
        raise CustomError(f"Operation failed: {e}") from e
    except Exception as e:
        logger.exception("Unexpected error occurred")
        raise
    else:
        # Executes if no exception
        logger.info("Operation successful")
    finally:
        # Always executes
        cleanup()
    
    return result
```

## Testing Best Practices

### Pytest Configuration
```python
# conftest.py
import pytest
from your_app import create_app, db

@pytest.fixture
def app():
    app = create_app('testing')
    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

# Example test
def test_example(client):
    response = client.get('/api/endpoint')
    assert response.status_code == 200
```

### Test Structure
```python
# tests/test_module.py
import pytest
from src.module import function_to_test

class TestClassName:
    def test_happy_path(self):
        result = function_to_test(valid_input)
        assert result == expected_output
    
    def test_edge_case(self):
        with pytest.raises(ValueError):
            function_to_test(invalid_input)
    
    @pytest.mark.parametrize("input,expected", [
        (1, 2),
        (2, 4),
        (3, 6),
    ])
    def test_multiple_cases(self, input, expected):
        assert function_to_test(input) == expected
```

## Logging Configuration

```python
import logging
import logging.config

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'default': {
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        },
        'detailed': {
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'level': 'INFO',
            'formatter': 'default',
            'stream': 'ext://sys.stdout',
        },
        'file': {
            'class': 'logging.handlers.RotatingFileHandler',
            'level': 'DEBUG',
            'formatter': 'detailed',
            'filename': 'app.log',
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
        },
    },
    'root': {
        'level': 'DEBUG',
        'handlers': ['console', 'file'],
    },
}

logging.config.dictConfig(LOGGING_CONFIG)
logger = logging.getLogger(__name__)
```

## Performance Optimization

### Profiling
```bash
# Profile script
python -m cProfile -s cumulative script.py

# Memory profiling
pip install memory-profiler
python -m memory_profiler script.py

# Line profiling
pip install line_profiler
kernprof -l -v script.py
```

### Best Practices
- Use generators for large datasets
- Implement caching where appropriate
- Use `__slots__` for classes with fixed attributes
- Profile before optimizing
- Use appropriate data structures
- Consider using `numba` or `cython` for performance-critical code

## Type Hints

```python
from typing import List, Dict, Optional, Union, Tuple, Any
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str
    age: Optional[int] = None

def process_users(users: List[User]) -> Dict[str, Any]:
    """Process a list of users and return statistics."""
    result: Dict[str, Any] = {
        'total': len(users),
        'with_age': sum(1 for u in users if u.age is not None)
    }
    return result

def find_user(user_id: int) -> Optional[User]:
    """Find a user by ID, return None if not found."""
    # Implementation here
    pass
```

## Common Libraries

### Web Frameworks
- **Flask**: Lightweight and flexible
- **Django**: Batteries-included
- **FastAPI**: Modern, fast, with automatic API docs
- **Pyramid**: Flexible and scalable

### Data Science
- **NumPy**: Numerical computing
- **Pandas**: Data manipulation
- **Matplotlib/Seaborn**: Visualization
- **Scikit-learn**: Machine learning

### Database
- **SQLAlchemy**: SQL toolkit and ORM
- **Psycopg2**: PostgreSQL adapter
- **PyMongo**: MongoDB driver
- **Redis-py**: Redis client

### Testing
- **Pytest**: Testing framework
- **Unittest**: Built-in testing
- **Tox**: Testing across environments
- **Coverage.py**: Code coverage

### Utilities
- **Requests**: HTTP library
- **Click**: CLI creation
- **Celery**: Distributed task queue
- **Pydantic**: Data validation