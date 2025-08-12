#!/bin/bash
# Hazel Rules for Research File Management
# This script works with Hazel to automatically organize research files

# Configuration
RESEARCH_BASE_DIR="$HOME/Documents/Research"
LOG_FILE="$HOME/Library/Logs/hazel_research.log"

# Log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Create research directories if they don't exist
setup_directories() {
    mkdir -p "$RESEARCH_BASE_DIR"/{papers,books,reports,presentations,data,screenshots,videos,audio,transcripts,web,unsorted}
    log_message "Ensured research directories exist"
}

# Categorize file by extension
categorize_file() {
    local file_path="$1"
    local extension="${file_path##*.}"
    
    case "$extension" in
        pdf|docx|doc)
            echo "papers"
            ;;
        epub|mobi|azw3)
            echo "books"
            ;;
        pptx|ppt)
            echo "presentations"
            ;;
        csv|xlsx|json|sqlite)
            echo "data"
            ;;
        rtf|rtfd|doc|docx)
            echo "writing"
            ;;
        tex|bib|sty|cls|bbl)
            echo "latex"
            ;;
        png|jpg|jpeg|gif|bmp)
            echo "screenshots"
            ;;
        mp4|mov|avi|mkv|wmv)
            echo "videos"
            ;;
        mp3|wav|aac|m4a|flac)
            echo "audio"
            ;;
        txt|srt|vtt)
            echo "transcripts"
            ;;
        html|htm)
            echo "web"
            ;;
        *)
            echo "unsorted"
            ;;
    esac
}

# Extract PDF metadata using pdfinfo
extract_pdf_metadata() {
    local file_path="$1"
    local metadata_file="${file_path%.*}.metadata.txt"
    
    if command -v pdfinfo >/dev/null 2>&1; then
        pdfinfo "$file_path" > "$metadata_file" 2>/dev/null
        log_message "Extracted PDF metadata: $metadata_file"
    fi
}

# Extract DOCX metadata using textutil
extract_docx_metadata() {
    local file_path="$1"
    local metadata_file="${file_path%.*}.metadata.txt"
    
    if command -v textutil >/dev/null 2>&1; then
        textutil -convert txt "$file_path" -output "$metadata_file" 2>/dev/null
        log_message "Extracted DOCX metadata: $metadata_file"
    fi
}

# Generate standardized filename
generate_filename() {
    local file_path="$1"
    local base_name=$(basename "$file_path")
    local extension="${base_name##*.}"
    local name_without_ext="${base_name%.*}"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    
    # Try to extract author and year from filename
    if [[ "$name_without_ext" =~ ([A-Za-z]+)_([0-9]{4}) ]]; then
        echo "${BASH_REMATCH[1]}_${BASH_REMATCH[2]}_${timestamp}.$extension"
    else
        echo "${name_without_ext}_${timestamp}.$extension"
    fi
}

# Main file processing function
process_file() {
    local source_path="$1"
    local filename=$(basename "$source_path")
    
    log_message "Processing file: $filename"
    
    # Determine category
    local category=$(categorize_file "$source_path")
    local category_dir="$RESEARCH_BASE_DIR/$category"
    
    # Generate new filename
    local new_filename=$(generate_filename "$source_path")
    local destination_path="$category_dir/$new_filename"
    
    # Handle filename conflicts
    local counter=1
    local original_destination="$destination_path"
    while [[ -f "$destination_path" ]]; do
        local stem="${original_destination%.*}"
        local ext="${original_destination##*.}"
        destination_path="${stem}_${counter}.${ext}"
        ((counter++))
    done
    
    # Move file to appropriate category
    if mv "$source_path" "$destination_path"; then
        log_message "Moved $filename to $category/$new_filename"
        
        # Extract metadata based on file type
        case "${filename##*.}" in
            pdf)
                extract_pdf_metadata "$destination_path"
                ;;
            docx|doc)
                extract_docx_metadata "$destination_path"
                ;;
            epub|mobi|azw3)
                # Extract e-book metadata using Calibre's ebook-meta tool
                if [ -f "/Applications/calibre.app/Contents/MacOS/ebook-meta" ]; then
                    local metadata_file="${destination_path%.*}.metadata.txt"
                    "/Applications/calibre.app/Contents/MacOS/ebook-meta" "$destination_path" > "$metadata_file" 2>/dev/null
                    log_message "Extracted e-book metadata: $metadata_file"
                    
                    # Add to Calibre library if configured
                    if [ -f "/Applications/calibre.app/Contents/MacOS/calibredb" ]; then
                        "/Applications/calibre.app/Contents/MacOS/calibredb" add --library-path "$HOME/Calibre Library" "$destination_path" >/dev/null 2>&1
                        log_message "Added e-book to Calibre library"
                    fi
                fi
                ;;
            rtf|rtfd|doc|docx)
                # Extract document metadata and open in Bean if it's a writing document
                if [[ "$filename" == *"research"* ]] || [[ "$filename" == *"paper"* ]] || [[ "$filename" == *"thesis"* ]]; then
                    # This looks like a research document, open in Bean
                    if [ -d "/Applications/Bean.app" ]; then
                        open -a "/Applications/Bean.app" "$destination_path"
                        log_message "Opened research document in Bean: $filename"
                    fi
                fi
                ;;
            tex|bib|sty|cls|bbl)
                # Extract LaTeX metadata and open in TexStudio
                if [[ "$filename" == *.tex ]]; then
                    # This is a LaTeX document, open in TexStudio
                    if [ -f "/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio" ]; then
                        "/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio" "$destination_path" &
                        log_message "Opened LaTeX document in TexStudio: $filename"
                    fi
                fi
                ;;
            png|jpg|jpeg|gif|bmp)
                # Extract image metadata using sips (macOS built-in)
                if command -v sips >/dev/null 2>&1; then
                    local metadata_file="${destination_path%.*}.metadata.txt"
                    sips -g all "$destination_path" > "$metadata_file" 2>/dev/null
                    log_message "Extracted image metadata: $metadata_file"
                fi
                ;;
            mp4|mov|avi|mkv|wmv)
                # Extract video metadata using ffprobe if available
                if command -v ffprobe >/dev/null 2>&1; then
                    local metadata_file="${destination_path%.*}.metadata.txt"
                    ffprobe -v quiet -print_format json -show_format -show_streams "$destination_path" > "$metadata_file" 2>/dev/null
                    log_message "Extracted video metadata: $metadata_file"
                fi
                ;;
        esac
        
        # Create symlink in original location for easy access
        ln -sf "$destination_path" "$source_path"
        log_message "Created symlink: $source_path -> $destination_path"
        
        return 0
    else
        log_message "ERROR: Failed to move $filename"
        return 1
    fi
}

# Clean up old symlinks
cleanup_symlinks() {
    local source_dir="$1"
    find "$source_dir" -type l -exec sh -c '
        for link; do
            if [[ ! -e "$(readlink "$link")" ]]; then
                rm "$link"
                echo "Removed broken symlink: $link" >> "'"$LOG_FILE"'"
            fi
        done
    ' sh {} +
}

# Main execution
main() {
    local file_path="$1"
    
    if [[ -z "$file_path" ]]; then
        echo "Usage: $0 <file_path>"
        exit 1
    fi
    
    if [[ ! -f "$file_path" ]]; then
        log_message "ERROR: File not found: $file_path"
        exit 1
    fi
    
    # Setup directories
    setup_directories
    
    # Process the file
    if process_file "$file_path"; then
        log_message "Successfully processed: $file_path"
        exit 0
    else
        log_message "Failed to process: $file_path"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
