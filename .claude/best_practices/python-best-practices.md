# Python Backend Best Practices (FastAPI Stack)

This guide outlines best practices for Python development, specifically tailored for the Jezweb recommended backend stack: **FastAPI, SQLModel, and LanceDB**.

## 1. Project Setup

### Virtual Environment
Always work inside a virtual environment to manage project-specific dependencies.

```bash
# Create a virtual environment in a 'venv' directory
python3 -m venv venv

# Activate the virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# To deactivate when done
deactivate
```

### Dependency Management with `pip-tools`
Use `pip-tools` to manage dependencies via `requirements.in` files for reproducible builds.

```bash
# Install pip-tools
pip install pip-tools

# Create requirements.in for production dependencies
# Example content:
# fastapi
# uvicorn[standard]
# sqlmodel
# lancedb
# python-dotenv

# Create requirements-dev.in for development dependencies
# Example content:
# -r requirements.in
# pytest
# pytest-cov
# black
# ruff

# Compile requirements.in to requirements.txt
pip-compile requirements.in

# Compile requirements-dev.in to requirements-dev.txt
pip-compile requirements-dev.in

# Install all dependencies
pip install -r requirements-dev.txt
```

## 2. Project Structure for FastAPI

A well-organized structure is crucial for scalability.

```
project-root/
├── app/
│   ├── __init__.py
│   ├── main.py             # FastAPI app instance and startup events
│   ├── api/                # API endpoint definitions (routers)
│   │   ├── __init__.py
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── endpoints/
│   │       │   ├── __init__.py
│   │       │   └── items.py
│   │       └── router.py   # Main router for v1
│   ├── core/               # Core logic, config, and settings
│   │   ├── __init__.py
│   │   └── config.py
│   ├── crud/               # Reusable CRUD operations
│   │   ├── __init__.py
│   │   └── crud_item.py
│   ├── db/                 # Database session management
│   │   ├── __init__.py
│   │   └── session.py
│   ├── models/             # SQLModel and Pydantic models
│   │   ├── __init__.py
│   │   └── item.py
│   └── services/           # Business logic services
│       ├── __init__.py
│       └── search_service.py
├── tests/                  # Pytest tests
│   ├── __init__.py
│   └── test_items.py
├── .env                    # Environment variables (DO NOT COMMIT)
├── .gitignore
├── pyproject.toml          # Project metadata and tool configuration
├── requirements.in
└── requirements-dev.in
```

## 3. FastAPI Best Practices

FastAPI is the core of our backend, serving as the API layer.

### Main Application (`app/main.py`)
Keep the main file clean. Its primary role is to create the FastAPI instance and include routers.

```python
from fastapi import FastAPI
from app.api.v1.router import api_router
from app.db.session import create_db_and_tables

app = FastAPI(title="Jezweb AI App")

@app.on_event("startup")
def on_startup():
    create_db_and_tables()

app.include_router(api_router, prefix="/api/v1")

@app.get("/health")
def health_check():
    return {"status": "ok"}
```

### Routing (`app/api/v1/`)
Use `APIRouter` to structure your endpoints. This keeps your API modular.

```python
# app/api/v1/endpoints/items.py
from fastapi import APIRouter, Depends
from sqlmodel import Session
from app.db.session import get_session
from app.models.item import Item, ItemCreate
from app.crud import crud_item

router = APIRouter()

@router.post("/", response_model=Item)
def create_item(*, session: Session = Depends(get_session), item_in: ItemCreate):
    item = crud_item.create(db=session, obj_in=item_in)
    return item
```

### Dependency Injection
Use `Depends` for managing dependencies like database sessions. This makes testing and swapping components easy.

```python
# app/db/session.py
from sqlmodel import create_engine, Session, SQLModel

DATABASE_URL = "sqlite:///database.db"
engine = create_engine(DATABASE_URL, echo=True)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
```

### Pydantic Models for Validation
Define separate Pydantic models for creation, updates, and reading data. This provides strong validation and clear API contracts.

