# Best Practices Customization Guide

This guide explains how to effectively customize the Claude Code best practices to match your team's specific workflows, standards, and requirements.

## Why Customize?

While our default best practices are based on industry standards, every team has unique needs based on:
- Company policies and standards
- Team size and structure
- Technology stack variations
- Industry-specific requirements
- Project phase (startup MVP vs. enterprise scaling)
- Regional compliance requirements

## Before You Customize

### 1. Understand the Defaults
Before modifying any best practice:
- Read the entire default file to understand its purpose
- Identify which sections align with your needs
- Note which sections need modification
- Consider the implications of changes

### 2. Document Your Reasoning
For each customization, document:
- Why the change is needed
- Who approved the change
- When it was implemented
- Any trade-offs considered

## How to Customize

### Step 1: Identify What to Customize

Start by answering these questions:
1. What are your team's non-negotiable standards?
2. Which default practices conflict with your workflow?
3. What additional practices does your team need?
4. Are there industry-specific requirements to add?

### Step 2: Create a Customization Plan

Before editing files, create a plan:

```markdown
## Customization Plan for [Team/Project Name]

### Practices to Keep As-Is:
- List practices that work well for your team

### Practices to Modify:
- Practice: [name]
  - Current: [what it says now]
  - Proposed: [what you want it to say]
  - Reason: [why this change is needed]

### Practices to Add:
- New practice: [name]
  - Purpose: [why this is needed]
  - Details: [what it should include]

### Practices to Remove:
- Practice: [name]
  - Reason: [why it's not applicable]
```

### Step 3: Make Your Edits

1. **Create a backup** of the original file:
   ```bash
   cp .claude/best_practices/nodejs-best-practices.md \
      .claude/best_practices/nodejs-best-practices.md.default
   ```

2. **Edit the file** with your customizations:
   - Keep the same structure and formatting
   - Mark custom sections clearly
   - Add your team/project name in comments

3. **Add custom markers** to your changes:
   ```markdown
   ## Code Style [CUSTOMIZED: ACME Corp]
   <!-- Custom requirement: Added by Team Alpha on 2024-01-15 -->
   - Use 4 spaces for indentation (company standard)
   - Maximum line length: 100 characters
   ```

### Step 4: Version Control Your Customizations

1. **Commit your changes** with clear messages:
   ```bash
   git add .claude/best_practices/nodejs-best-practices.md
   git commit -m "Customize Node.js practices for ACME Corp standards
   
   - Changed indentation from 2 to 4 spaces
   - Added company-specific error handling patterns
   - Included ACME logging requirements"
   ```

2. **Track customization history** in a changelog:
   ```markdown
   # Best Practices Customization Log

   ## 2024-01-15 - Node.js Practices
   - Modified by: Team Alpha
   - Changes: Indentation, error handling, logging
   - Approved by: Tech Lead John Doe
   ```

## Common Customization Patterns

### Pattern 1: Adding Company Standards

```markdown
## Security Practices [CUSTOMIZED: FinTech Corp]

### Original practices remain...

### Company-Specific Additions:
<!-- Added for SOC2 compliance -->
- All API endpoints must log access attempts
- PII must be encrypted at rest using AES-256
- Session timeout must be 15 minutes
```

### Pattern 2: Modifying for Team Size

```markdown
## Code Review Process [CUSTOMIZED: Startup Team]

<!-- Simplified for 3-person team -->
- ~~All PRs require 2 reviews~~ → One review sufficient
- ~~24-hour review SLA~~ → Best effort basis
- Add: Pair programming can replace formal review
```

### Pattern 3: Industry-Specific Requirements

```markdown
## Data Handling [CUSTOMIZED: Healthcare]

### HIPAA Compliance Additions:
- All patient data must be encrypted in transit and at rest
- Implement audit logging for all data access
- Data retention: 7 years minimum
- Include BAA requirements for third-party services
```

### Pattern 4: Technology Stack Variations

