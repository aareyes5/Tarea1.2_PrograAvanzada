# TOTP 2FA Authentication Implementation

## Overview
This implementation adds Time-based One-Time Password (TOTP) two-factor authentication to the Flutter login system.

## What was implemented

### 1. TOTP Library
- Added `otp: ^3.1.4` package to `pubspec.yaml` for TOTP generation and verification

### 2. Authentication Logic (`lib/logica/logica_login.dart`)
- Created `Usuario` class with optional `totpSecret` field
- Implemented `AutenticacionLogin` class with:
  - User loading from JSON
  - Password-based login
  - TOTP requirement checking
  - TOTP code verification

### 3. User Data (`assets/datos/usuarios.json`)
- Added user `kings952` with TOTP secret: `NCQCGW276RXWI5AN`
- Password: `github123`
- Users without `totpSecret` field can log in without 2FA

### 4. Login UI (`lib/pages/login.dart`)
- Implemented two-step authentication flow:
  1. Username and password entry
  2. TOTP code entry (if user has TOTP enabled)
- Added TOTP input field with 6-digit numeric keyboard
- Added "Back" button to return from TOTP screen

### 5. Tests (`test/totp_test.dart`)
- Unit tests for TOTP verification with correct/incorrect codes
- Tests for users with and without TOTP enabled

## How to use

### For users with TOTP enabled:
1. Enter username: `kings952`
2. Enter password: `github123`
3. Click "Iniciar Sesión"
4. The system will show the 2FA screen
5. Open your authenticator app (Google Authenticator, Authy, etc.) and scan the QR code generated from:
   ```
   otpauth://totp/GitHub:kings952?secret=NCQCGW276RXWI5AN&issuer=GitHub
   ```
6. Enter the 6-digit code from your authenticator app
7. Click "Verificar"

### For users without TOTP:
- Simply enter username and password (e.g., `admin`/`admin`)
- Click "Iniciar Sesión" and proceed directly to home

## Testing
Run the TOTP tests:
```bash
flutter test test/totp_test.dart
```

## TOTP Configuration
The TOTP implementation uses:
- **Algorithm**: SHA1
- **Code length**: 6 digits
- **Time step**: 30 seconds
- **Compatible with**: Google Authenticator, Authy, Microsoft Authenticator, etc.

## Security Notes
- TOTP secrets are stored in plain text in the JSON file (for demo purposes only)
- In production, secrets should be encrypted and stored securely
- The secret `NCQCGW276RXWI5AN` is from the problem statement
