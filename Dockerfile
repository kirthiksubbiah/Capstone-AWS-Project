# Use official Python base image
# FROM python:3.9
FROM public.ecr.aws/docker/library/python:3.9

# Set working directory
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy entire project into container
COPY . .

# Expose port Flask runs on
EXPOSE 80

# Run the Flask app
CMD ["python", "main.py"]
