<!-- PROJECT LOGO -->
<p align="center">
  <a href="https://dyte.io">
    <img src="https://dyte-uploads.s3.ap-south-1.amazonaws.com/dyte-logo-dark.svg" alt="Logo" width="80">
  </a>

  <h2 align="center">iOS sample app (using Objective-C) by dyte</h3>

  <p align="center">
    Sample app to demonstrate the usage of Dyte iOS SDK
    <br />
    <a href="https://docs.dyte.io"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://app.dyte.io">View Demo</a>
    ·
    <a href="https://github.com/dyte-in/obj-c-sample-app/issues">Report Bug</a>
    ·
    <a href="https://github.com/dyte-in/obj-c-sample-app/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [About the Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Version History](#version-history)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)
- [About](#about)

<!-- ABOUT THE PROJECT -->

## About The Project

![App Screen Shot 1](./screenshot-1.png "Sample App Screen Shot 1")
![App Screen Shot 2](./screenshot-2.png "Sample App Screen Shot 2")
![App Screen Shot 3](./screenshot-3.png "Sample App Screen Shot 3")
![App Screen Shot 4](./screenshot-4.png "Sample App Screen Shot 4")
![App Screen Shot 5](./screenshot-5.png "Sample App Screen Shot 5")

### Built With

- [Dyte iOS SDK](https://docs.dyte.io/ios/installation)
- [Xcode](https://developer.apple.com/xcode/)
- [Cocoapods](https://cocoapods.org)
- [Alamofire](https://alamofire.github.io/Alamofire/)
- :heart:

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

- Xcode
- Cocoapods (follow official guide [here](https://guides.cocoapods.org/using/getting-started.html))
  ```sh
  sudo gem install cocoapods
  ```
- A working backend that can connect to Dyte APIs
  - This app currently connects to our sample backend implementation (https://github.com/dyte-in/sample-app-backend), currently hosted at https://dyte-sample.herokuapp.com - this can be grepped and replaced if you want it to work with your own backend implementation

### Installation

1. Clone the repo

   ```sh
   git clone https://github.com/dyte-in/obj-c-sample-app.git
   ```

2. Install Pods

   ```sh
   cd Dyte\ Obj-C\ Sample/
   pod install
   ```

3. Open `Dyte Obj-C Sample.xcworkspace` using Xcode

   ```sh
   open Dyte\ Obj-C\ Sample.xcworkspace
   ```

4. Run in simulator by pressing `⌘+R` or selecting `Run` from `Product` menu in Xcode.

5. To run on a real device, you would need to connect your device while Xcode is open. A prompt will appear on your device to trust the computer, and on accepting that Xcode would detect your device. After a few moments of wait, during which Xcode prepares your device to accept development builds, you would be able to see your device at the top of the list in the target device list in Xcode.

<!-- CHANGELOG -->

## Version History

See [CHANGELOG](./CHANGELOG.md).

<!-- ROADMAP -->

## Roadmap

See the [open issues](https://github.com/dyte-in/obj-c-sample-app/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. Sincere thanks to all [our contributors](Thank you, [contributors](https://github.com/dyte-in/obj-c-sample-app/graphs/contributors)!)!

You are requested to follow the contribution guidelines specified in [CONTRIBUTING.md](./CONTRIBUTING.md) and code of conduct at [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) while contributing to the project :smile:.

## Support

Contributions, issues, and feature requests are welcome!
Give a ⭐️ if you like this project!

<!-- LICENSE -->

## License

Distributed under the Apache License, Version 2.0. See [`LICENSE`](./LICENSE) for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

## About

`obj-c-sample-app` is created & maintained by Dyte, Inc. You can find us on Twitter - [@dyte_io](twitter.com/dyte_io) or write to us at `dev [at] dyte.io`.

The names and logos for Dyte are trademarks of Dyte, Inc.

We love open source software! See [our other projects](https://github.com/dyte-in) and [our products](https://dyte.io).
