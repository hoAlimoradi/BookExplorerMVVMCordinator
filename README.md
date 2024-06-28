# SpaceX
# SpaceX Launches Viewer

A simple iOS application to view SpaceX launches using the SpaceX API. This project demonstrates the use of MVVM architecture, Combine for reactive programming, and compositional layout for modern UICollectionView layouts. It supports pagination and infinite scrolling to efficiently load and display SpaceX launches.

## Features

- **MVVM Architecture**: Ensures a clean separation of concerns.
- **Combine Framework**: Utilized for data binding and reactive programming.
- **Compositional Layout**: Provides a modern and flexible layout for displaying launches.
- **Pagination & Infinite Scrolling**: Supports efficient loading and displaying of large data sets.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/hoalimoradi/spacex-launches-viewer.git
    ```

2. Open the project in Xcode:
    ```sh
    cd spacex-launches-viewer
    open SpaceXLaunchesViewer.xcodeproj
    ```

3. Build and run the project on your desired simulator or device.

## Usage

1. Launch the application.
2. The app will fetch and display a list of SpaceX launches.
3. Scroll to the bottom of the list to load more launches (infinite scrolling).

## Project Structure

- **Model**: Defines the `Launch` struct based on the SpaceX API.
- **Service**: Contains `SpaceXService` class responsible for making API calls.
- **ViewModel**: Includes `LaunchesViewModel` class that handles data fetching and state management.
- **View**: Contains `LaunchesViewController` which sets up the UI and binds to the ViewModel.

## Screenshots

![Launch List](screenshots/launch_list.png)
![Launch Detail](screenshots/launch_detail.png)

## Contributing

Contributions are welcome! Please create a pull request or open an issue to discuss your ideas.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
