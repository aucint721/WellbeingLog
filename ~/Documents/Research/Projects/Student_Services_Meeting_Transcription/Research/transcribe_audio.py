#!/usr/bin/env python3
"""
Audio Transcription Helper Script
Uses Whisper AI to transcribe audio files and format output for Bean editing
"""

import os
import sys
import whisper
from pathlib import Path
import argparse


def transcribe_audio(audio_file_path, output_dir=None, model_size="base"):
    """
    Transcribe audio file using Whisper AI
    
    Args:
        audio_file_path (str): Path to audio file
        output_dir (str): Directory to save transcription (optional)
        model_size (str): Whisper model size (tiny, base, small, medium, large)
    """
    
    # Check if audio file exists
    if not os.path.exists(audio_file_path):
        print(f"❌ Error: Audio file not found: {audio_file_path}")
        return False
    
    # Get audio file info
    audio_path = Path(audio_file_path)
    audio_name = audio_path.stem
    
    # Set output directory
    if output_dir is None:
        output_dir = audio_path.parent
    else:
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"🎵 Processing audio file: {audio_name}")
    print(f"📁 Output directory: {output_dir}")
    print(f"🤖 Using Whisper model: {model_size}")
    
    try:
        # Load Whisper model
        print("🔄 Loading Whisper model...")
        model = whisper.load_model(model_size)
        
        # Transcribe audio
        print("🎤 Transcribing audio...")
        result = model.transcribe(audio_file_path, verbose=True)
        
        # Create formatted output
        print("📝 Formatting transcription...")
        
        # Save as plain text
        txt_output = output_dir / f"{audio_name}_transcription.txt"
        with open(txt_output, 'w', encoding='utf-8') as f:
            f.write(f"AUTOMATIC TRANSCRIPTION - {audio_name}\n")
            f.write("=" * 50 + "\n\n")
            f.write(f"Audio File: {audio_path.name}\n")
            f.write(f"Transcribed: {result.get('language', 'Unknown')}\n")
            f.write(f"Duration: {result.get('duration', 'Unknown')} seconds\n\n")
            f.write("TRANSCRIPTION:\n")
            f.write("-" * 20 + "\n\n")
            f.write(result['text'])
        
        # Save as structured format for Bean editing
        structured_output = output_dir / f"{audio_name}_structured.txt"
        with open(structured_output, 'w', encoding='utf-8') as f:
            f.write("STUDENT SERVICES MEETING TRANSCRIPTION\n")
            f.write("=" * 50 + "\n\n")
            f.write("Meeting Details:\n")
            f.write("Date: [INSERT DATE]\n")
            f.write("Time: [INSERT TIME]\n")
            f.write("Location: [INSERT LOCATION]\n")
            f.write("Attendees: [LIST ATTENDEES]\n\n")
            f.write("Executive Summary:\n")
            f.write("[Brief overview of key decisions and action items]\n\n")
            f.write("Meeting Content:\n")
            f.write("-" * 20 + "\n\n")
            f.write(result['text'])
            f.write("\n\n")
            f.write("Action Items:\n")
            f.write("- [ACTION ITEM 1] - Assigned to: [NAME] - Due: [DATE]\n")
            f.write("- [ACTION ITEM 2] - Assigned to: [NAME] - Due: [DATE]\n")
            f.write("- [ACTION ITEM 3] - Assigned to: [NAME] - Due: [DATE]\n\n")
            f.write("Next Steps:\n")
            f.write("- [NEXT STEP 1]\n")
            f.write("- [NEXT STEP 2]\n")
            f.write("- [NEXT STEP 3]\n")
        
        # Save as JSON for detailed analysis
        json_output = output_dir / f"{audio_name}_detailed.json"
        import json
        with open(json_output, 'w', encoding='utf-8') as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Transcription complete!")
        print(f"📄 Plain text: {txt_output}")
        print(f"📋 Structured: {structured_output}")
        print(f"🔍 Detailed: {json_output}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error during transcription: {str(e)}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Transcribe audio using Whisper AI"
    )
    parser.add_argument("audio_file", help="Path to audio file")
    parser.add_argument(
        "--output", "-o", 
        help="Output directory (default: same as audio file)"
    )
    parser.add_argument(
        "--model", "-m", default="base",
        choices=["tiny", "base", "small", "medium", "large"],
        help="Whisper model size (default: base)"
    )
    
    args = parser.parse_args()
    
    # Transcribe audio
    success = transcribe_audio(args.audio_file, args.output, args.model)
    
    if success:
        print("\n🎉 Ready to edit in Bean!")
        print("💡 Tip: Open the structured output file in Bean for easy editing")
    else:
        print("\n❌ Transcription failed. Check the error messages above.")
        sys.exit(1)


if __name__ == "__main__":
    main()
