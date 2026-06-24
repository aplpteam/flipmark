import requests, json

query = "a totalitarian way of life"  # change this anytime

response = requests.get(
    "http://127.0.0.1:8000/similar",
    params={"query": query}
)

print(json.dumps(response.json(), indent=4))
