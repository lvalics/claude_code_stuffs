# Team Configuration Directory

This directory contains team-specific configuration files that customize the Claude Code framework for your specific needs.

## Configuration Files

### `team-config.yaml`
Main team configuration file containing:
- Team information (name, size)
- Project type and industry
- Technology stack
- Coding standards preferences
- Testing requirements

### `workflow-config.yaml`
Workflow-specific settings:
- Branching strategy
- Pull request requirements
- Deployment environments
- CI/CD preferences

### `customization-summary.md`
Auto-generated summary of all customizations made through the interactive script.

### `customization-log.md`
Historical log of all customizations with timestamps and reasons.

## File Formats

All configuration files use YAML format for easy reading and editing. You can manually edit these files after running the customization script.

## Example Configurations

See the `examples/` subdirectory for sample configurations for different team types:
- `startup-team.yaml` - Small, fast-moving startup configuration
- `enterprise-team.yaml` - Large enterprise with strict compliance
- `opensource-project.yaml` - Open source project configuration

## Usage

1. Run `./scripts/customize-framework.sh` to generate initial configuration
2. Edit files manually as needed
3. Share configuration with your team by committing to version control
4. Update configurations as your team evolves

## Best Practices

- Keep configurations under version control
- Document reasons for customizations
- Review configurations quarterly
- Use environment-specific overrides when needed