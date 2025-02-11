# Locksy - Password Manager

Locksy is a cross-platform password manager built using Flutter, designed to securely store and manage your passwords. With strong encryption and seamless compatibility across devices, Locksy ensures your sensitive data is always protected.

## Features

- **Cross-Platform Compatibility**: Works on Android, iOS, Windows, macOS, and Linux.  
- **Secure Storage**: Uses strong encryption to protect your passwords.  
- **User-Friendly Interface**: Intuitive and clean design for managing your passwords effortlessly.  
- **Lightweight and Fast**: Built with Flutter for optimal performance.  
- **Local Data Storage**: No data is sent to the cloud, ensuring privacy.

## Screenshots

![Screenshot_2025-02-11-17-05-41-168_com locksy com locksy](https://github.com/user-attachments/assets/dbd0fce0-373a-4da3-89e7-e8ceea5b44a7)
![Screenshot_2025-02-11-17-07-17-532_com locksy com locksy](https://github.com/user-attachments/assets/74df64a9-c70d-45a7-ae5b-66527ee81e88)
![Screenshot_2025-02-11-17-07-04-387_com locksy com locksy](https://github.com/user-attachments/assets/f814c25a-12e2-4109-b39a-acbfbe37ada3)
![Screenshot_2025-02-11-17-08-07-113_com locksy com locksy](https://github.com/user-attachments/assets/6aa65cd7-0a3b-482b-b3a4-b9bb906e4a9b)
![Screenshot_2025-02-11-17-08-13-224_com locksy com locksy](https://github.com/user-attachments/assets/27e16397-5205-4fee-ae58-c1c1add9445d)

## Dependencies

Locksy utilizes the following Flutter packages:

1. **[crypto](https://pub.dev/packages/crypto) (v3.0.6)**  
   - Provides hashing and other cryptographic utilities.  

2. **[shared_preferences](https://pub.dev/packages/shared_preferences) (v2.3.4)**  
   - Allows storing and retrieving persistent data on the device.  

3. **[encrypt](https://pub.dev/packages/encrypt) (v5.0.3)**  
   - Implements AES encryption to secure sensitive information.  

4. **[uuid](https://pub.dev/packages/uuid) (v4.5.1)**  
   - Generates unique identifiers for managing stored passwords.  

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/GurnishS/Locksy.git
   cd locksy
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

> Ensure you have Flutter installed and properly set up. For installation instructions, visit the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

## Usage

1. Launch Locksy on your device.  
2. Add a new master password.  
3. Securely store your passwords with labels for easy identification.  
4. Edit or delete stored passwords as needed.  

## Security

Locksy ensures your passwords are encrypted before being stored locally. The app does not store or send your data to any external servers, making it a highly secure choice for password management.

## Contributing

Contributions are welcome!

1. Fork the repository.  
2. Create a feature branch:  
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:  
   ```bash
   git commit -m "Add feature-name"
   ```
4. Push to the branch:  
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.  

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

