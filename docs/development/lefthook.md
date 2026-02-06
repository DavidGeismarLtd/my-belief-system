# Lefthook - Automatic Linting & Testing

This project uses [Lefthook](https://github.com/evilmartians/lefthook) to automatically lint and test code before commits and pushes.

## What is Lefthook?

Lefthook is a fast Git hooks manager that runs tasks automatically at different stages of your Git workflow.

## What Happens Automatically?

### On Every Commit (`pre-commit`)

**RuboCop Auto-Linting:**
- Runs RuboCop on all staged `.rb` files
- **Automatically fixes** style violations with `--autocorrect`
- **Stages the fixed files** automatically
- If there are unfixable violations, the commit is blocked

**Example:**
```bash
git add app/models/user.rb
git commit -m "Add user model"

# Lefthook runs:
# ✓ Running RuboCop on app/models/user.rb
# ✓ Auto-fixed 3 violations
# ✓ Staged fixed files
# ✓ Commit proceeds
```

### On Every Push (`pre-push`)

**Full Test Suite:**
- Runs `bundle exec rspec` before pushing
- If tests fail, the push is blocked
- Ensures you never push broken code

## Setup (For New Team Members)

After cloning the repo and running `bundle install`:

```bash
bundle exec lefthook install
```

This installs the Git hooks. You only need to do this once per clone.

## Configuration

The configuration is in `lefthook.yml` at the project root.

### Current Configuration

```yaml
pre-commit:
  parallel: true
  commands:
    rubocop:
      glob: "*.rb"
      run: bundle exec rubocop --autocorrect {staged_files}
      stage_fixed: true

pre-push:
  commands:
    tests:
      run: bundle exec rspec
```

## Skipping Hooks (When Needed)

### Skip Pre-Commit Hook

```bash
git commit --no-verify -m "WIP: temporary commit"
# or
LEFTHOOK=0 git commit -m "Skip all hooks"
```

### Skip Pre-Push Hook

```bash
git push --no-verify
# or
LEFTHOOK=0 git push
```

### Skip Specific Command

```bash
LEFTHOOK_EXCLUDE=rubocop git commit -m "Skip RuboCop only"
LEFTHOOK_EXCLUDE=tests git push
```

## Troubleshooting

### Hooks Not Running

```bash
# Reinstall hooks
bundle exec lefthook install
```

### Check Hook Status

```bash
# See which hooks are installed
bundle exec lefthook run --help
```

### Uninstall Hooks

```bash
bundle exec lefthook uninstall
```

## Benefits

✅ **Consistent Code Style** - Everyone's code is auto-formatted before commit
✅ **Catch Errors Early** - Tests run before push, preventing broken builds
✅ **No Manual Linting** - RuboCop runs automatically, no need to remember
✅ **Fast** - Only lints changed files, not entire codebase
✅ **Auto-Fix** - Most style violations are fixed automatically
✅ **Team Consistency** - Same hooks for everyone via `lefthook.yml`

## Customization

To modify what runs on commit/push, edit `lefthook.yml` and commit the changes. All team members will get the updated hooks on their next `git pull` + `bundle exec lefthook install`.

## Learn More

- [Lefthook Documentation](https://github.com/evilmartians/lefthook/blob/master/docs/usage.md)
- [RuboCop Documentation](https://docs.rubocop.org/)

