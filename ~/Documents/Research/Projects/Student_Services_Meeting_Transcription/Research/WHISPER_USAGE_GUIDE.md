# Whisper AI Usage Guide

## Setup Complete! ✅

Whisper AI is now installed and ready to use with your transcription project.

## Quick Start

### 1. Add Your Audio File
```bash
# Copy your audio file to the main Research directory
cp "path/to/your/audio.mp3" ~/Documents/Research/

# Process it automatically
source research_env/bin/activate
python research_file_manager.py --process ~/Documents/Research
```

### 2. Transcribe with Whisper AI
```bash
# Basic transcription (outputs to same directory as audio)
whisper ~/Documents/Research/audio/your_audio_file.mp3

# With specific output format and directory
whisper ~/Documents/Research/audio/your_audio_file.mp3 \
  --output_format txt \
  --output_dir ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Writing/
```

### 3. Open in Bean for Editing
```bash
# Open your project in Bean
python research_workflow.py open "Student_Services_Meeting_Transcription"
```

## Whisper AI Options

### Model Sizes (Quality vs Speed)
- **tiny**: Fastest, lowest quality
- **base**: Good balance (default)
- **small**: Better quality, slower
- **medium**: High quality, slower
- **large**: Best quality, slowest

### Output Formats
- **txt**: Plain text (recommended for editing)
- **json**: Detailed with timestamps
- **srt**: Subtitle format
- **vtt**: Web video format

## Example Commands

### Basic Transcription
```bash
whisper "meeting_recording.mp3"
```

### High Quality with Custom Output
```bash
whisper "meeting_recording.mp3" \
  --model medium \
  --output_format txt \
  --output_dir ~/Documents/Research/Projects/Student_Services_Meeting_Transcription/Writing/
```

### Batch Processing Multiple Files
```bash
# Process all MP3 files in a directory
for file in ~/Documents/Research/audio/*.mp3; do
  whisper "$file" --output_format txt
done
```

## Workflow Integration

### Complete Process:
1. **Drop audio** in `~/Documents/Research/`
2. **Process automatically**: `python research_file_manager.py --process ~/Documents/Research`
3. **Transcribe with Whisper**: `whisper audio_file.mp3 --output_format txt`
4. **Edit in Bean**: `python research_workflow.py open "Student_Services_Meeting_Transcription"`
5. **Use your templates** for final formatting

## Tips for Best Results

- **Clear audio** = better transcription
- **Use base model** for most meetings
- **Use medium/large** for important presentations
- **Save as txt** for easy editing in Bean
- **Process in batches** for multiple files

## Troubleshooting

### Common Issues:
- **"No module named 'whisper'"**: Activate your environment first
- **Audio format errors**: Ensure file is valid audio (MP3, WAV, M4A)
- **Memory issues**: Use smaller model (tiny/base) for long files

### Get Help:
```bash
# Check Whisper version
whisper --version

# See all options
whisper --help

# Test with a short audio file first
whisper "test_audio.mp3" --model tiny
```

## Ready to Use! 🚀

Your Whisper AI setup is complete. Just add your audio file and start transcribing!
