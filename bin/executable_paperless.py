#!/usr/bin/env python3

import sys
import os
import requests

# Configuration
PAPERLESS_URL = "http://100.96.211.47:8777"  # Replace with your server URL
API_TOKEN = "ee5e26c8384fa79734cf8d26bc44874da64c74f0"  # Generate this in Paperless NGX web interface
HEADERS = {"Authorization": f"Token {API_TOKEN}"}

def upload_to_paperless(file_path):
    filename = os.path.basename(file_path)
    
    with open(file_path, 'rb') as document:
        files = {'document': (filename, document, 'application/pdf')}
        
        # Optional: Add metadata
        data = {
            'title': os.path.splitext(filename)[0],  # Use filename without extension as title
            # 'correspondent': 1,  # ID of correspondent in Paperless
            # 'document_type': 2,  # ID of document type in Paperless
            # 'tags': [3, 4]  # IDs of tags to apply
        }
        
        response = requests.post(
            f"{PAPERLESS_URL}/api/documents/post_document/",
            headers=HEADERS,
            files=files,
            data=data
        )
        
        if response.status_code == 200:
            print(f"Successfully uploaded {filename} to Paperless NGX")
            return True
        else:
            print(f"Failed to upload {filename}. Status code: {response.status_code}")
            print(response.text)
            return False

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python upload_to_paperless.py /path/to/document.pdf")
        sys.exit(1)
        
    file_path = sys.argv[1]
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        sys.exit(1)
        
    success = upload_to_paperless(file_path)
    sys.exit(0 if success else 1)