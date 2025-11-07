# Use a slim Python base image for a smaller image size
FROM python:3.9-slim-buster

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire application code into the container
COPY . .

# Expose the port your application listens on 
EXPOSE 5000

# Define the command to run your application
#CMD ["python", "run.py"]
CMD ["python", "-c", "from app.main import app; app.run(host='0.0.0.0', port=5000)"]
