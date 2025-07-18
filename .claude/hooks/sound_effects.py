#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///
"""
Claude Code Sound Effects Handler
=================================
Plays ambient sound effects for different Claude Code actions.
Works alongside the TTS notification system for comprehensive audio feedback.
"""

import sys
import json
import subprocess
from pathlib import Path
import re
import platform

# ===== CONFIGURATION =====
# Choose which sound set to use: "voice" (spoken words) or "beeps" (simple tones)
SOUNDS_TYPE = "beeps"

# ===== SOUND MAPPINGS =====
# This dictionary maps Claude Code events and tools to sound files
SOUND_MAP = {
    # File editing tools - all use the same "edit" sound
    "Edit": "edit",            # Single file edit
    "MultiEdit": "edit",       # Multiple edits in one file
    "Write": "edit",           # Write new file
    "NotebookEdit": "edit",    # Edit Jupyter notebook
    
    # Task management
    "TodoWrite": "list",       # Update todo list
    
    # Reading/searching tools
    "Read": "read",            # Read file
    "Grep": "search",          # Search with grep
    "Glob": "search",          # Search with glob
    "LS": "read",             # List directory
    
    # Bash command patterns - matched using regular expressions
    # Format: (regex_pattern, sound_name)
    "bash_patterns": [
        (r'^git commit', "commit"),                              # Git commits
        (r'^git add', "add"),                                    # Git staging
        (r'^gh pr', "pr"),                                       # GitHub pull requests
        (r'^bundle exec rspec|^rspec|^bin/rspec', "test"),      # Ruby tests
        (r'^npm test|^yarn test|^pytest|^go test', "test"),     # Various test runners
        (r'^npm install|^yarn install|^pip install', "install"), # Package installation
        (r'^npm run|^yarn run', "run"),                         # Run scripts
        (r'.*', "bash"),  # Fallback: play "bash" sound for any unmatched Bash command
    ]
}

def get_audio_player():
    """
    Get the appropriate audio player command for the current platform.
    
    Returns:
        List of command parts for subprocess, or None if no player found
    """
    system = platform.system()
    
    if system == "Darwin":  # macOS
        return ["afplay"]
    elif system == "Linux":
        # Try different Linux audio players in order of preference
        for player in ["aplay", "paplay", "play", "cvlc", "mpg123"]:
            try:
                subprocess.run([player, "--version"], 
                             stdout=subprocess.DEVNULL, 
                             stderr=subprocess.DEVNULL)
                if player == "cvlc":
                    return ["cvlc", "--play-and-exit", "--intf", "dummy"]
                return [player]
            except FileNotFoundError:
                continue
        return None
    elif system == "Windows":
        # Windows Media Player command line
        return ["powershell", "-c", "(New-Object Media.SoundPlayer"]
    
    return None

def play_sound(sound_name):
    """
    Play a sound file using the platform's audio player.
    
    Args:
        sound_name: Name of the sound file (without extension)
        
    Returns:
        True if sound played successfully, False otherwise
    """
    # Security check: Prevent directory traversal attacks
    if "/" in sound_name or "\\" in sound_name or ".." in sound_name:
        print(f"Invalid sound name: {sound_name}", file=sys.stderr)
        return False
    
    # Get audio player for this platform
    player_cmd = get_audio_player()
    if not player_cmd:
        # No audio player found - fail silently
        return False
    
    # Build the path to the sound file
    script_dir = Path(__file__).parent
    sounds_dir = script_dir / "sounds" / SOUNDS_TYPE
    
    # Try different audio formats
    for extension in ['.wav', '.mp3', '.ogg']:
        file_path = sounds_dir / f"{sound_name}{extension}"
        
        if file_path.exists():
            try:
                if platform.system() == "Windows":
                    # Special handling for Windows
                    cmd = player_cmd + [f'"{file_path}").PlaySync()']
                else:
                    cmd = player_cmd + [str(file_path)]
                
                # Play sound in background so we don't block Claude
                subprocess.Popen(
                    cmd,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL
                )
                return True
            except (FileNotFoundError, OSError) as e:
                # Log error but don't crash
                print(f"Error playing sound {file_path.name}: {e}", file=sys.stderr)
                return False
    
    # Sound not found - fail silently to avoid disrupting Claude's work
    return False

def log_hook_data(hook_data):
    """
    Log the hook data to a log file for debugging/auditing.
    """
    try:
        log_dir = Path(__file__).parent.parent.parent / "logs"
        log_dir.mkdir(exist_ok=True)
        log_path = log_dir / "sound_effects.jsonl"
        
        with open(log_path, "a", encoding="utf-8") as log_file:
            log_entry = {
                "timestamp": hook_data.get("timestamp", ""),
                "event": hook_data.get("hook_event_name", ""),
                "tool": hook_data.get("tool_name", ""),
                "sound_played": get_sound_for_event(hook_data)
            }
            log_file.write(json.dumps(log_entry) + "\n")
    except Exception:
        # Fail silently
        pass

def get_sound_for_event(hook_data):
    """
    Determine which sound to play based on Claude's action.
    
    Args:
        hook_data: Dictionary containing event information from Claude
        
    Returns:
        Sound name (string) or None if no sound should play
    """
    event_name = hook_data.get("hook_event_name", "")
    tool_name = hook_data.get("tool_name", "")
    
    # Skip notification events - those are handled by TTS
    if event_name == "Notification":
        return None
    
    # Check if this is a known tool
    if tool_name in SOUND_MAP:
        return SOUND_MAP[tool_name]
    
    # Special handling for Bash commands
    if tool_name == "Bash" and event_name == "PreToolUse":
        command = hook_data.get("tool_input", {}).get("command", "")
        
        # Check each pattern to see if it matches the command
        for regex_pattern, sound_name in SOUND_MAP["bash_patterns"]:
            if re.match(regex_pattern, command, re.IGNORECASE):
                return sound_name
    
    return None

def main():
    """
    Main program - runs when Claude triggers a hook.
    """
    try:
        # Read the event data from Claude
        input_data = json.load(sys.stdin)
        
        # Log for debugging
        log_hook_data(input_data)
        
        # Figure out which sound to play
        sound_name = get_sound_for_event(input_data)
        
        # Play the sound (if we found one)
        if sound_name:
            play_sound(sound_name)
        
        # Always exit successfully to not interrupt Claude
        sys.exit(0)
        
    except json.JSONDecodeError:
        sys.exit(0)
    except Exception:
        sys.exit(0)

if __name__ == "__main__":
    main()