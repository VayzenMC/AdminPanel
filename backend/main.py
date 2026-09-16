from contextlib import closing
from pathlib import Path
import sqlite3

from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, EmailStr, Field


DATABASE_PATH = Path(__file__).with_name("admin.db")


class UserCreate(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    role: str = Field(default="admin", min_length=2, max_length=50)


class UserResponse(UserCreate):
    id: int
    model_config = ConfigDict(from_attributes=True)


def get_connection() -> sqlite3.Connection:
    connection = sqlite3.connect(DATABASE_PATH)
    connection.row_factory = sqlite3.Row
    return connection


def initialize_database() -> None:
    with closing(get_connection()) as connection:
        connection.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                role TEXT NOT NULL DEFAULT 'admin'
            )
            """
        )
        connection.commit()


initialize_database()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Kerak bo'lsa barcha domenlarga ruxsat berish
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/users", response_model=list[UserResponse])
def get_users() -> list[UserResponse]:
    with closing(get_connection()) as connection:
        rows = connection.execute(
            "SELECT id, name, email, role FROM users ORDER BY id DESC"
        ).fetchall()
    return [UserResponse(**dict(row)) for row in rows]


@app.post("/users", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate) -> UserResponse:
    with closing(get_connection()) as connection:
        try:
            cursor = connection.execute(
                "INSERT INTO users (name, email, role) VALUES (?, ?, ?)",
                (user.name, str(user.email), user.role),
            )
            connection.commit()
        except sqlite3.IntegrityError:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Bu email bilan foydalanuvchi allaqachon mavjud",
            )

        row = connection.execute(
            "SELECT id, name, email, role FROM users WHERE id = ?",
            (cursor.lastrowid,),
        ).fetchone()

    return UserResponse(**dict(row))


@app.get("/users/{user_id}", response_model=UserResponse)
def get_user(user_id: int) -> UserResponse:
    with closing(get_connection()) as connection:
        row = connection.execute(
            "SELECT id, name, email, role FROM users WHERE id = ?",
            (user_id,),
        ).fetchone()

    if row is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Foydalanuvchi topilmadi",
        )
    return UserResponse(**dict(row))


@app.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(user_id: int) -> None:
    with closing(get_connection()) as connection:
        cursor = connection.execute("DELETE FROM users WHERE id = ?", (user_id,))
        connection.commit()

    if cursor.rowcount == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Foydalanuvchi topilmadi",
        )