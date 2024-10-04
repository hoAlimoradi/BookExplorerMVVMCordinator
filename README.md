# BookExplorer
# Book Explorer MVVM Cordinator

A simple iOS application to explore, search, and view book details. This project demonstrates the use of MVVM architecture combined with a Coordinator for navigation flow. It also features reactive programming with Combine, efficient data handling using Realm for caching, and modern UICollectionView layouts for smooth and responsive UI.

## Features

- **MVVM Architecture**: Ensures a clean separation of concerns.
- **Combine Framework**: Utilized for data binding and reactive programming.
- **Compositional Layout**: Provides a modern and flexible layout for displaying bookes.
- **Pagination & Infinite Scrolling**: Supports efficient loading and displaying of large data sets.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Getting Started

To run the project locally and explore its functionalities:

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or physical device.
   
## Project Structure
Certainly! Here's an improved and detailed README structure using Markdown, focusing on project modularization, Realm integration for caching, and using Realm for storing favorite items instead of JSON files:
 
## Modules and Features

### Coordinator

Handles navigation flow between different screens or modules in the application.

### Core

Contains foundational classes and utilities used across various modules. Includes base classes like `BaseViewController`, common scenarios like `GeneralScenario`, and utilities such as `HTTPStatusCode`.

### DependencyFactory

Responsible for creating and providing dependencies throughout the application, ensuring loose coupling and facilitating easier testing.

### Modules

#### CommonAPI

Contains utilities for common error handling and extensions used universally across the application.

#### DataBaseAPI

Manages interactions with a local database using Realm:
- **Realm Integration**: Implements Realm to store and manage cached data.
- **Caching**: Stores fetched data locally to improve performance and offline usability.

#### LoggingAPI

Custom logging utilities for debugging and monitoring application events:
- **Logging**: Logs events and errors to aid in troubleshooting and performance monitoring.

#### SharedUI

Central repository for shared UI components and resources:
- **Components**: Reusable UI elements like buttons, views, and custom controls.
- **Constants**: Centralizes strings, dimensions, fonts, and themes used throughout the app for consistency.
- **Extensions**: Enhances UIKit and Foundation classes with additional functionality.

#### DataModelAPI

Defines shared data models used throughout the application:
- **Models**: Structured data representations used for serialization and deserialization.
- **Serialization**: Handles data conversion between JSON and Swift objects.

#### SearchAPI

Manages domain-specific operations related to fetching and managing book data:
- **Network Integration**: Retrieves book data from remote APIs using URLSession.
- **Data Management**: Syncs data between local Realm storage and remote sources.

#### NetworkAPI

Provides services for making API calls and handling network-related functionalities:
- **HTTP Requests**: Sends HTTP requests to external APIs and manages responses.
- **Error Handling**: Manages authentication errors, network reachability, and HTTP status codes.

#### UserDefaultsAPI

Manages persistent storage of application settings and preferences using UserDefaults:
- **Settings Storage**: Stores user-specific preferences and configuration settings.
- **User Defaults**: Ensures data persistence across app bookes.

## Remaining Work

### Integration of Realm for Caching

- Implement Realm across modules to store and manage cached data.
- Utilize Realm's object-oriented database features for efficient data handling and synchronization.

### Storing Favorite Items in Realm

- Replace JSON file storage with Realm for storing favorite items:
  - **Schema Definition**: Define Realm schema for storing favorite items.
  - **CRUD Operations**: Implement operations for adding, updating, deleting, and querying favorite items.

### Project Modularization

- Further modularize the project to enhance code separation and maintainability:
  - **Module Refactoring**: Refactor existing modules into smaller, reusable components.
  - **Dependency Injection**: Implement dependency injection patterns to decouple components and improve testability.
 
## Contributing

Contributions are welcome! Please fork the repository, make your changes, and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE.md) - see the LICENSE.md file for details.
