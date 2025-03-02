import os
import os.path
import zipfile
from pathlib import Path

from azure.storage.blob import BlobClient

script_dir = os.path.dirname(__file__)
project_dir = os.path.join(script_dir, "../")
raw_dir_path = os.path.join(project_dir, "data/raw/") 

dataset_path = os.path.join(raw_dir_path, "air_quality.csv")
dataset_zip_path = os.path.join(raw_dir_path, "air_quality.zip")

def mb(value: int) -> str:
  return f"{round(value / (1024 * 1024), 2)}"

def main():
  if Path(dataset_path).is_file():
    return

  with open(os.path.join(project_dir, "azure-connection.json"), 'r', encoding='utf8') as file:
    conn_string = file.read()
  
  blob_client = BlobClient.from_connection_string(
      conn_string,
      container_name="datanalysis",
      blob_name="air_quality.zip"
  )

  downloader = blob_client.download_blob()

  os.makedirs(raw_dir_path, exist_ok=True)

  with open(dataset_zip_path, 'wb') as f:
    read_size = 0
    total_size = downloader.size

    for chunk in downloader.chunks():
      f.write(chunk)
    
      read_size += len(chunk)
      print(f"\r{mb(read_size)}/{mb(total_size)} MB", end="")

    print("\nUnzipping archive")
    with zipfile.ZipFile(dataset_zip_path, 'r') as zf:
      zf.extractall(raw_dir_path)

  os.remove(dataset_zip_path)

  print("Finished successfully")

if __name__ == "__main__":
  main()