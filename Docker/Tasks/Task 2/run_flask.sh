#!/bin/bash

# Navigate to the task2 directory
cd "/media/jimmy/Data/ITIContent/ITIRepo/ITI-Progress/Docker/Tasks/Task 2"

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/Jemy45/basic-flask-app

# Navigate to the application directory
cd basic-flask-app

# Remove the .git directory to be able to commit changes
rm -rf ".git"

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Run the Flask application
echo "Starting Flask application..."
python routes.py