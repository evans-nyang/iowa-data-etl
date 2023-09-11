import json

def load_dataset_from_json(file_path):
    with open(file_path, 'r') as file:
        dataset = json.load(file)
    return dataset

def save_dataset_to_json(dataset, file_path):
    with open(file_path, 'w') as file:
        json.dump(dataset, file, indent=2)
