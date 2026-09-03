from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import characters, classes
from mangum import Mangum
from dotenv import load_dotenv
import os

app = FastAPI()

load_dotenv()

origins = [
    "http://localhost:3000",
    "https://dc8f1j2o4iezv.cloudfront.net"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

prefix = os.getenv("API_PREFIX", "")
app.include_router(characters.router, prefix=f"{prefix}/characters")
app.include_router(classes.router, prefix=f"{prefix}/classes")

handler = Mangum(app, lifespan="off")