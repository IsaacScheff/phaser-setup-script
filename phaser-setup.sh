#!/bin/bash

# Default values for width and height
WIDTH=800
HEIGHT=600

# Function to display help message
usage() {
  echo "Usage: $0 [-w width] [-h height] project_name"
  echo "  -w width      Set the width of the Phaser game (default: 800)"
  echo "  -h height     Set the height of the Phaser game (default: 600)"
  exit 1
}

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null
then
  echo "Node.js and npm are required but not installed. Please install them first."
  exit 1
fi

# Parse optional flags
while getopts ":w:h:" opt; do
  case ${opt} in
    w )
      WIDTH=$OPTARG
      ;;
    h )
      HEIGHT=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if a project name is provided
if [ -z "$1" ]; then
  usage
fi

# Assign the project name
PROJECT_NAME=$1

# Create project directory and navigate into it
echo "Creating project directory..."
mkdir -p $PROJECT_NAME || { echo "Failed to create project directory"; exit 1; }
cd $PROJECT_NAME || exit

# Initialize a new Node.js project
echo "Initializing Node.js project..."
npm init -y || { echo "Failed to initialize Node.js project"; exit 1; }

# Install Phaser, Webpack, and dependencies
echo "Installing dependencies..."
npm install phaser webpack webpack-cli webpack-dev-server --save-dev || { echo "Failed to install dependencies"; exit 1; }
npm install babel-loader @babel/core @babel/preset-env --save-dev || { echo "Failed to install Babel"; exit 1; }
npm install html-webpack-plugin --save-dev || { echo "Failed to install HtmlWebpackPlugin"; exit 1; }
npm install copy-webpack-plugin --save-dev || { echo "Failed to install copy-webpack-plugin"; exit 1; }

# Create project structure
echo "Creating project structure..."
mkdir -p src/scenes src/assets/images src/assets/audio || { echo "Failed to create project structure"; exit 1; }

# Create webpack.config.js
echo "Creating webpack.config.js..."
cat <<EOL > webpack.config.js
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');

module.exports = {
    mode: 'development',
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env']
                    }
                }
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'src/index.html'
        }),
        new CopyPlugin({
            patterns: [
                { from: 'src/assets', to: 'assets', noErrorOnMissing: true }
            ]
        })
    ],
    devServer: {
        static: path.join(__dirname, 'dist'),
        compress: true,
        port: 8080,
        open: true
    }
};
EOL

# Create .babelrc
echo "Creating .babelrc..."
cat <<EOL > .babelrc
{
  "presets": ["@babel/preset-env"]
}
EOL

# Create index.html
echo "Creating index.html..."
cat <<EOL > src/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$PROJECT_NAME</title>
</head>
</html>
EOL

# Create src/index.js
echo "Creating src/index.js..."
cat <<EOL > src/index.js
import Phaser from 'phaser';
import MainScene from './scenes/MainScene';

const config = {
  type: Phaser.AUTO,
  width: $WIDTH,
  height: $HEIGHT,
  scene: [MainScene]
};

new Phaser.Game(config);
EOL

# Create src/scenes/MainScene.js
echo "Creating src/scenes/MainScene.js..."
cat <<EOL > src/scenes/MainScene.js
import Phaser from 'phaser';

class MainScene extends Phaser.Scene {
  constructor() {
    super({ key: 'MainScene' });
  }

  preload() {
    // Load assets here
  }

  create() {
    // Create game objects here
    this.add.text(100, 100, 'Hello Phaser!', { fill: '#0f0' });
  }

  update() {
    // Update game objects here
  }
}

export default MainScene;
EOL

# Create .gitignore
echo "Creating .gitignore..."
cat <<EOL > .gitignore
# Node modules
node_modules/

# Distribution folder
/dist/

# Environment files
.env

# System Files
.DS_Store
Thumbs.db

# Logs
npm-debug.log
yarn-error.log

# Editor directories and files
.idea/
.vscode/
*.sublime-workspace

# Optional: Exclude source maps if you generate them
*.map
EOL

# Create LICENSE file
echo "Creating LICENSE file..."
cat <<EOL > LICENSE
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

# Update package.json scripts
echo "Updating package.json scripts..."
npx json -I -f package.json -e 'this.scripts={"start":"webpack serve","build":"webpack"}' || { echo "Failed to update package.json"; exit 1; }

# Initialize Git repository
echo "Initializing Git repository..."
git init || { echo "Failed to initialize Git repository"; exit 1; }
git add . || { echo "Failed to stage files"; exit 1; }
git commit -m "Initial commit, Phaser.js and Webpack setup." || { echo "Failed to commit files"; exit 1; }

echo "Project setup complete."