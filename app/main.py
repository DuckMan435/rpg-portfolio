from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import characters, classes
from mangum import Mangum
from dotenv import load_dotenv
import os

app = FastAPI(redirect_slashes=False)

load_dotenv()

class StripTrailingSlashMiddleware:
    # Routes are defined without a trailing slash; normalize "/x/" to "/x" in place
    # instead of redirecting, since redirects break behind API Gateway / the ALB
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope["type"] == "http" and scope["path"] != "/" and scope["path"].endswith("/"):
            scope = dict(scope, path=scope["path"].rstrip("/") or "/")
            if scope.get("raw_path"):
                scope["raw_path"] = scope["raw_path"].rstrip(b"/") or b"/"
        await self.app(scope, receive, send)

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
app.add_middleware(StripTrailingSlashMiddleware)

prefix = os.getenv("API_PREFIX", "")
app.include_router(characters.router, prefix=f"{prefix}/characters")
app.include_router(classes.router, prefix=f"{prefix}/classes")

handler = Mangum(app, lifespan="off")