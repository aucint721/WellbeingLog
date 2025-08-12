#!/bin/bash
# Hazel Intake Automation Script
# Monitors File_Intake folder and intelligently routes files

# Configuration
INTAKE_DIR="$HOME/Documents/Research/File_Intake"
RESEARCH_DIR="$HOME/Documents/Research"
ORGANIZED_DIR="$RESEARCH_DIR/Organized_Research"
ARCHIVES_DIR="$RESEARCH_DIR/Archives/By_Type"
LOGS_DIR="$RESEARCH_DIR/Logs"

# Create necessary directories
mkdir -p "$LOGS_DIR"
mkdir -p "$ORGANIZED_DIR"
mkdir -p "$ARCHIVES_DIR"

# Log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGS_DIR/hazel_intake.log"
    echo "$1"
}

# Main processing function
process_intake_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    local extension="${filename##*.}"
    local base_name="${filename%.*}"
    
    log_message "🔍 Processing: $filename"
    
    # Determine file type and route accordingly
    case "${extension,,}" in
        # Research Documents
        pdf|doc|docx|rtf|txt|md)
            process_research_document "$file_path"
            ;;
        
        # LaTeX Files
        tex|bib|sty|cls)
            process_latex_file "$file_path"
            ;;
        
        # Images
        jpg|jpeg|png|gif|bmp|tiff|svg|heic)
            process_image_file "$file_path"
            ;;
        
        # Audio/Video
        mp3|wav|m4a|aac|mp4|mov|avi|mkv)
            process_media_file "$file_path"
            ;;
        
        # E-books
        epub|mobi|azw3|pdf)
            process_ebook_file "$file_path"
            ;;
        
        # Code/Development
        py|js|html|css|java|cpp|c|swift|sh|sql)
            process_code_file "$file_path"
            ;;
        
        # Archives
        zip|rar|7z|tar|gz)
            process_archive_file "$file_path"
            ;;
        
        # Spreadsheets
        xlsx|xls|csv)
            process_spreadsheet_file "$file_path"
            ;;
        
        # Presentations
        pptx|ppt|key)
            process_presentation_file "$file_path"
            ;;
        
        *)
            process_unknown_file "$file_path"
            ;;
    esac
}

# Process research documents with intelligent course detection
process_research_document() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📚 Processing research document: $filename"
    
    # Use intelligent workflow to determine course and organize
    if command -v python3 &> /dev/null; then
        cd "$RESEARCH_DIR"
        python3 intelligent_workflow.py --process "$file_path"
        
        if [ $? -eq 0 ]; then
            log_message "✅ Research document processed successfully"
            return 0
        fi
    fi
    
    # Fallback: organize by type
    local target_dir="$ARCHIVES_DIR/Documents"
    mkdir -p "$target_dir"
    
    # Generate organized filename
    local organized_name=$(generate_organized_name "$filename" "research")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 Moved to: $target_path"
}

# Process LaTeX files
process_latex_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📝 Processing LaTeX file: $filename"
    
    # Create LaTeX project structure
    local project_name=$(extract_project_name "$filename")
    local project_dir="$RESEARCH_DIR/Projects/$project_name"
    
    mkdir -p "$project_dir"/{Research,Writing,Drafts,Final,Bibliography}
    
    # Move file to appropriate subfolder
    if [[ "$filename" == *.tex ]]; then
        mv "$file_path" "$project_dir/Writing/"
    elif [[ "$filename" == *.bib ]]; then
        mv "$file_path" "$project_dir/Bibliography/"
    else
        mv "$file_path" "$project_dir/Research/"
    fi
    
    log_message "📁 LaTeX project created: $project_dir"
}

# Process image files
process_image_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "🖼️ Processing image: $filename"
    
    # Extract metadata and organize by date
    local date_folder=$(date +%Y/%m)
    local target_dir="$ARCHIVES_DIR/Images/$date_folder"
    mkdir -p "$target_dir"
    
    # Generate organized filename
    local organized_name=$(generate_organized_name "$filename" "image")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 Image organized: $target_path"
}

