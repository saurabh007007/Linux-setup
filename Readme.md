# Mac Developer Setup Script

This is a simple script that sets up all the required things for your Mac developer setup.

## What it does

- Installs and configures core development tools.
- Uses package lists from:
  - `common/applist.txt`
  - `common/casklist.txt`
- Helps you quickly prepare a fresh Mac for development.

## Files

- `setup.sh` - Main setup script
- `common/applist.txt` - CLI apps to install
- `common/casklist.txt` - GUI apps to install

## How to run

```bash
chmod +x setup.sh
./setup.sh
```

## Notes

- Run this on macOS.
- Review the app lists before running if you want to customize what gets installed.
