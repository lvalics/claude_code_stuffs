# Team Customizations for [Technology] Best Practices

<!-- 
This template is for adding team-specific customizations to existing best practices
without modifying the original files. Include this at the end of the original file
or reference it separately.
-->

## Team: [Your Team Name]
**Date**: [YYYY-MM-DD]  
**Approved by**: [Tech Lead/Manager Name]  
**Applies to**: [Project/Repository Name]

## Overrides to Default Practices

### Code Style Overrides
<!-- List any deviations from the default code style -->
- [ ] Indentation: [Your preference] (Default: [default value])
- [ ] Line length: [Your limit] (Default: [default value])
- [ ] Naming convention: [Your convention] (Default: [default convention])

### Testing Overrides
<!-- Specify different testing requirements -->
- [ ] Minimum coverage: [Your requirement]% (Default: [default]%)
- [ ] Test framework: [Your choice] (Default: [default])
- [ ] E2E testing: [Your approach]

### Security Overrides
<!-- Only override if you have stricter requirements -->
- [ ] Additional compliance: [e.g., HIPAA, SOC2]
- [ ] Enhanced authentication: [requirements]
- [ ] Data retention: [your policy]

## Additional Practices

### [Custom Practice Category]
<!-- Add practices not covered in the default -->

#### Rationale
Why this practice is needed for your team.

#### Implementation
Specific steps or requirements.

#### Examples
```[language]
// Example code showing the practice
```

## Exceptions

### Temporary Exceptions
<!-- List any temporary deviations with end dates -->
1. **Exception**: [What you're not following]
   - **Reason**: [Why]
   - **Until**: [Date or condition]
   - **Migration plan**: [How to comply later]

### Permanent Exceptions
<!-- Document why certain practices don't apply -->
1. **Exception**: [What doesn't apply]
   - **Reason**: [Why it's not applicable]
   - **Alternative**: [What you do instead]

## Tools and Automation

### Required Tools
<!-- Team-specific tools that supplement the defaults -->
- **Tool**: [Purpose]
- **Configuration**: [Link to config]

### Pre-commit Hooks
```yaml
# Example .pre-commit-config.yaml additions
repos:
  - repo: [your-custom-repo]
    rev: [version]
    hooks:
      - id: [hook-id]
```

### CI/CD Additions
<!-- Additional CI/CD steps for your team -->
```yaml
# Example pipeline additions
- name: [Step name]
  run: |
    [commands]
```

## Review Schedule

- **Quarterly Review Date**: [Next review date]
- **Review Owner**: [Name]
- **Review Checklist**:
  - [ ] Are overrides still necessary?
  - [ ] Any new team requirements?
  - [ ] Can any exceptions be removed?
  - [ ] Update from base practices needed?

## Communication

### How to Propose Changes
1. Create a PR with proposed changes
2. Tag `@team-leads` for review
3. Discuss in team meeting
4. Update this document once approved

### Questions?
- **Slack Channel**: #[your-channel]
- **Team Lead**: [Name]
- **Documentation Owner**: [Name]