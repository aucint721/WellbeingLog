#!/bin/bash
# Enhanced Hazel Automation Script - System-Wide Coverage
# Monitors and organizes files from ANY folder on your system

# Configuration
RESEARCH_DIR="$HOME/Documents/Research"
ORGANIZED_DIR="$RESEARCH_DIR/Organized_Research"
ARCHIVES_DIR="$RESEARCH_DIR/Archives/By_Type"
LOGS_DIR="$RESEARCH_DIR/Logs"
SYSTEM_LOGS_DIR="$RESEARCH_DIR/System_Logs"

# Create necessary directories
mkdir -p "$LOGS_DIR"
mkdir -p "$SYSTEM_LOGS_DIR"
mkdir -p "$ORGANIZED_DIR"
mkdir -p "$ARCHIVES_DIR"

# Log function with source tracking
log_message() {
    local source_folder=$(basename "$(dirname "$1")")
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - [$source_folder] $2" >> "$LOGS_DIR/hazel_system_wide.log"
    echo "$2"
}

# Enhanced file processing with source tracking
process_system_file() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    local source_folder=$(basename "$(dirname "$file_path")")
    local extension="${filename##*.}"
    
    log_message "$file_path" "🔍 Processing: $filename (from $source_folder)"
    
    # Determine file type and route accordingly
    case "${extension,,}" in
        # Research Documents
        pdf|doc|docx|rtf|txt|md|pages|keynote|numbers)
            process_research_document "$file_path" "$source_folder"
            ;;
        
        # LaTeX Files
        tex|bib|sty|cls|aux|out|synctex.gz)
            process_latex_file "$file_path" "$source_folder"
            ;;
        
        # Images
        jpg|jpeg|png|gif|bmp|tiff|svg|heic|webp|raw|cr2|nef|arw)
            process_image_file "$file_path" "$source_folder"
            ;;
        
        # Audio/Video
        mp3|wav|m4a|aac|flac|ogg|mp4|mov|avi|mkv|wmv|flv|webm|m4v)
            process_media_file "$file_path" "$source_folder"
            ;;
        
        # E-books
        epub|mobi|azw3|pdf)
            process_ebook_file "$file_path" "$source_folder"
            ;;
        
        # Code/Development
        py|js|html|css|java|cpp|c|swift|sh|sql|php|rb|go|rs|ts|jsx|tsx|vue)
            process_code_file "$file_path" "$source_folder"
            ;;
        
        # Archives
        zip|rar|7z|tar|gz|bz2|xz|dmg|pkg|deb|rpm)
            process_archive_file "$file_path" "$source_folder"
            ;;
        
        # Spreadsheets
        xlsx|xls|csv|ods|numbers)
            process_spreadsheet_file "$file_path" "$source_folder"
            ;;
        
        # Presentations
        pptx|ppt|key|odp)
            process_presentation_file "$file_path" "$source_folder"
            ;;
        
        # Database files
        db|sqlite|sqlite3|mdb|accdb)
            process_database_file "$file_path" "$source_folder"
            ;;
        
        # Configuration files
        conf|config|ini|cfg|json|xml|yaml|yml|toml)
            process_config_file "$file_path" "$source_folder"
            ;;
        
        # Log files
        log|logs|out|err)
            process_log_file "$file_path" "$source_folder"
            ;;
        
        # Font files
        ttf|otf|woff|woff2|eot)
            process_font_file "$file_path" "$source_folder"
            ;;
        
        # Executable files
        app|exe|dmg|pkg|deb|rpm|msi)
            process_executable_file "$file_path" "$source_folder"
            ;;
        
        *)
            process_unknown_file "$file_path" "$source_folder"
            ;;
    esac
}

# Enhanced research document processing
process_research_document() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📚 Processing research document: $filename (from $source_folder)"
    
    # Use enhanced workflow to determine course and organize
    if command -v python3 &> /dev/null; then
        cd "$RESEARCH_DIR"
        if [ -f "enhanced_workflow.py" ]; then
            python3 enhanced_workflow.py --process "$file_path"
            if [ $? -eq 0 ]; then
                log_message "$file_path" "✅ Research document processed successfully"
                return 0
            fi
        fi
    fi
    
    # Fallback: organize by type with source tracking
    local target_dir="$ARCHIVES_DIR/Documents/$source_folder"
    mkdir -p "$target_dir"
    
    # Generate organized filename
    local organized_name=$(generate_organized_name "$filename" "research" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Moved to: $target_path"
}

