import os
import yaml

def load_config(file_path):
    with open(file_path, 'r') as file:
        config = yaml.safe_load(file)

    for key, value in config.items():
        if isinstance(value, dict):
            for subkey, subvalue in value.items():
                if isinstance(subvalue, str) and subvalue.startswith('${') and subvalue.endswith('}'):
                    env_var = subvalue[2:-1]
                    value[subkey] = os.getenv(env_var)

    return config
