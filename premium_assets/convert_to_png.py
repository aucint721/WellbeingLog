#!/usr/bin/env python3
"""
Convert Premium Badge HTML to PNG for App Store Connect
This script converts the HTML premium badge designs to high-quality PNG images.
"""

import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time


def setup_chrome_driver():
    """Setup Chrome driver with headless options for image capture."""
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--window-size=1024,1024")
    chrome_options.add_argument("--disable-gpu")
    
    try:
        driver = webdriver.Chrome(options=chrome_options)
        return driver
    except Exception as e:
        print(f"Chrome driver setup failed: {e}")
        print("Please install Chrome and ChromeDriver")
        return None


def html_to_png(html_file, output_png, size=1024):
    """Convert HTML file to PNG image."""
    driver = setup_chrome_driver()
    if not driver:
        return False
    
    try:
        # Get absolute path to HTML file
        html_path = os.path.abspath(html_file)
        file_url = f"file://{html_path}"
        
        print(f"Converting {html_file} to {output_png}...")
        print(f"HTML file path: {html_path}")
        
        # Load the HTML file
        driver.get(file_url)
        
        # Wait for page to load
        time.sleep(2)
        
        # Set window size
        driver.set_window_size(size, size)
        
        # Wait for any animations to complete
        time.sleep(3)
        
        # Take screenshot
        driver.save_screenshot(output_png)
        
        print(f"✅ Successfully created {output_png}")
        return True
        
    except Exception as e:
        print(f"❌ Error converting {html_file}: {e}")
        return False
    
    finally:
        driver.quit()


def main():
    """Main conversion function."""
    print("🎨 Premium Badge HTML to PNG Converter")
    print("=" * 50)
    
    # Check if HTML files exist
    html_files = [
        "premium_badge.html",
        "premium_badge_simple.html"
    ]
    
    missing_files = []
    for html_file in html_files:
        if not os.path.exists(html_file):
            missing_files.append(html_file)
    
    if missing_files:
        print(f"❌ Missing HTML files: {', '.join(missing_files)}")
        print("Please ensure the HTML files are in the same directory.")
        return
    
    # Convert each HTML file to PNG
    success_count = 0
    
    for html_file in html_files:
        output_png = html_file.replace('.html', '.png')
        
        if html_to_png(html_file, output_png, size=1024):
            success_count += 1
    
    print("\n" + "=" * 50)
    if success_count == len(html_files):
        print(f"🎉 All {success_count} premium badges converted successfully!")
        print("\n📱 PNG files ready for App Store Connect:")
        for html_file in html_files:
            png_file = html_file.replace('.html', '.png')
            print(f"   • {png_file}")
    else:
        print(f"⚠️  {success_count}/{len(html_files)} badges converted successfully")
    
    print("\n💡 Tips for App Store Connect:")
    print("   • Upload PNG files to In-App Purchase product images")
    print("   • Recommended size: 1024x1024 pixels")
    print("   • Format: PNG with transparency support")
    print("   • File size: Under 2MB per image")


if __name__ == "__main__":
    main()