# Enhanced LaTeX file processing
process_latex_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📝 Processing LaTeX file: $filename (from $source_folder)"
    
    # Create LaTeX project structure
    local project_name=$(extract_project_name "$filename")
    local project_dir="$RESEARCH_DIR/Projects/$project_name"
    
    mkdir -p "$project_dir"/{Research,Writing,Drafts,Final,Bibliography,Build}
    
    # Move file to appropriate subfolder
    if [[ "$filename" == *.tex ]]; then
        mv "$file_path" "$project_dir/Writing/"
    elif [[ "$filename" == *.bib ]]; then
        mv "$file_path" "$project_dir/Bibliography/"
    elif [[ "$filename" =~ \.(aux|out|synctex\.gz)$ ]]; then
        mv "$file_path" "$project_dir/Build/"
    else
        mv "$file_path" "$project_dir/Research/"
    fi
    
    log_message "$file_path" "📁 LaTeX project created: $project_dir"
}

# Enhanced image processing
process_image_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "🖼️ Processing image: $filename (from $source_folder)"
    
    # Extract metadata and organize by date and source
    local date_folder=$(date +%Y/%m)
    local target_dir="$ARCHIVES_DIR/Images/$date_folder/$source_folder"
    mkdir -p "$target_dir"
    
    # Generate organized filename
    local organized_name=$(generate_organized_name "$filename" "image" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Image organized: $target_path"
}

# Enhanced media processing
process_media_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "🎵 Processing media: $filename (from $source_folder)"
    
    # Check if it's an audio file for transcription
    if [[ "$filename" =~ \.(mp3|wav|m4a|aac|flac|ogg)$ ]]; then
        # Route to transcription folder
        local transcribe_dir="$RESEARCH_DIR/Projects/Audio_Transcription/$(date +%Y%m%d)/$source_folder"
        mkdir -p "$transcribe_dir"
        mv "$file_path" "$transcribe_dir/"
        log_message "$file_path" "🎤 Audio routed for transcription: $transcribe_dir"
    else
        # Route to media archives
        local date_folder=$(date +%Y/%m)
        local target_dir="$ARCHIVES_DIR/Media/$date_folder/$source_folder"
        mkdir -p "$target_dir"
        
        local organized_name=$(generate_organized_name "$filename" "media" "$source_folder")
        local target_path="$target_dir/$organized_name"
        
        mv "$file_path" "$target_path"
        log_message "$file_path" "📁 Media organized: $target_path"
    fi
}

# Enhanced e-book processing
process_ebook_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📖 Processing e-book: $filename (from $source_folder)"
    
    # Try to add to Calibre if available
    if command -v calibredb &> /dev/null; then
        local calibre_library="$HOME/Calibre Library"
        if [ -d "$calibre_library" ]; then
            cd "$calibre_library"
            calibredb add "$file_path" --library-path "$calibre_library"
            log_message "$file_path" "📚 Added to Calibre library"
        fi
    fi
    
    # Also organize in research archives with source tracking
    local target_dir="$ARCHIVES_DIR/E-books/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "ebook" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 E-book organized: $target_path"
}

# Enhanced code processing
process_code_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "💻 Processing code: $filename (from $source_folder)"
    
    # Create development project structure
    local project_name=$(extract_project_name "$filename")
    local project_dir="$RESEARCH_DIR/Projects/Development/$project_name"
    
    mkdir -p "$project_dir"/{src,tests,docs,resources,config}
    
    # Move file to appropriate folder
    if [[ "$filename" =~ \.(conf|config|ini|cfg|json|xml|yaml|yml|toml)$ ]]; then
        mv "$file_path" "$project_dir/config/"
    elif [[ "$filename" =~ \.(md|txt|rst)$ ]]; then
        mv "$file_path" "$project_dir/docs/"
    elif [[ "$filename" =~ \.(test|spec)$ ]]; then
        mv "$file_path" "$project_dir/tests/"
    else
        mv "$file_path" "$project_dir/src/"
    fi
    
    log_message "$file_path" "📁 Code project created: $project_dir"
}

