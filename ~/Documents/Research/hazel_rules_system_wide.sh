#!/bin/bash
# System-Wide File Organization with Hazel
# Processes ALL files on your MacBook Pro for complete organization

# Configuration
LOG_FILE="$HOME/Documents/Research/hazel_system_wide.log"
BASE_DIR="$HOME/Documents/Research"

# Enhanced categories for system-wide organization
declare -A CATEGORIES=(
    # Personal & Life
    ["personal"]="Personal_Documents"
    ["family"]="Family_Documents"
    ["health"]="Health_Medical"
    ["finance"]="Financial_Documents"
    ["legal"]="Legal_Documents"
    
    # Education & Work
    ["education"]="Education"
    ["work"]="Work_Professional"
    ["research"]="Research"
    ["projects"]="Projects"
    
    # Creative & Media
    ["photos"]="Photos_Images"
    ["videos"]="Videos"
    ["audio"]="Audio_Music"
    ["design"]="Design_Creative"
    ["writing"]="Writing_Documents"
    
    # Technology & Development
    ["code"]="Code_Development"
    ["websites"]="Websites"
    ["apps"]="Applications"
    ["databases"]="Databases"
    
    # Entertainment & Hobbies
    ["books"]="Books_Ebooks"
    ["games"]="Games"
    ["hobbies"]="Hobbies_Interests"
    ["travel"]="Travel"
    
    # System & Utilities
    ["system"]="System_Files"
    ["backups"]="Backups"
    ["templates"]="Templates"
    ["archives"]="Archives"
)

# File type mappings
declare -A FILE_TYPES=(
    # Documents
    ["pdf"]="documents"
    ["doc"]="documents"
    ["docx"]="documents"
    ["rtf"]="writing"
    ["rtfd"]="writing"
    ["txt"]="writing"
    ["md"]="writing"
    ["tex"]="writing"
    ["bib"]="writing"
    
    # Images
    ["jpg"]="photos"
    ["jpeg"]="photos"
    ["png"]="photos"
    ["gif"]="photos"
    ["heic"]="photos"
    ["raw"]="photos"
    ["psd"]="design"
    ["ai"]="design"
    ["sketch"]="design"
    
    # Media
    ["mp4"]="videos"
    ["mov"]="videos"
    ["avi"]="videos"
    ["mp3"]="audio"
    ["m4a"]="audio"
    ["wav"]="audio"
    ["aac"]="audio"
    
    # Archives
    ["zip"]="archives"
    ["rar"]="archives"
    ["7z"]="archives"
    ["tar"]="archives"
    ["gz"]="archives"
    
    # Code
    ["py"]="code"
    ["js"]="code"
    ["html"]="code"
    ["css"]="code"
    ["java"]="code"
    ["cpp"]="code"
    ["swift"]="code"
    ["sql"]="databases"
    
    # E-books
    ["epub"]="books"
    ["mobi"]="books"
    ["azw3"]="books"
    ["cbz"]="books"
    ["cbr"]="books"
)

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

setup_system_directories() {
    log_message "Setting up system-wide organization directories..."
    
    for category in "${CATEGORIES[@]}"; do
        mkdir -p "$BASE_DIR/$category"
        log_message "Created directory: $category"
    done
    
    # Create subdirectories for better organization
    mkdir -p "$BASE_DIR/Personal_Documents/Important"
    mkdir -p "$BASE_DIR/Personal_Documents/Receipts"
    mkdir -p "$BASE_DIR/Family_Documents/Children"
    mkdir -p "$BASE_DIR/Health_Medical/Appointments"
    mkdir -p "$BASE_DIR/Financial_Documents/Bills"
    mkdir -p "$BASE_DIR/Financial_Documents/Taxes"
    mkdir -p "$BASE_DIR/Work_Professional/Meetings"
    mkdir -p "$BASE_DIR/Work_Professional/Reports"
    mkdir -p "$BASE_DIR/Photos_Images/Personal"
    mkdir -p "$BASE_DIR/Photos_Images/Work"
    mkdir -p "$BASE_DIR/Photos_Images/Family"
    mkdir -p "$BASE_DIR/Videos/Personal"
    mkdir -p "$BASE_DIR/Videos/Work"
    mkdir -p "$BASE_DIR/Audio_Music/Recordings"
    mkdir -p "$BASE_DIR/Audio_Music/Music"
    mkdir -p "$BASE_DIR/Code_Development/Projects"
    mkdir -p "$BASE_DIR/Code_Development/Scripts"
    mkdir -p "$BASE_DIR/Projects/Active"
    mkdir -p "$BASE_DIR/Projects/Completed"
    mkdir -p "$BASE_DIR/Archives/By_Year"
    mkdir -p "$BASE_DIR/Archives/By_Type"
    
    log_message "System directories setup complete"
}

