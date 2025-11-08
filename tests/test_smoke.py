import requests

def test_root():
    resp = requests.get("http://localhost:5000/")
    assert resp.status_code == 200
    assert "Hello from CI/CD demo" in resp.text

if __name__ == "__main__":
    # quick manual run
    test_root()
    print("smoke ok")
