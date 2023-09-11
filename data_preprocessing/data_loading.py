import os
import logging
from data_wrangling import preprocess_data, save_data_to_json, save_data_to_parquet
from data_extraction import fetch_data
from config_loader import load_config 

# Configure logging
logging.basicConfig(filename='data_processing.log', level=logging.INFO)

def main():
    """
    Main function for preprocessing and storing data.

    This function fetches data from a data source, saves the raw data to a JSON file,
    preprocesses the data, and saves the cleaned data to another JSON file.

    File paths for raw and cleaned data files are defined using configurations loaded
    from a 'config.yml' file using the 'config_loader' module.

    Error handling and logging are implemented to capture and report any exceptions
    that may occur during the data processing steps.

    """
    try:
        # Load configuration from 'config.yml' file
        config = load_config('../config/config.yml')

        # Get the file paths from the loaded configuration
        raw_filepath = os.path.join(config['file_paths']['raw'], 'raw_iowa_data.parquet')
        clean_filepath = os.path.join(config['file_paths']['processed'], 'clean_iowa_data.json')

        # Fetch data from the data source
        data = fetch_data()

        if data:
            # Save raw data to parquet file
            save_data_to_parquet(data, raw_filepath)

            # Preprocess data
            cleaned_data = preprocess_data(data)

            # Save cleaned data to JSON file
            save_data_to_json(cleaned_data, clean_filepath)
        else:
            logging.warning("No data retrieved from the data source.")
    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    main()
