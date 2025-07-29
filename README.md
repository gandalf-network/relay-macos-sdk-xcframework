# Relay SDK

A Swift SDK for macOS that provides seamless integration with LLMs.

## 🚀 Quick Start

### Prerequisites

- macOS 12.0+
- Swift 6.0+
- Xcode 15.0+
- A valid Relay API key (contact the library maintainer to obtain one)

### Installation

### Method 1: Swift Package Manager (Recommended)

The easiest way to integrate Relay SDK is through Swift Package Manager.

#### For Xcode Projects:

1. **Open your Xcode project**
2. **Add the package dependency:**
   - Go to `File` → `Add Package Dependencies...`
   - Enter the repository URL: `https://github.com/gandalf-network/relay-macos-sdk-xcframework`
   - Click `Add Package`
   - Select your target and click `Add Package`

#### For Swift Package Manager Projects:

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/relay-macos-sdk", from: "1.0.0")
],
targets: [
    .executableTarget(
        name: "YourApp",
        dependencies: ["Relay"]
    )
]
```

### Method 2: Direct Framework Integration

If you prefer to integrate the framework directly or need offline access:

#### Step 1: Download the Framework

1. **Download the latest release:**
   - Go to the [Releases page](https://github.com/gandalf-network/relay-macos-sdk-xcframework/releases)
   - Download `Relay.framework.zip` for the latest version

2. **Extract the framework:**

   ```bash
   unzip Relay.framework.zip
   ```

#### Step 2: Add to Your Xcode Project

1. **Open your Xcode project**

2. **Add the framework:**
   - Right-click in the Project Navigator
   - Select `Add Files to [YourProject]`
   - Navigate to the extracted `Relay.framework` folder
   - Select the framework and click `Add`
   - Ensure "Add to target" is checked for your app target

3. **Link the framework:**
   - Select your app target in the project navigator
   - Go to the `General` tab
   - Scroll down to `Frameworks, Libraries, and Embedded Content`
   - Click the `+` button
   - Select `Relay.framework` from the list
   - Set the embedding to `Embed & Sign`

4. **Configure build settings:**
   - Select your app target
   - Go to `Build Settings`
   - Search for `Framework Search Paths`
   - Add `$(PROJECT_DIR)` to the search paths

### Verification

After installation, verify the setup:

1. **Build your project** (`⌘+B`)
2. **Check for any build errors**
3. **Run the app** to ensure it launches without crashes

### Troubleshooting

**Common Issues:**

- **"Framework not found"**: Ensure the framework is added to your target's linked frameworks
- **"Library not loaded"**: Make sure the framework is embedded, not just linked
- **Build errors**: Verify you're using Xcode 15+ and Swift 6.0+

**Need help?** Check the [Issues page](https://github.com/your-org/relay-macos-sdk/issues) or create a new issue.

### Basic Usage

```swift
import Relay

// Create OpenAI client with your API key
let openAIClient = Relay.OpenAI(apiKey: "your-relay-api-key-here", autoInitialize: true)

// Send a message
let handler = MyStreamHandler() // Your ConversationStreamHandler implementation
openAIClient.sendConversation(
    message: "Hello, how are you?",
    conversationId: nil,
    model: "auto",
    handler: handler
)
```
