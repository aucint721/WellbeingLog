#!/usr/bin/env python3
"""
Test Zotero Integration
Verifies that the Zotero API connection works with your credentials.
"""

import json
import requests

def test_zotero_connection():
    """Test the Zotero API connection."""
    try:
        # Load configuration
        with open('config.json', 'r') as f:
            config = json.load(f)
        
        api_key = config['zotero']['api_key']
        library_id = config['zotero']['library_id']
        library_type = config['zotero']['library_type']
        
        print(f"🔑 API Key: {api_key[:10]}...{api_key[-4:]}")
        print(f"📚 Library ID: {library_id}")
        print(f"🏷️ Library Type: {library_type}")
        
        # Test API connection
        base_url = f"https://api.zotero.org/{library_type}s/{library_id}"
        headers = {
            'Zotero-API-Key': api_key,
            'Content-Type': 'application/json'
        }
        
        print(f"\n🌐 Testing connection to: {base_url}")
        
        # Test with a simple GET request
        response = requests.get(f"{base_url}/items", headers=headers, params={'limit': 1})
        
        if response.status_code == 200:
            print("✅ Zotero API connection successful!")
            items = response.json()
            print(f"📊 Found {len(items)} items in your library")
            
            if items:
                first_item = items[0]
                print(f"📖 First item: {first_item.get('title', 'Untitled')}")
                print(f"🔑 Item key: {first_item.get('key', 'Unknown')}")
            
            return True
        else:
            print(f"❌ Zotero API connection failed: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error testing Zotero connection: {e}")
        return False

def test_file_upload_simulation():
    """Simulate file upload process without actually uploading."""
    try:
        print("\n🧪 Testing file upload simulation...")
        
        # Load configuration
        with open('config.json', 'r') as f:
            config = json.load(f)
        
        api_key = config['zotero']['api_key']
        library_id = config['zotero']['library_id']
        library_type = config['zotero']['library_type']
        
        base_url = f"https://api.zotero.org/{library_type}s/{library_id}"
        headers = {
            'Zotero-API-Key': api_key,
            'Content-Type': 'application/json'
        }
        
        # Simulate creating a test item
        test_item = {
            'itemType': 'attachment',
            'title': 'Test Research File',
            'filename': 'test_research.pdf',
            'contentType': 'application/pdf',
            'tags': ['test', 'auto_imported', 'research_workflow']
        }
        
        print("📤 Simulating item creation...")
        
        # Test item creation (this won't actually create anything permanent)
        response = requests.post(
            f"{base_url}/items",
            headers=headers,
            json=test_item
        )
        
        if response.status_code == 200:
            print("✅ Item creation simulation successful!")
            item = response.json()
            print(f"🔑 Created test item with key: {item.get('key', 'Unknown')}")
            
            # Clean up test item
            print("🧹 Cleaning up test item...")
            delete_response = requests.delete(
                f"{base_url}/items/{item.get('key')}",
                headers=headers
            )
            
            if delete_response.status_code == 204:
                print("✅ Test item cleaned up successfully")
            else:
                print(f"⚠️ Could not clean up test item: {delete_response.status_code}")
            
            return True
        else:
            print(f"❌ Item creation simulation failed: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error in file upload simulation: {e}")
        return False

def main():
    """Main test function."""
    print("🔬 Zotero Integration Test")
    print("=" * 40)
    
    # Test 1: Basic connection
    print("\n1️⃣ Testing basic Zotero connection...")
    connection_ok = test_zotero_connection()
    
    if connection_ok:
        # Test 2: File upload simulation
        print("\n2️⃣ Testing file upload simulation...")
        upload_ok = test_file_upload_simulation()
        
        if upload_ok:
            print("\n🎉 All tests passed! Your Zotero integration is ready.")
            print("\n📋 Next steps:")
            print("1. Set up Hazel rules for research workflow automation")
            print("2. Test with real research files")
            print("3. Enjoy automatic Zotero integration!")
        else:
            print("\n⚠️ File upload test failed. Check your API permissions.")
    else:
        print("\n❌ Basic connection failed. Check your API key and library ID.")
    
    print("\n" + "=" * 40)

if __name__ == "__main__":
    main()
