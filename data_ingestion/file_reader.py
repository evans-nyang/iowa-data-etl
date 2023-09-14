import yaml
import json

def load_configuration(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)
    
def load_data(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

def load_secret(file_path):
    with open(file_path, 'r') as f:
        return yaml.safe_load(f)
