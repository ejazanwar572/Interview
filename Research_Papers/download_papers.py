import urllib.request
import urllib.error
import os

# Paper Metadata
papers = [
    {
        "id": 1,
        "name": "1_Malik_S2S_Prediction_2024.pdf",
        "url": "https://doi.org/10.1016/j.cliser.2024.100457", 
        "direct_url": None 
    },
    {
        "id": 2,
        "name": "2_Nanditha_Pakistan_Flood_2023.pdf",
        "url": "https://doi.org/10.1029/2022EF003230",
        "direct_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2022EF003230"
    },
    {
        "id": 3,
        "name": "3_Malik_Mishra_Compound_Hot_Dry_2025.pdf",
        "url": "https://doi.org/10.1007/s00382-025-07668-x",
        "direct_url": "https://link.springer.com/content/pdf/10.1007/s00382-025-07668-x.pdf"
    },
    {
        "id": 4,
        "name": "4_Malik_High_Impact_2025.pdf",
        "url": "https://doi.org/10.1175/JCLI-D-24-0466.1",
        "direct_url": "https://journals.ametsoc.org/doi/pdf/10.1175/JCLI-D-24-0466.1"
    },
    {
        "id": 5,
        "name": "5_Malik_Soil_Moisture_2025.pdf",
        "url": "https://doi.org/10.1029/2025WR040174",
        "direct_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2025WR040174"
    },
    {
        "id": 6,
        "name": "6_Malik_Extreme_Rainfall_Pakistan_Predicted_2023.pdf",
        "url": "https://iopscience.iop.org/article/10.1088/2752-5295/2/4/041005",
        "direct_url": "https://iopscience.iop.org/article/10.1088/2752-5295/2/4/041005/pdf"
    },
    {
        "id": 7,
        "name": "7_Chuphal_Multiday_Precipitation_2025.pdf",
        "url": "https://doi.org/10.1029/2024EF005497",
        "direct_url": "https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/10.1029/2024EF005497"
    }
]

headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

output_dir = "/Users/ejazanwar/Desktop/Interview/Research_Papers"

def download_paper(paper):
    print(f"Attempting to download {paper['name']}...")
    target_url = paper['direct_url'] if paper['direct_url'] else paper['url']
    
    if not target_url:
        print(f"  Skipping {paper['name']} - No direct URL identified.")
        return

    try:
        req = urllib.request.Request(target_url, headers=headers)
        with urllib.request.urlopen(req, timeout=30) as response:
            content_type = response.headers.get('Content-Type', '')
            # Handle charset if present "text/html; charset=utf-8"
            
            if 'application/pdf' in content_type:
                path = os.path.join(output_dir, paper['name'])
                with open(path, 'wb') as f:
                    f.write(response.read())
                size_mb = os.path.getsize(path) / (1024 * 1024)
                print(f"  Success! Saved to {path} ({size_mb:.2f} MB)")
                
                if size_mb > 2:
                    print(f"  WARNING: File size {size_mb:.2f} MB > 2 MB")
            else:
                print(f"  Failed. Content-Type is {content_type}. URL probably redirected to landing page or blocked.")
                print(f"  Response URL: {response.geturl()}")
            
    except urllib.error.HTTPError as e:
        print(f"  HTTP Error downloading {paper['name']}: {e.code} {e.reason}")
    except Exception as e:
        print(f"  Error downloading {paper['name']}: {e}")

if __name__ == "__main__":
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for paper in papers:
        download_paper(paper)