```markdown
## Testing Practices [CUSTOMIZED: React + Jest]

<!-- Adapted for our specific stack -->
- Use React Testing Library (not Enzyme)
- Minimum coverage: 80% for components
- E2E tests using Playwright (not Cypress)
- Visual regression tests with Percy
```

## Maintaining Customizations

### Regular Reviews

Schedule quarterly reviews to:
- Assess if customizations are still needed
- Check for conflicts with new default updates
- Add new customizations as needed
- Remove outdated customizations

### Handling Framework Updates

When the base framework updates:

1. **Review the changelog** for the framework
2. **Compare changes** with your customizations:
   ```bash
   diff .claude/best_practices/nodejs-best-practices.md.default \
        .claude/best_practices/nodejs-best-practices.md
   ```
3. **Merge carefully**, preserving your customizations
4. **Test** that customizations still make sense
5. **Document** any conflicts resolved

### Team Onboarding

For new team members:
1. Point them to this customization guide
2. Explain why specific customizations exist
3. Include customizations in onboarding checklist
4. Review customizations together

## Validating Customizations

After making customizations, run the validation script to ensure quality:

```bash
./scripts/validate-best-practices.sh
```

The validation script checks:
- **Structure**: Required sections are present
- **Formatting**: Proper markdown syntax and hierarchy
- **Customization markers**: Correct format with team names
- **Documentation**: Explanations for customizations
- **Consistency**: Matches team configuration
- **YAML syntax**: Valid configuration files

Review the validation report at `.claude/validation-report.md` for details.

## Best Practices for Customization

### DO:
- ✅ Keep customizations minimal and focused
- ✅ Document every change with reasoning
- ✅ Use clear markers for custom sections
- ✅ Review customizations regularly
- ✅ Share customizations with the team
- ✅ Consider contributing useful customizations back to the framework

### DON'T:
- ❌ Customize everything just because you can
- ❌ Make changes without team consensus
- ❌ Remove security or quality practices without good reason
- ❌ Forget to update customizations when practices change
- ❌ Create conflicting customizations across files

## Examples of Well-Documented Customizations

### Example 1: Clear and Justified

```markdown
## Variable Naming [CUSTOMIZED: DataScience Team]
<!-- Custom: Using Python scientific computing conventions -->
<!-- Reason: Consistency with NumPy/Pandas ecosystem -->
<!-- Approved: Team Lead, 2024-01-10 -->

- Use `df` for DataFrame variables (not `dataFrame`)
- Use `arr` for arrays (not `array`)
- Single letter variables OK for math operations (x, y, z)
```

### Example 2: Temporary Customization

```markdown
## Deployment Process [CUSTOMIZED: Migration Period]
<!-- TEMPORARY: Remove after AWS migration (target: Q2 2024) -->
<!-- Current: Dual deployment to old and new infrastructure -->

- Deploy to both Heroku (legacy) and AWS (new)
- Run smoke tests on both environments
- Monitor both for 24 hours post-deployment
```

## Conflict Resolution

When customizations conflict:

1. **Document the conflict** clearly
2. **Discuss with the team** to find consensus
3. **Choose the most restrictive option** when in doubt
4. **Set a review date** to revisit the decision

## Using Templates

The framework provides several templates to help with customization:

### Creating New Best Practices
Use `.claude/templates/custom-best-practice-template.md` when adding practices for technologies not yet covered.

### Adding Team Customizations
Use `.claude/templates/best-practice-addendum-template.md` to document team-specific changes without modifying the original files.

### Quick Reference Guide
Use `.claude/templates/team-quick-reference.md` to create a one-page guide for your team.

### Migration Planning
Use `.claude/templates/migration-guide-template.md` if transitioning from another framework.

## Getting Help

- For questions about customization: Create an issue in your team's repo
- For suggestions to improve defaults: Submit a PR to the framework
- For examples from other teams: Check the `.claude/config/examples/` directory

Remember: The goal of customization is to make the best practices work better for your team, not to avoid good practices altogether.