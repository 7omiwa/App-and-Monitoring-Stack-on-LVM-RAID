# States the Base Image
FROM python:3.10-slim

# Set Working Dir (Where the source code will be copied)
WORKDIR /app
# Copy the Files
COPY requirements.txt ./
# Install Dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p /app/pers_storage
# Copy the rest of the app
COPY app.py templates/index.html static/style.css static/script.js /app/
# Expose the port
EXPOSE 5000
# Run the app 
CMD ["python", "app.py"]