# Process media files
process_media_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "🎵 Processing media: $filename"
    
    # Check if it's an audio file for transcription
    if [[ "$filename" =~ \.(mp3|wav|m4a|aac)$ ]]; then
        # Route to transcription folder
        local transcribe_dir="$RESEARCH_DIR/Projects/Audio_Transcription/$(date +%Y%m%d)"
        mkdir -p "$transcribe_dir"
        mv "$file_path" "$transcribe_dir/"
        log_message "🎤 Audio routed for transcription: $transcribe_dir"
    else
        # Route to media archives
        local date_folder=$(date +%Y/%m)
        local target_dir="$ARCHIVES_DIR/Media/$date_folder"
        mkdir -p "$target_dir"
        
        local organized_name=$(generate_organized_name "$filename" "media")
        local target_path="$target_dir/$organized_name"
        
        mv "$file_path" "$target_path"
        log_message "📁 Media organized: $target_path"
    fi
}

# Process e-book files
process_ebook_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📖 Processing e-book: $filename"
    
    # Try to add to Calibre if available
    if command -v calibredb &> /dev/null; then
        local calibre_library="$HOME/Calibre Library"
        if [ -d "$calibre_library" ]; then
            cd "$calibre_library"
            calibredb add "$file_path" --library-path "$calibre_library"
            log_message "📚 Added to Calibre library"
        fi
    fi
    
    # Also organize in research archives
    local target_dir="$ARCHIVES_DIR/E-books"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "ebook")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 E-book organized: $target_path"
}

# Process code files
process_code_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "💻 Processing code: $filename"
    
    # Create development project structure
    local project_name=$(extract_project_name "$filename")
    local project_dir="$RESEARCH_DIR/Projects/Development/$project_name"
    
    mkdir -p "$project_dir"/{src,tests,docs,resources}
    
    # Move file to src folder
    mv "$file_path" "$project_dir/src/"
    
    log_message "📁 Code project created: $project_dir"
}

# Process archive files
process_archive_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📦 Processing archive: $filename"
    
    # Extract and organize contents
    local extract_dir="$ARCHIVES_DIR/Extracted/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$extract_dir"
    
    cd "$extract_dir"
    
    # Extract based on file type
    case "${filename##*.}" in
        zip) unzip "$file_path" ;;
        rar) unrar x "$file_path" ;;
        7z) 7z x "$file_path" ;;
        tar) tar -xf "$file_path" ;;
        gz) tar -xzf "$file_path" ;;
    esac
    
    # Move original archive to archives
    local archive_dir="$ARCHIVES_DIR/Archives"
    mkdir -p "$archive_dir"
    mv "$file_path" "$archive_dir/"
    
    log_message "📁 Archive extracted to: $extract_dir"
}

# Process spreadsheet files
process_spreadsheet_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📊 Processing spreadsheet: $filename"
    
    local target_dir="$ARCHIVES_DIR/Spreadsheets"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "spreadsheet")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 Spreadsheet organized: $target_path"
}

# Process presentation files
process_presentation_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "📽️ Processing presentation: $filename"
    
    local target_dir="$ARCHIVES_DIR/Presentations"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "presentation")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 Presentation organized: $target_path"
}

# Process unknown files
process_unknown_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    log_message "❓ Processing unknown file: $filename"
    
    local target_dir="$ARCHIVES_DIR/Unknown_Files"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "unknown")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "📁 Unknown file archived: $target_path"
}

# Helper functions
generate_organized_name() {
    local filename="$1"
    local type="$2"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Remove common prefixes/suffixes
    local clean_name=$(echo "$filename" | sed 's/^download_*//i' | sed 's/_*download$//i')
    clean_name=$(echo "$clean_name" | sed 's/^file_*//i' | sed 's/_*file$//i')
    
    # Clean up underscores and dashes
    clean_name=$(echo "$clean_name" | sed 's/[_-]\+/_/g' | sed 's/^_\|_$//g')
    
    # Add type prefix if filename is generic
    if [[ "$clean_name" =~ ^(untitled|document|file|download)$ ]]; then
        clean_name="${type}_${timestamp}"
    fi
    
    echo "$clean_name"
}

extract_project_name() {
    local filename="$1"
    local base_name=$(basename "$filename" | cut -d. -f1)
    
    # Remove common prefixes
    base_name=$(echo "$base_name" | sed 's/^thesis_*//i' | sed 's/^paper_*//i' | sed 's/^research_*//i')
    
    # Convert to title case
    echo "$base_name" | sed 's/\b\w/\U&/g' | sed 's/_/ /g'
}

# Main execution
main() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        log_message "❌ No file path provided"
        exit 1
    fi
    
    if [ ! -f "$file_path" ]; then
        log_message "❌ File not found: $file_path"
        exit 1
    fi
    
    log_message "🚀 Starting file processing: $file_path"
    process_intake_file "$file_path"
    log_message "✅ File processing completed"
}

# Run main function with provided arguments
main "$@"
