import requests
from config_loader import load_config

config = load_config('../config/config.yml')

def fetch_data():
    base_url = config['api']['url']
    query = config['api']['query']
    url = f"{base_url}{query}"

    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        return data
    except requests.exceptions.RequestException as e:
        print("An error occurred:", e)
        return []
