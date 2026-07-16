from fastapi import FastAPI
import uvicorn
from strawberry.asgi import GraphQL
import strawberry

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to FastAPI GraphQL server. Go to /graphql for GraphQL endpoint"}

@strawberry.input
class User:
    name: str
    age: int

@strawberry.type
class Query:
    @strawberry.field
    def hello(self, User: User) -> str:
        return f"Hello, {User.name}, you are {User.age} years old!"

schema = strawberry.Schema(query=Query)


app.add_route("/graphql", GraphQL(schema))
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)