```python
# app/models/item.py
from typing import Optional
from sqlmodel import Field, SQLModel

class ItemBase(SQLModel):
    name: str
    description: Optional[str] = None

class Item(ItemBase, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)

class ItemCreate(ItemBase):
    pass # All fields from ItemBase are required

class ItemUpdate(SQLModel):
    name: Optional[str] = None
    description: Optional[str] = None
```

## 4. SQLModel for Structured Data

SQLModel combines SQLAlchemy and Pydantic, reducing code duplication.

### Defining Models
A single class defines both the database table and the API data shape.

```python
# app/models/item.py
from typing import Optional
from sqlmodel import Field, SQLModel

class Item(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    description: Optional[str] = None
```

### Reusable CRUD Logic
Create a generic CRUD utility to handle common database operations.

```python
# app/crud/base.py
from typing import Any, Generic, Type, TypeVar
from sqlmodel import SQLModel, Session

ModelType = TypeVar("ModelType", bound=SQLModel)
CreateSchemaType = TypeVar("CreateSchemaType", bound=SQLModel)

class CRUDBase(Generic[ModelType, CreateSchemaType]):
    def __init__(self, model: Type[ModelType]):
        self.model = model

    def create(self, db: Session, *, obj_in: CreateSchemaType) -> ModelType:
        db_obj = self.model.from_orm(obj_in)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

# app/crud/crud_item.py
from app.crud.base import CRUDBase
from app.models.item import Item, ItemCreate

item = CRUDBase[Item, ItemCreate](Item)
```

## 5. LanceDB for Vector Data

LanceDB is our serverless vector store for AI-powered features.

### Setup and Integration
Integrate LanceDB within a dedicated service.

```python
# app/services/search_service.py
import lancedb
from sentence_transformers import SentenceTransformer # Example embedding model

class SearchService:
    def __init__(self, uri: str = "data/lancedb"):
        self.db = lancedb.connect(uri)
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.table = self._init_table()

    def _init_table(self):
        try:
            table = self.db.open_table("items")
        except FileNotFoundError:
            # Schema: vector and the ID of the structured data item
            schema = {
                "vector": self.model.encode("").tolist(),
                "item_id": 0,
                "text": ""
            }
            table = self.db.create_table("items", schema=schema)
        return table

    def add_item(self, item_id: int, text: str):
        vector = self.model.encode(text).tolist()
        self.table.add([{"vector": vector, "item_id": item_id, "text": text}])

    def search(self, query: str, limit: int = 5) -> list[int]:
        query_vector = self.model.encode(query).tolist()
        results = self.table.search(query_vector).limit(limit).to_df()
        return results['item_id'].tolist()

# Singleton instance
search_service = SearchService()
```

### Using the Service in an Endpoint
Inject the service into your API endpoints to add or search for items.

```python
# app/api/v1/endpoints/items.py
# ... (other imports)
from app.services.search_service import search_service

@router.post("/{item_id}/embed")
def embed_item(item_id: int, session: Session = Depends(get_session)):
    item = session.get(Item, item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    # Use both name and description for embedding
    text_to_embed = f"{item.name}: {item.description}"
    search_service.add_item(item_id=item.id, text=text_to_embed)
    return {"message": "Item embedded successfully"}

@router.get("/search/")
def search_items(q: str):
    item_ids = search_service.search(query=q)
    return {"item_ids": item_ids}
```

## 6. Code Quality and Tooling

### Formatting and Linting
Use `black` for uncompromising code formatting and `ruff` for high-performance linting. Configure them in `pyproject.toml`.

```toml
# pyproject.toml
[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
select = ["E", "F", "W", "I"] # Standard flake8 checks + isort
```

### Common Commands
```bash
# Format code
black app/ tests/

# Lint and auto-fix code
ruff --fix app/ tests/

# Run tests with coverage
pytest --cov=app
```

## 7. Type Hints
Use Python's type hints extensively. FastAPI leverages them for validation and documentation. `mypy` can be used for static type checking.

```python
from typing import List, Optional
from sqlmodel import Session

def get_items(db: Session, skip: int = 0, limit: int = 100) -> List[Item]:
    # Function implementation
    pass
```