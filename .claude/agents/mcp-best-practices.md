# MCP (Model Context Protocol) Best Practices

## Overview

Model Context Protocol (MCP) enables Claude to interact with external tools and services. This guide covers best practices for working with MCP tools, especially when using context-aware systems.

## Version Management

### Always Check Tool Versions

When working with MCP tools, especially in context-aware environments:

1. **Query Installed Version First**
   ```bash
   # Example: Check tool version
   tool --version
   npm list @modelcontextprotocol/server-name
   pip show package-name
   ```

2. **Request Version-Specific Documentation**
   - Don't assume the latest documentation applies
   - Look for version-specific docs or changelogs
   - Check for breaking changes between versions

3. **Version Compatibility Matrix**
   ```yaml
   # Document in your project
   mcp_tools:
     - name: "tool-name"
       installed_version: "1.2.3"
       documentation_url: "https://docs.example.com/v1.2.3"
       known_issues: ["issue-1", "issue-2"]
   ```

## Context-Aware Best Practices

### When Using Context Systems (e.g., context7)

1. **Always Verify Tool Availability**
   ```bash
   # Check if MCP tool is available
   mcp list-tools
   # or context-specific command
   context7 list-available-tools
   ```

2. **Check Tool Capabilities**
   - Different versions may have different features
   - Verify required functions exist
   - Test edge cases for version-specific behavior

3. **Document Version Dependencies**
   ```markdown
   ## MCP Tool Requirements
   - Tool A: v2.1.0+ (uses feature X)
   - Tool B: v1.5.0 exactly (v1.6.0 has breaking changes)
   - Tool C: any version (basic functionality only)
   ```

## Tool Integration

### Before Using Any MCP Tool

1. **Verification Checklist**
   - [ ] Check if tool is installed
   - [ ] Verify tool version
   - [ ] Confirm version compatibility
   - [ ] Review version-specific documentation
   - [ ] Test basic functionality

2. **Version Detection Pattern**
   ```javascript
   // Example pattern for version checking
   async function checkToolVersion(toolName) {
     try {
       const version = await getToolVersion(toolName);
       const docs = await getVersionSpecificDocs(toolName, version);
       return { version, docs };
     } catch (error) {
       console.error(`Tool ${toolName} version check failed:`, error);
       return null;
     }
   }
   ```

### Tool-Specific Configuration

1. **Create Version-Aware Configs**
   ```yaml
   # .claude/config/mcp-tools.yaml
   tools:
     jira:
       min_version: "2.0.0"
       preferred_version: "2.3.1"
       features:
         - basic_operations: "1.0.0+"
         - advanced_search: "2.0.0+"
         - bulk_operations: "2.2.0+"
   ```

2. **Fallback Strategies**
   - Define behavior when preferred version isn't available
   - Document alternative approaches for older versions
   - Set up graceful degradation

## Documentation Strategy

### Version-Specific Documentation

1. **Documentation Structure**
   ```
   docs/mcp-tools/
   ├── tool-a/
   │   ├── v1.0.0.md
   │   ├── v2.0.0.md
   │   └── migration-guide.md
   └── tool-b/
       ├── stable.md
       └── changelog.md
   ```

2. **Version Mapping**
   ```markdown
   ## Tool Version → Documentation Map
   
   | Tool | Version | Documentation | Notes |
   |------|---------|--------------|-------|
   | Tool A | 1.x | [Link to v1 docs] | Legacy support |
   | Tool A | 2.x | [Link to v2 docs] | Current |
   | Tool B | * | [Link to docs] | Version-agnostic |
   ```

## Error Handling

### Version-Related Errors

1. **Common Issues**
   - Function not found (version too old)
   - Parameter mismatch (API changed)
   - Missing dependencies (version requirements)

2. **Error Messages**
   ```javascript
   // Provide clear version-related error messages
   if (toolVersion < requiredVersion) {
     throw new Error(
       `Tool version ${toolVersion} is below minimum required ${requiredVersion}. ` +
       `Please upgrade or refer to legacy documentation.`
     );
   }
   ```

## Testing with MCP Tools

### Version-Aware Testing

1. **Test Matrix**
   ```yaml
   test_matrix:
     - tool_version: "1.0.0"
       expected_behavior: "legacy mode"
     - tool_version: "2.0.0"
       expected_behavior: "standard mode"
     - tool_version: "latest"
       expected_behavior: "full features"
   ```

2. **Mock Different Versions**
   - Create mocks for different tool versions
   - Test graceful degradation
   - Verify fallback behaviors

## Security Considerations

### Version-Specific Security

1. **Security Updates**
   - Track security patches for each tool
   - Document minimum secure versions
   - Set up alerts for security updates

2. **Permission Changes**
   - Different versions may require different permissions
   - Document permission requirements per version
   - Test permission boundaries

## Best Practices Summary

### DO:
- ✅ Always check tool version before use
- ✅ Request version-specific documentation
- ✅ Document version dependencies clearly
- ✅ Test with multiple tool versions
- ✅ Plan for version upgrades/downgrades
- ✅ Create version compatibility matrix

### DON'T:
- ❌ Assume latest documentation applies to installed version
- ❌ Hard-code version-specific behavior without checks
- ❌ Ignore version compatibility warnings
- ❌ Use deprecated features without fallbacks
- ❌ Skip version verification in production

## Quick Reference

### Version Check Commands

```bash
# NPM-based MCP tools
npm list @modelcontextprotocol/server-*

# Python-based MCP tools
pip list | grep mcp

# System tools
which tool-name && tool-name --version

# Context-specific
context7 tool-info [tool-name]
```

### Version Documentation Pattern

```markdown
When documenting MCP tool usage:
1. Tool Name: [name]
2. Installed Version: [version]
3. Documentation URL: [version-specific URL]
4. Known Limitations: [list]
5. Upgrade Path: [if applicable]
```

## Troubleshooting

### Common Version Issues

1. **"Function not found"**
   - Check if function exists in installed version
   - Review version-specific API documentation
   - Consider upgrading or using alternative

2. **"Invalid parameters"**
   - API may have changed between versions
   - Check parameter names and types
   - Review migration guides

3. **"Tool not available"**
   - Verify tool is installed
   - Check context configuration
   - Confirm tool is enabled for current context

## Resources

- [MCP Official Documentation](https://modelcontextprotocol.io)
- [Version Compatibility Guide](link-to-guide)
- [Tool-Specific Documentation](link-to-index)
- [Security Advisories](link-to-security)

---

Remember: When in doubt, check the version first and consult version-specific documentation. This prevents errors and ensures you're using tools correctly for the installed version.