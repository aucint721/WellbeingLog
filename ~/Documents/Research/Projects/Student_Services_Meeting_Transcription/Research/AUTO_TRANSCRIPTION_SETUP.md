# Automatic Audio Transcription Setup

## Overview
This guide shows how to set up automatic audio transcription that can process your audio files and output text directly to Bean for editing.

## Option 1: Whisper AI (Free, Local Processing)

### Installation
```bash
# Install Whisper
pip install openai-whisper

# Or using Homebrew on macOS
brew install ffmpeg
pip install openai-whisper
```

### Usage
```bash
# Basic transcription
whisper "your_audio_file.mp3" --output_format txt

# With speaker diarization (identifies different speakers)
whisper "your_audio_file.mp3" --output_format txt --word_timestamps True
```

### Integration with Your Project
```bash
# Process audio and output to your project's Writing folder
whisper ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Research/your_audio_file.mp3 \
  --output_format txt \
  --output_dir ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Writing/
```

## Option 2: OpenAI Whisper API (Paid, High Quality)

### Setup
```bash
# Install OpenAI
pip install openai

# Set your API key
export OPENAI_API_KEY="your_api_key_here"
```

### Python Script for Automatic Processing
```python
import openai
import os

def transcribe_audio(audio_file_path, output_file_path):
    """Transcribe audio file using OpenAI Whisper API"""
    
    with open(audio_file_path, "rb") as audio_file:
        transcript = openai.Audio.transcribe(
            "whisper-1", 
            audio_file,
            response_format="verbose_json",
            timestamp_granularities=["word"]
        )
    
    # Format output for Bean
    with open(output_file_path, "w") as f:
        f.write("AUTOMATIC TRANSCRIPTION OUTPUT\n")
        f.write("=" * 50 + "\n\n")
        
        for segment in transcript.segments:
            f.write(f"[{segment.start:.2f}s - {segment.end:.2f}s] ")
            f.write(f"Speaker: {segment.speaker if hasattr(segment, 'speaker') else 'Unknown'}\n")
            f.write(f"{segment.text}\n\n")
    
    return output_file_path

# Usage
audio_file = "~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Research/your_audio.mp3"
output_file = "~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Writing/transcription_output.txt"

transcribe_audio(audio_file, output_file)
```

## Option 3: macOS Built-in Speech Recognition

### Using macOS Dictation
1. **System Preferences** → **Keyboard** → **Dictation**
2. **Enable Dictation**
3. **Use "Enhanced Dictation"** for offline processing

### Script for macOS Speech Recognition
```bash
#!/bin/bash
# macOS Speech Recognition Script

AUDIO_FILE="$1"
OUTPUT_FILE="$2"

# Convert audio to format macOS can process
ffmpeg -i "$AUDIO_FILE" -ar 16000 -ac 1 "$AUDIO_FILE.wav"

# Use macOS speech recognition (requires manual setup)
# This is a placeholder for the actual implementation
echo "Audio file processed: $AUDIO_FILE"
echo "Output file: $OUTPUT_FILE"
```

## Recommended Workflow

### 1. Quick Setup (Recommended for beginners)
```bash
# Copy audio to main Research directory
cp "your_audio.mp3" ~/Documents/Research/

# Process automatically
python research_file_manager.py --process ~/Documents/Research

# Copy to your project
cp ~/Documents/Research/audio/your_audio_processed.mp3 ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Research/
```

### 2. Automatic Transcription (Advanced users)
```bash
# Install Whisper
pip install openai-whisper

# Transcribe automatically
whisper ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Research/your_audio.mp3 \
  --output_format txt \
  --output_dir ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Writing/

# Open in Bean for editing
python research_workflow.py open "Student_Services_Meeting_Transcription"
```

## Benefits of Each Approach

### Manual Processing
- ✅ **No setup required**
- ✅ **Immediate use**
- ✅ **Full control**

### Whisper AI (Local)
- ✅ **Free to use**
- ✅ **Privacy (local processing)**
- ✅ **Good quality**
- ❌ **Requires setup**

### OpenAI API
- ✅ **Highest quality**
- ✅ **Speaker identification**
- ✅ **Easy integration**
- ❌ **Cost per minute**

## Next Steps
1. **Choose your preferred method**
2. **Set up the tools** (if using AI transcription)
3. **Process your audio file**
4. **Edit the output in Bean**
5. **Use your project templates** for final formatting