categorize_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    local extension="${filename##*.}"
    local category=""
    
    # Determine category based on file type
    if [[ -n "${FILE_TYPES[$extension]}" ]]; then
        category="${FILE_TYPES[$extension]}"
    else
        # Fallback categorization based on filename patterns
        if [[ "$filename" =~ [0-9]{4} ]]; then
            category="archives"
        elif [[ "$filename" =~ ^[A-Z][a-z]+ ]]; then
            category="documents"
        else
            category="documents"
        fi
    fi
    
    # Get destination directory
    local dest_dir=""
    for key in "${!CATEGORIES[@]}"; do
        if [[ "$category" == "$key" ]]; then
            dest_dir="$BASE_DIR/${CATEGORIES[$key]}"
            break
        fi
    done
    
    if [[ -z "$dest_dir" ]]; then
        dest_dir="$BASE_DIR/Archives/By_Type"
    fi
    
    # Create timestamped filename
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local new_filename="${filename%.*}_${timestamp}.${extension}"
    local destination_path="$dest_dir/$new_filename"
    
    # Move file
    if mv "$file_path" "$destination_path" 2>/dev/null; then
        log_message "Moved: $filename -> $destination_path"
        
        # Process based on file type
        process_file_by_type "$destination_path" "$extension"
        
        return 0
    else
        log_message "Failed to move: $filename"
        return 1
    fi
}

process_file_by_type() {
    local file_path="$1"
    local extension="$2"
    local filename=$(basename "$file_path")
    
    case "$extension" in
        # E-books - Add to Calibre
        epub|mobi|azw3)
            if [ -f "/Applications/calibre.app/Contents/MacOS/calibredb" ]; then
                local metadata_file="${file_path%.*}.metadata.txt"
                "/Applications/calibre.app/Contents/MacOS/ebook-meta" "$file_path" > "$metadata_file" 2>/dev/null
                log_message "Extracted e-book metadata: ${metadata_file}"
                
                # Add to Calibre library
                "/Applications/calibre.app/Contents/MacOS/calibredb" add --library-path "$HOME/Calibre Library" "$file_path" >/dev/null 2>&1
                log_message "Added e-book to Calibre library: $filename"
            fi
            ;;
        
        # Documents - Open in appropriate app
        rtf|rtfd|doc|docx)
            if [ -d "/Applications/Bean.app" ]; then
                open -a "/Applications/Bean.app" "$file_path"
                log_message "Opened document in Bean: $filename"
            fi
            ;;
        
        # LaTeX files - Open in TexStudio
        tex|bib|sty|cls|bbl)
            if [ -f "/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio" ]; then
                "/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio" "$file_path" &
                log_message "Opened LaTeX file in TexStudio: $filename"
            fi
            ;;
        
        # Images - Extract metadata and organize
        jpg|jpeg|png|gif|heic|raw)
            if command -v sips >/dev/null 2>&1; then
                local metadata_file="${file_path%.*}.metadata.txt"
                sips -g all "$file_path" > "$metadata_file" 2>/dev/null
                log_message "Extracted image metadata: ${metadata_file}"
            fi
            ;;
        
        # Videos - Extract metadata
        mp4|mov|avi)
            if command -v ffprobe >/dev/null 2>&1; then
                local metadata_file="${file_path%.*}.metadata.txt"
                ffprobe -v quiet -print_format json -show_format -show_streams "$file_path" > "$metadata_file" 2>/dev/null
                log_message "Extracted video metadata: ${metadata_file}"
            fi
            ;;
        
        # Audio - Process with Whisper if it's a recording
        mp3|m4a|wav|aac)
            if [[ "$filename" =~ recording|meeting|interview|lecture ]]; then
                log_message "Audio file detected as recording: $filename - Ready for Whisper processing"
            fi
            ;;
        
        # Code files - Create project structure
        py|js|html|css|java|cpp|swift)
            local project_dir=$(dirname "$file_path")
            if [ ! -f "$project_dir/README.md" ]; then
                echo "# $(basename "$project_dir")\n\nProject files organized by Hazel automation." > "$project_dir/README.md"
                log_message "Created README for code project: $project_dir"
            fi
            ;;
        
        # Archives - Extract and organize
        zip|rar|7z|tar|gz)
            log_message "Archive file detected: $filename - Consider extracting for better organization"
            ;;
    esac
}

# Main processing function
process_all_files() {
    local source_dir="$1"
    
    if [[ ! -d "$source_dir" ]]; then
        log_message "Error: Source directory does not exist: $source_dir"
        return 1
    fi
    
    log_message "Starting system-wide file processing from: $source_dir"
    
    # Find and process all files
    find "$source_dir" -type f -not -path "*/\.*" -not -path "$BASE_DIR/*" | while read -r file_path; do
        if [[ -f "$file_path" ]]; then
            categorize_file "$file_path"
        fi
    done
    
    log_message "System-wide file processing complete"
}

# Setup and run
main() {
    log_message "=== Starting System-Wide File Organization ==="
    
    # Setup directories
    setup_system_directories
    
    # Process common directories
    local common_dirs=(
        "$HOME/Desktop"
        "$HOME/Documents"
        "$HOME/Downloads"
        "$HOME/Pictures"
        "$HOME/Music"
        "$HOME/Movies"
    )
    
    for dir in "${common_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_message "Processing directory: $dir"
            process_all_files "$dir"
        fi
    done
    
    log_message "=== System-Wide File Organization Complete ==="
    log_message "Check $LOG_FILE for detailed processing information"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
