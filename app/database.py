from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

load_dotenv()

# Database connection string
DATABASE_URL = os.getenv("DATABASE_URL")

# Create SQLAlchemy engine instance
engine = create_engine(DATABASE_URL)

Session = sessionmaker(engine, autocommit=False, autoflush=False)

# Create a method to get a database session
def get_db():
    db = Session()
    try:
        yield db
    finally:
        db.close()