# Relay SDK Usage Guide

Complete API documentation for integrating ChatGPT functionality into your macOS applications using the Relay SDK.

## Table of Contents

- [Getting Started](#getting-started)
- [OpenAI Client](#openai-client)
- [Conversation Management](#conversation-management)
- [Models](#models)
- [Data Types](#data-types)
- [Error Handling](#error-handling)
- [Authentication](#authentication)
- [Examples](#examples)

## Getting Started

### Import

```swift
import Relay
```

## OpenAI Client

The `OpenAIClient` is your main interface for interacting with ChatGPT.

### Initialization

```swift
// Initialize with your Relay API key
let client = Relay.OpenAI(apiKey: "your-relay-api-key-here", autoInitialize: true)

// Alternative syntax
let client2 = OpenAIClient(apiKey: "your-relay-api-key-here", autoInitialize: true)

// Initialize without automatic setup (you'll need to call methods to trigger initialization)
let client3 = OpenAIClient(apiKey: "your-relay-api-key-here", autoInitialize: false)
```

**Note:** You need a valid Relay API key to use the SDK. The API key is used to authenticate with the Relay backend service which provides secure access to the integration.

### Authentication Status

Check if the client is authenticated:

```swift
if client.isAuthenticated {
    // User is logged in to ChatGPT
    print("Ready to send messages")
} else {
    // User needs to authenticate - will happen automatically when calling API methods
    print("Authentication required - will show login when needed")
}
```

## Conversation Management

### Sending Messages

Send messages to ChatGPT and receive streaming responses:

```swift
// Create a stream handler
class MyHandler: ConversationStreamHandler {
    func onConversationComplete(_ conversation: ConversationDetailResponse) {
        print("Conversation completed: \(conversation.title)")
        print("Messages: \(conversation.messages.count)")
    }

    func onError(_ error: Error) {
        print("Error: \(error)")
    }
}

// Send a message
let handler = MyHandler()
client.sendConversation(
    message: "Hello, how are you?",
    conversationId: nil,  // nil for new conversation
    model: "auto",        // or specific model like "gpt-4"
    handler: handler
)
```

### Continuing Conversations

```swift
// Continue an existing conversation
client.sendConversation(
    message: "Can you elaborate on that?",
    conversationId: "existing-conversation-id",
    model: "auto",
    handler: handler
)
```

### Getting Conversation History

Retrieve the user's conversation history:

```swift
client.getConversationHistory(
    offset: 0,
    limit: 20
) { result in
    switch result {
    case .success(let history):
        print("Found \(history.items.count) conversations")
        for conversation in history.items {
            print("- \(conversation.title) (ID: \(conversation.id))")
        }
    case .failure(let error):
        print("Error fetching history: \(error)")
    }
}
```

### Getting Specific Conversations

Retrieve a specific conversation by ID:

```swift
client.getConversationById("conversation-id") { result in
    switch result {
    case .success(let conversation):
        print("Conversation: \(conversation.title)")
        print("Messages: \(conversation.messages.count)")
        for message in conversation.messages {
            let role = message.author.role
            let content = message.content.parts.joined(separator: "\n")
            print("\(role): \(content)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## Models

Get available OpenAI models:

```swift
client.getModels { result in
    switch result {
    case .success(let models):
        print("Available models:")
        for model in models.models {
            print("- \(model.title) (\(model.slug))")
            print("  Max tokens: \(model.maxTokens)")
            print("  Description: \(model.description)")
        }
    case .failure(let error):
        print("Error fetching models: \(error)")
    }
}
```

## Data Types

### ConversationHistoryResponse

```swift
struct ConversationHistoryResponse {
    let items: [ConversationItem]  // Array of conversations
    let total: Int                 // Total number of conversations
    let limit: Int                 // Requested limit
    let offset: Int                // Requested offset
}
```

### ConversationItem

```swift
struct ConversationItem {
    let id: String           // Conversation ID
    let title: String        // Conversation title
    let createdTime: Date    // When conversation was created
}
```

### ConversationDetailResponse

```swift
struct ConversationDetailResponse {
    let id: String                      // Conversation ID
    let title: String                   // Conversation title
    let messages: [ConversationMessage] // All messages in conversation
    let createdTime: Date              // When conversation was created
    let updatedTime: Date?             // When last updated
}
```

### ConversationMessage

```swift
struct ConversationMessage {
    let id: String              // Message ID
    let author: MessageAuthor   // Message author (user/assistant)
    let createTime: TimeInterval // When message was created
    let content: MessageContent // Message content
    let metadata: MessageMetadata // Additional metadata
}
```

### MessageAuthor

```swift
struct MessageAuthor {
    let role: String  // "user" or "assistant"
}
```

### MessageContent

```swift
struct MessageContent {
    let contentType: String  // Usually "text"
    let parts: [String]      // Array of content parts
}
```

### ModelsResponse

```swift
struct ModelsResponse {
    let models: [ModelItem]  // Available models
}
```

### ModelItem

```swift
struct ModelItem {
    let slug: String                     // Model identifier (e.g., "gpt-4")
    let maxTokens: Int                  // Maximum tokens
    let title: String                   // Human-readable name
    let description: String             // Model description
    let tags: [String]                  // Model tags
    let capabilities: [String: Any]     // Model capabilities
    let productFeatures: [String: Any]  // Product features
    let enabledTools: [String]?         // Available tools
}
```

## Error Handling

### Common Errors

```swift
public enum RelayError: Error {
    case notInitialized     // Client not properly initialized
    case providerNotFound   // Provider not available
}
```

### Handling Authentication Errors

```swift
client.sendConversation(message: "Hello", conversationId: nil, model: "auto", handler: handler)

// If user is not authenticated, the WebView will automatically show
// Handle this in your stream handler:
class MyHandler: ConversationStreamHandler {
    func onError(_ error: Error) {
        if error.localizedDescription.contains("401") {
            // Authentication required - WebView will show login screen
            print("Please log in to ChatGPT")
        } else {
            print("Other error: \(error)")
        }
    }
}
```

## Authentication

### How Authentication Works

1. **Automatic**: When you call any API method, Relay automatically handles authentication
2. **WebView**: If not authenticated, a WebView window opens showing the ChatGPT login page
3. **Token Extraction**: Once logged in, Relay extracts authentication tokens automatically
4. **Persistent**: Authentication persists across app launches

## Examples

### Complete Chat Application

```swift
import Relay

class ChatApp {
    private let client = OpenAIClient(autoInitialize: true)
    private var currentConversationId: String?

    func sendMessage(_ message: String) {
        let handler = ChatHandler { [weak self] conversation in
            // Update UI with complete conversation
            self?.updateUI(with: conversation)
        }

        client.sendConversation(
            message: message,
            conversationId: currentConversationId,
            model: "auto",
            handler: handler
        )
    }

    func loadConversations() {
        client.getConversationHistory(offset: 0, limit: 50) { result in
            switch result {
            case .success(let history):
                self.displayConversations(history.items)
            case .failure(let error):
                print("Failed to load conversations: \(error)")
            }
        }
    }

    private func updateUI(with conversation: ConversationDetailResponse) {
        DispatchQueue.main.async {
            self.currentConversationId = conversation.id
            // Update your UI with conversation.messages
        }
    }

    private func displayConversations(_ conversations: [ConversationItem]) {
        DispatchQueue.main.async {
            // Update your conversations list UI
        }
    }
}

class ChatHandler: ConversationStreamHandler {
    private let onComplete: (ConversationDetailResponse) -> Void

    init(onComplete: @escaping (ConversationDetailResponse) -> Void) {
        self.onComplete = onComplete
    }

    func onConversationComplete(_ conversation: ConversationDetailResponse) {
        onComplete(conversation)
    }

    func onError(_ error: Error) {
        print("Chat error: \(error)")
    }
}
```

### Model Selection

```swift
func selectModel() {
    client.getModels { result in
        switch result {
        case .success(let modelsResponse):
            let availableModels = modelsResponse.models

            // Find GPT-4 model
            if let gpt4 = availableModels.first(where: { $0.slug.contains("gpt-4") }) {
                print("Using GPT-4: \(gpt4.title)")
                self.sendWithModel(gpt4.slug)
            } else {
                print("GPT-4 not available, using auto")
                self.sendWithModel("auto")
            }

        case .failure(let error):
            print("Failed to get models: \(error)")
        }
    }
}

func sendWithModel(_ modelSlug: String) {
    client.sendConversation(
        message: "Hello!",
        conversationId: nil,
        model: modelSlug,
        handler: ChatHandler { conversation in
            print("Response received using model: \(modelSlug)")
        }
    )
}
```

### Conversation Management

```swift
func manageConversations() {
    // Get recent conversations
    client.getConversationHistory(offset: 0, limit: 10) { result in
        switch result {
        case .success(let history):
            for item in history.items {
                print("Conversation: \(item.title)")

                // Get full conversation details
                self.client.getConversationById(item.id) { detailResult in
                    switch detailResult {
                    case .success(let detail):
                        print("Messages in \(detail.title): \(detail.messages.count)")

                        // Continue this conversation
                        self.client.sendConversation(
                            message: "Please continue our previous discussion",
                            conversationId: detail.id,
                            model: "auto",
                            handler: ChatHandler { updatedConversation in
                                print("Continued conversation: \(updatedConversation.title)")
                            }
                        )

                    case .failure(let error):
                        print("Failed to load conversation details: \(error)")
                    }
                }
            }
        case .failure(let error):
            print("Failed to load conversation history: \(error)")
        }
    }
}
```

## Best Practices

1. **Always implement ConversationStreamHandler**: Handle both success and error cases
2. **Check authentication status**: Before making API calls, check `client.isAuthenticated`
3. **Handle UI updates on main thread**: All UI updates should be dispatched to the main queue
4. **Manage conversation IDs**: Store conversation IDs to continue conversations
5. **Error handling**: Implement proper error handling for network and authentication issues
6. **Resource management**: Keep references to your handlers to prevent deallocation

## Troubleshooting

### Common Issues

- **Authentication loops**: If authentication keeps failing, clear ChatGPT cookies or log out manually
- **WebView not showing**: Authentication WebView will show automatically when needed
- **Messages not sending**: Check internet connection and authentication status
- **Memory leaks**: Ensure ConversationStreamHandler instances are properly managed

### Debug Mode

Enable debug mode to see WebView windows and console logs:

```swift
// Enable debug mode
Relay.shared.isDebugView = true

// This will keep WebView windows visible for debugging
let client = OpenAIClient(autoInitialize: true)
```

### Show/Hide Debug Window

Manually control the visibility of the WebView window:

```swift
// Show the WebView window
client.showWindow()

// Hide the WebView window
client.hideWindow()

// Toggle debug mode to keep window visible even when authenticated
Relay.shared.isDebugView = true
```
