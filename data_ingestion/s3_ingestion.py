import boto3
from botocore.exceptions import NoCredentialsError
from file_reader import load_configuration

config = load_configuration('../config/config.yml')

def upload_to_s3(file_name, bucket, s3_file):
    s3 = boto3.client('s3')

    try:
        s3.upload_file(file_name, bucket, s3_file)
        print("Upload Successful")
        return True
    except FileNotFoundError:
        print("The file was not found")
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False

input_file = config['file_paths']['raw'] + '/raw_iowa_data.parquet'
s3bucket = config['s3']['bucket']
s3file = config['s3']['file']
uploaded = upload_to_s3(input_file, s3bucket, s3file)
