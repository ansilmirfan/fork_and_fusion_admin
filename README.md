# Fork & Fusion Admin

Fork & Fusion Admin is the backend management system for the Fork & Fusion application, providing administrators with tools to manage categories, products, orders, and essential business operations efficiently.

## Features

- **Product & Category Management**: Seamless addition, modification, and deletion of products and categories using Firestore.
- **Image Upload & Storage**: Store and retrieve images and documents efficiently via Firebase Storage.
- **Data Visualization**: Interactive graphs and analytics using fl_chart for insightful business metrics.
- **PDF Generation & Printing**: Create and print qrcode or for the tables with the printing package.
- **Secure Data Storage**: Protect sensitive admin credentials with flutter_secure_storage.
- **QR Code Generation**: Generate QR codes for each tabels.

## Dependencies

This application utilizes the following key Flutter packages:

| Package                                                                   | Purpose                                     |
| ------------------------------------------------------------------------- | ------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)                   | Core Firebase integration                   |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore)               | Firestore database operations               |
| [firebase_storage](https://pub.dev/packages/firebase_storage)             | Image & document storage                    |
| [flutter_bloc](https://pub.dev/packages/flutter_bloc)                     | State management using BLoC pattern         |
| [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | Secure storage for sensitive admin data     |
| [image_picker](https://pub.dev/packages/image_picker)                     | Selecting images from the device            |
| [image_cropper](https://pub.dev/packages/image_cropper)                   | Cropping and editing selected images        |
| [printing](https://pub.dev/packages/printing)                             | PDF generation and printing functionalities |
| [qr_flutter](https://pub.dev/packages/qr_flutter)                         | Creating QR codes for various use cases     |
| [fl_chart](https://pub.dev/packages/fl_chart)                             | Displaying graphs and charts                |

## User Side Application

The user-side application of Fork & Fusion can be accessed at:
[User App Repository](https://github.com/ansilmirfan/fork_and_fusion)

## App Screenshots

### Dashboard

<p align="center">
  <img src="Screenshots\dashborad.jpg" width="250px" alt="Dashboard">
</p>

### Sidebar

<p align="center">
  <img src="Screenshots\sidebar.jpg" width="250px" alt="Sidebar">
</p>

### Products

<p align="center">
  <img src="Screenshots\products.jpg" width="250px" alt="Products">
</p>

### Product Creation

<p align="center">
  <img src="Screenshots\product_creation.jpg" width="250px" alt="product creation">
</p>

### Product view

<p align="center">
  <img src="Screenshots\product_view.jpg" width="250px" alt="product view">
</p>

### Categories

<p align="center">
  <img src="Screenshots\categories.jpg" width="250px" alt="categories">
</p>

### Category View

<p align="center">
  <img src="Screenshots\category_view.jpg" width="250px" alt="category view">
</p>

### Pdf generation

<p align="center">
  <img src="Screenshots\qr_code_generation_page.jpg" width="250px" alt="Pdf generation">
</p>
