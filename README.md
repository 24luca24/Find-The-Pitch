# Find-The-Pitch

**Find-The-Pitch** is an application designed to help users search for sports fields — including beach volleyball, paddle tennis, and football — both private and public. Additionally, the app offers the possibility to book available fields directly.

## Project Overview

The project currently consists of two backend microservices and a frontend application:

- **authentication-service**: Handles user authentication and authorization.
- **field-service**: Manages field data, including search and booking functionalities.
- **frontend**: The user interface built with Flutter.

The backend services are developed using **Spring Boot**.

## Getting Started

### Prerequisites

- Java 21 (for Spring Boot services)
  ```bash
  brew install openjdk@21
  
- Flutter SDK and dependencies
- Maven
  ```bash
  brew install maven
  
- Minikube
  ```bash
  brew install minikube
  
- kubectl
  ```bash
  brew install kubectl
  
- Xcode + Simulator
  ```bash
  Install from Appstore + xcode-select-install
  
- Docker desktop
  ```bash
  brew install docker

### Installation and Running

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd Find-The-Pitch

2. Navigate into **Find-The-Pitch** folder and

   ```bash
   ./start.sh

3. Run frontend: from the root of the project type:

   ```bash
   cd frontend
   ./startAll.sh