# Enhanced archive processing
process_archive_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📦 Processing archive: $filename (from $source_folder)"
    
    # Extract and organize contents
    local extract_dir="$ARCHIVES_DIR/Extracted/$(date +%Y%m%d_%H%M%S)/$source_folder"
    mkdir -p "$extract_dir"
    
    cd "$extract_dir"
    
    # Extract based on file type
    case "${filename##*.}" in
        zip) unzip "$file_path" 2>/dev/null ;;
        rar) unrar x "$file_path" 2>/dev/null ;;
        7z) 7z x "$file_path" 2>/dev/null ;;
        tar) tar -xf "$file_path" 2>/dev/null ;;
        gz) tar -xzf "$file_path" 2>/dev/null ;;
        bz2) tar -xjf "$file_path" 2>/dev/null ;;
        xz) tar -xJf "$file_path" 2>/dev/null ;;
        dmg) hdiutil attach "$file_path" -mountpoint ./mounted 2>/dev/null ;;
        *) log_message "$file_path" "⚠️ Unsupported archive format: ${filename##*.}" ;;
    esac
    
    # Move original archive to archives with source tracking
    local archive_dir="$ARCHIVES_DIR/Archives/$source_folder"
    mkdir -p "$archive_dir"
    mv "$file_path" "$archive_dir/"
    
    log_message "$file_path" "📁 Archive extracted to: $extract_dir"
}

# Enhanced spreadsheet processing
process_spreadsheet_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📊 Processing spreadsheet: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Spreadsheets/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "spreadsheet" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Spreadsheet organized: $target_path"
}

# Enhanced presentation processing
process_presentation_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📽️ Processing presentation: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Presentations/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "presentation" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Presentation organized: $target_path"
}

# Database file processing
process_database_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "🗄️ Processing database: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Databases/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "database" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Database organized: $target_path"
}

# Configuration file processing
process_config_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "⚙️ Processing config: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Configuration/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "config" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Configuration organized: $target_path"
}

# Log file processing
process_log_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "📋 Processing log: $filename (from $source_folder)"
    
    local target_dir="$SYSTEM_LOGS_DIR/$source_folder/$(date +%Y/%m)"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "log" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Log organized: $target_path"
}

# Font file processing
process_font_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "🔤 Processing font: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Fonts/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "font" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Font organized: $target_path"
}

# Executable file processing
process_executable_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "🚀 Processing executable: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Executables/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "executable" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Executable organized: $target_path"
}

# Enhanced unknown file processing
process_unknown_file() {
    local file_path="$1"
    local source_folder="$2"
    local filename=$(basename "$file_path")
    
    log_message "$file_path" "❓ Processing unknown file: $filename (from $source_folder)"
    
    local target_dir="$ARCHIVES_DIR/Unknown_Files/$source_folder"
    mkdir -p "$target_dir"
    
    local organized_name=$(generate_organized_name "$filename" "unknown" "$source_folder")
    local target_path="$target_dir/$organized_name"
    
    mv "$file_path" "$target_path"
    log_message "$file_path" "📁 Unknown file archived: $target_path"
}

# Enhanced helper functions
generate_organized_name() {
    local filename="$1"
    local type="$2"
    local source_folder="$3"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Remove common prefixes/suffixes
    local clean_name=$(echo "$filename" | sed 's/^download_*//i' | sed 's/_*download$//i')
    clean_name=$(echo "$clean_name" | sed 's/^file_*//i' | sed 's/_*file$//i')
    clean_name=$(echo "$clean_name" | sed 's/^copy_*//i' | sed 's/_*copy$//i')
    
    # Clean up underscores and dashes
    clean_name=$(echo "$clean_name" | sed 's/[_-]\+/_/g' | sed 's/^_\|_$//g')
    
    # Add source and type prefix if filename is generic
    if [[ "$clean_name" =~ ^(untitled|document|file|download|copy)$ ]]; then
        clean_name="${source_folder}_${type}_${timestamp}"
    else
        clean_name="${source_folder}_${clean_name}"
    fi
    
    echo "$clean_name"
}

extract_project_name() {
    local filename="$1"
    local base_name=$(os.path.splitext(filename)[0])
    
    # Remove common prefixes
    base_name=$(echo "$base_name" | sed 's/^thesis_*//i' | sed 's/^paper_*//i' | sed 's/^research_*//i')
    base_name=$(echo "$base_name" | sed 's/^project_*//i' | sed 's/^app_*//i' | sed 's/^script_*//i')
    
    # Convert to title case
    echo "$base_name" | sed 's/\b\w/\U&/g' | sed 's/_/ /g'
}

# Main execution with enhanced logging
main() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        echo "❌ No file path provided"
        exit 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo "❌ File not found: $file_path"
        exit 1
    fi
    
    # Create system-wide log entry
    local source_folder=$(basename "$(dirname "$file_path")")
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - SYSTEM WIDE: Processing $file_path from $source_folder" >> "$LOGS_DIR/hazel_system_wide.log"
    
    echo "🚀 Starting system-wide file processing: $file_path"
    process_system_file "$file_path"
    echo "✅ System-wide file processing completed"
}

# Run main function with provided arguments
main "$@"

