# Refactoring Best Practices

## Core Principle
Make code better without breaking it. Small, safe changes > big rewrites.

## The 3-Step Process

### 1. Before You Touch Anything
```yaml
pre_refactor_checklist:
  - [ ] Tests exist and pass (write them if needed)
  - [ ] Create branch: {TASK-ID}-refactor
  - [ ] Assess scope: MICRO/SMALL/MEDIUM/LARGE/EPIC
  - [ ] Plan natural breakpoints for LARGE+ refactors
```

### 2. During Refactoring
```yaml
refactoring_rules:
  - Commit every 50-150 lines changed
  - Run tests after EVERY change
  - Start with private methods (safest)
  - End with public interfaces (riskiest)
  - Use feature flags for big changes
```

### 3. Definition of Done
```yaml
completion_checklist:
  - [ ] All tests pass
  - [ ] No performance regression
  - [ ] Code reviewed
  - [ ] Documentation updated
  - [ ] Feature flags removed
```

## Scope Guidelines

| Scope | Size | Examples | Session Planning |
|-------|------|----------|------------------|
| MICRO | < 50 lines | Extract method, rename variable | Single session |
| SMALL | 50-200 lines | Extract class, simplify logic | Single session |
| MEDIUM | 200-500 lines | Reorganize module | 1-2 sessions |
| LARGE | 500-2000 lines | Change architecture | Plan handovers |
| EPIC | > 2000 lines | System redesign | Multiple handovers |

## Common Patterns

### Extract Method
**When**: Method > 20 lines or does multiple things
**How**: Pull out cohesive code block with descriptive name

### Simplify Conditionals
**When**: if/else chains > 5 branches
**How**: Use polymorphism, strategy pattern, or lookup tables

### Reduce Parameters
**When**: Method has > 3 parameters
**How**: Create parameter object or use builder pattern

## What NOT to Do

❌ **Big Bang**: Rewriting everything at once
❌ **Moving Target**: Refactoring while requirements change  
❌ **Perfection**: Over-engineering for hypothetical futures

## Quick Tools

### Built-in Claude Code Support
- Session tracking via `.claude/session/current-session.yaml`
- Git hooks in `.claude/hooks/` for pre-commit checks
- IDE diagnostics: `mcp__ide__getDiagnostics`

### Language-Specific Linters
- **Python**: `black`, `flake8`, `pylint`
- **JavaScript/TypeScript**: `eslint`, `prettier`
- **Java**: `checkstyle`, `spotbugs`
- **Go**: `gofmt`, `golint`

## Emergency Rollback

If something breaks:
1. **Quick fix**: Toggle feature flag off
2. **Full rollback**: `git revert` the commits
3. **Nuclear option**: Redeploy previous version

## Session Handover

For LARGE+ refactors, document in `/tasks/{TASK-ID}/refactor-progress.md`:
- What's done
- What's next
- Any gotchas
- Current test status

## One-Page Checklist

```markdown
BEFORE:
□ Tests pass
□ Branch created
□ Scope assessed

DURING:
□ Small commits (50-150 lines)
□ Tests after each change
□ Private → Public order

AFTER:
□ All tests pass
□ Performance OK
□ Code reviewed
□ Docs updated
```

Remember: The goal is better code, not perfect code. Ship improvements incrementally.