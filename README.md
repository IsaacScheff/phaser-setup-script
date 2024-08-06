# Phaser.js Project Setup Script

## Overview
This script automates the setup of a Phaser.js project with Webpack. It creates the necessary project structure, installs dependencies, and initializes a new Phaser.js project with Webpack.

## Requirements
- Node.js and npm must be installed.
- Bash shell (default on most Unix-based systems).

## Installation and Execution

### Step-by-Step Guide

1. **Clone the Repository**

2. **Give Execute Permissions**

   For Unix-based systems (Linux/macOS):
   chmod +x setup_phaser.sh

   For Windows, you can run the script using Git Bash or WSL (Windows Subsystem for Linux).

3. **Run the Script**

   Execute the script with the desired options. Example:
   ./phaser-setup.sh -w 1024 -h 768 my-phaser-game

   ### Parameters
- `-w width` (optional): Set the width of the Phaser game (default: 800).
- `-h height` (optional): Set the height of the Phaser game (default: 600).
- `-t` (optional): Use TypeScript for the project.
- `project_name`: The name of your Phaser project.


## What the Script Does

1. **Checks that Node.js and npm are installed**

2. **Parses Command-Line Options**
   - Reads optional flags; height, width, typescript.

3. **Creates Project Directory**

4. **Initializes Node.js Project**
   - Runs `npm init -y` to set up a new Node.js project.

5. **Installs Dependencies**
   - Installs Phaser, Webpack, and related dependencies.

6. **Sets Up Project Structure**

7. **Creates Configuration Files**
   - Generates `webpack.config.js` for project configuration.
   - Conditionally creates `.babelrc` if not using TypeScript.
   - Creates `tsconfig.json` if using TypeScript.

8. **Creates HTML and JavaScript/TypeScript Files**

9. **Initializes Git Repository**
   - Initializes a new Git repository and makes the initial commit.

## Generated Project Structure

my-phaser-game/\
+-- src/\
| +-- assets/\
| | +-- images/\
| | +-- audio/\
| +-- scenes/\
| | +-- MainScene.js\
| +-- index.js\
| +-- index.html\
+-- .babelrc\
+-- .gitignore\
+-- LICENSE\
+-- package.json\
+-- webpack.config.js

## Running the Project

To start the development server and view your Phaser game:

1. Navigate to your project directory:
   cd project_name

2. Run the development server:
   npm start

Open your browser and go to `http://localhost:8080` to see your Phaser game in action.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.