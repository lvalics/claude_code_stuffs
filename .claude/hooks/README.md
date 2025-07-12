# Claude Code Hooks System

This hooks system provides lifecycle event handling for Claude Code operations, enabling custom actions at various stages of tool execution.

## Credits

This hooks implementation was inspired by [IndyDevDan](https://www.youtube.com/@indydevdan)'s excellent tutorials on extending Claude Code functionality.

## Overview

The hooks system allows you to intercept and respond to various events during Claude Code's execution:

- **PreToolUse**: Execute before any tool is used
- **PostToolUse**: Execute after any tool completes
- **Notification**: Handle user input requests
- **Stop**: Execute when chat ends
- **SubagentStop**: Execute when a subagent completes

## Hook Scripts

### notification.py
Handles user input notifications with optional Text-to-Speech (TTS) support. Automatically selects TTS provider based on available API keys (ElevenLabs > OpenAI > pyttsx3).

### pre_tool_use.py
Logs tool usage before execution for monitoring and debugging purposes.

### post_tool_use.py
Logs tool results after execution, useful for audit trails and debugging.

### stop.py
Executes cleanup actions when a chat session ends.

### subagent_stop.py
Handles cleanup when subagent tasks complete.

## Utilities

### TTS Providers (`utils/tts/`)
- **elevenlabs_tts.py**: Premium voice synthesis (requires ELEVENLABS_API_KEY)
- **openai_tts.py**: OpenAI's TTS service (requires OPENAI_API_KEY)
- **pyttsx3_tts.py**: Offline fallback TTS

### LLM Utilities (`utils/llm/`)
- **anth.py**: Anthropic API integration
- **oai.py**: OpenAI API integration

## Configuration

Hooks are configured in `.claude/settings.json`. Each hook can have multiple handlers with optional matchers for selective execution.

## Environment Variables

- `ELEVENLABS_API_KEY`: For ElevenLabs TTS
- `OPENAI_API_KEY`: For OpenAI TTS
- `ENGINEER_NAME`: Personalize notifications (30% chance of inclusion)

## Usage

All hook scripts use `uv` for dependency management and are executed automatically by Claude Code based on the settings configuration.