# Health Check Command

## Trigger
When user types `<Health-Check>` or automatically at session start

## Process

1. **Check Message Count**
   - Count messages in current conversation
   - Update health status based on thresholds:
     - 0-30 messages: 🟢 Healthy
     - 31-45 messages: 🟡 Approaching limits
     - 46+ messages: 🔴 Handover recommended

2. **Display Session Status**
   ```
   === Session Health Check ===
   Status: [HEALTH_INDICATOR] [STATUS_TEXT]
   Messages: [COUNT]/50
   Mode: [CURRENT_MODE]
   Scope: [CURRENT_SCOPE]
   Task: [JIRA_ID] - [PHASE] ([PROGRESS]%)
   Branch: [GIT_BRANCH]
   
   [RECOMMENDATIONS_IF_ANY]
   ```

3. **Update Session State**
   - Save current state to `.claude/session/current-session.yaml`
   - Include timestamp of last update

4. **Warnings and Recommendations**
   - If 🟡: Suggest completing current unit of work
   - If 🔴: Recommend immediate handover after current task
   - Suggest natural breakpoints based on scope

## Example Output

```
=== Session Health Check ===
Status: 🟡 Approaching limits
Messages: 35/50
Mode: BUILD
Scope: LARGE
Task: VCS-234 - implementation (60%)
Branch: VCS-234

⚠️ Recommendation: Complete current function implementation, then generate handover document.
Natural breakpoint suggested after completing authentication module.
```

## Related Commands
- `<Handover01>` - Generate handover documentation
- `<Session-Metrics>` - View detailed session statistics
- `MODE: [mode]` - Switch operating mode
- `SCOPE: [scope]` - Update work complexity