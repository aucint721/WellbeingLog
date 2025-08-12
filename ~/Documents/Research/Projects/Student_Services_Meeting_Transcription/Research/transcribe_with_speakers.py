#!/usr/bin/env python3
"""
Advanced Audio Transcription with Speaker Detection
Uses Whisper AI with custom speaker identification logic
"""

import os
import sys
import whisper
import json
from pathlib import Path
import argparse
from datetime import datetime


def detect_speakers_by_silence(segments, silence_threshold=1.0):
    """
    Detect speaker changes based on silence gaps and text patterns
    """
    speakers = []
    current_speaker = "Speaker 1"
    speaker_count = 1
    
    for i, segment in enumerate(segments):
        # Check for long silence gaps (potential speaker change)
        if i > 0:
            gap = segment['start'] - segments[i-1]['end']
            if gap > silence_threshold:
                speaker_count += 1
                current_speaker = f"Speaker {speaker_count}"
        
        # Check for question patterns (often indicate different speaker)
        text = segment['text'].strip()
        if text.endswith('?') and i > 0:
            # If previous segment didn't end with question, likely different speaker
            prev_text = segments[i-1]['text'].strip()
            if not prev_text.endswith('?'):
                speaker_count += 1
                current_speaker = f"Speaker {speaker_count}"
        
        # Check for response patterns (short responses often different speaker)
        if len(text.split()) <= 3 and i > 0:
            prev_text = segments[i-1]['text'].strip()
            if len(prev_text.split()) > 3:
                speaker_count += 1
                current_speaker = f"Speaker {speaker_count}"
        
        speakers.append({
            'start': segment['start'],
            'end': segment['end'],
            'text': text,
            'speaker': current_speaker
        })
    
    return speakers


def transcribe_with_speakers(audio_file_path, output_dir=None, model_size="base"):
    """
    Transcribe audio file with speaker identification
    """
    
    if not os.path.exists(audio_file_path):
        print(f"❌ Error: Audio file not found: {audio_file_path}")
        return False
    
    audio_path = Path(audio_file_path)
    audio_name = audio_path.stem
    
    if output_dir is None:
        output_dir = audio_path.parent
    else:
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"🎵 Processing audio file: {audio_name}")
    print(f"📁 Output directory: {output_dir}")
    print(f"🤖 Using Whisper model: {model_size}")
    print(f"🎤 Speaker detection: Enabled")
    
    try:
        # Load Whisper model
        print("🔄 Loading Whisper model...")
        model = whisper.load_model(model_size)
        
        # Transcribe with word timestamps for better speaker detection
        print("🎤 Transcribing audio with speaker detection...")
        result = model.transcribe(
            audio_file_path, 
            verbose=True,
            word_timestamps=True
        )
        
        # Detect speakers
        print("👥 Detecting speakers...")
        speakers = detect_speakers_by_silence(result['segments'])
        
        # Create formatted output with speakers
        print("📝 Formatting transcription with speakers...")
        
        # Save as structured format with speakers
        structured_output = output_dir / f"{audio_name}_with_speakers.txt"
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
            f.write("Meeting Content with Speaker Identification:\n")
            f.write("-" * 50 + "\n\n")
            
            current_speaker = None
            for segment in speakers:
                if segment['speaker'] != current_speaker:
                    current_speaker = segment['speaker']
                    f.write(f"\n{current_speaker}:\n")
                    f.write("-" * len(current_speaker) + "\n")
                
                # Format timestamp
                start_time = f"{int(segment['start'] // 60):02d}:{int(segment['start'] % 60):02d}"
                end_time = f"{int(segment['end'] // 60):02d}:{int(segment['end'] % 60):02d}"
                
                f.write(f"[{start_time} - {end_time}] {segment['text']}\n")
            
            f.write("\n\n" + "=" * 50 + "\n")
            f.write("Action Items:\n")
            f.write("- [ACTION ITEM 1] - Assigned to: [NAME] - Due: [DATE]\n")
            f.write("- [ACTION ITEM 2] - Assigned to: [NAME] - Due: [DATE]\n")
            f.write("- [ACTION ITEM 3] - Assigned to: [NAME] - Due: [DATE]\n\n")
            f.write("Next Steps:\n")
            f.write("- [NEXT STEP 1]\n")
            f.write("- [NEXT STEP 2]\n")
            f.write("- [NEXT STEP 3]\n")
        
        # Save as JSON for detailed analysis
        json_output = output_dir / f"{audio_name}_speakers_detailed.json"
        with open(json_output, 'w', encoding='utf-8') as f:
            json.dump({
                'audio_file': str(audio_path),
                'transcription_date': datetime.now().isoformat(),
                'model_used': model_size,
                'speakers': speakers,
                'original_result': result
            }, f, indent=2, ensure_ascii=False)
        
        # Save as plain text with speaker labels
        txt_output = output_dir / f"{audio_name}_speakers.txt"
        with open(txt_output, 'w', encoding='utf-8') as f:
            f.write(f"TRANSCRIPTION WITH SPEAKER DETECTION - {audio_name}\n")
            f.write("=" * 60 + "\n\n")
            f.write(f"Audio File: {audio_path.name}\n")
            f.write(f"Transcribed: {result.get('language', 'Unknown')}\n")
            f.write(f"Duration: {result.get('duration', 'Unknown')} seconds\n")
            f.write(f"Model: {model_size}\n\n")
            f.write("SPEAKER TRANSCRIPTION:\n")
            f.write("-" * 30 + "\n\n")
            
            current_speaker = None
            for segment in speakers:
                if segment['speaker'] != current_speaker:
                    current_speaker = segment['speaker']
                    f.write(f"\n{current_speaker}:\n")
                
                start_time = f"{int(segment['start'] // 60):02d}:{int(segment['start'] % 60):02d}"
                f.write(f"[{start_time}] {segment['text']}\n")
        
        print(f"✅ Transcription with speaker detection complete!")
        print(f"📄 Plain text with speakers: {txt_output}")
        print(f"📋 Structured with speakers: {structured_output}")
        print(f"🔍 Detailed JSON: {json_output}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error during transcription: {str(e)}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Transcribe audio with speaker detection using Whisper AI"
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
    
    # Transcribe audio with speakers
    success = transcribe_with_speakers(args.audio_file, args.output, args.model)
    
    if success:
        print("\n🎉 Ready to edit in Bean!")
        print("💡 Tip: Open the structured output file for easy editing")
        print("🎤 Speaker detection: Uses silence gaps and text patterns")
    else:
        print("\n❌ Transcription failed. Check the error messages above.")
        sys.exit(1)


if __name__ == "__main__":
    main()
