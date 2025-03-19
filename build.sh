#!/bin/bash

set -e

# Clean and build the project
swift build -c release --product runespoor

# Create output directory structure
mkdir -p .vercel/output/static
mkdir -p .vercel/output/functions/api

# Create Vercel runtime handler
cat > .vercel/output/functions/api/index.js << 'EOL'
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

module.exports = async (req, res) => {
  try {
    // Path to the Swift binary
    const binaryPath = path.join(process.cwd(), '.build/release/runespoor');
    
    // Make sure the binary is executable
    fs.chmodSync(binaryPath, '755');
    
    // Set environment variables for Vercel
    const env = {
      ...process.env,
      VERCEL: '1',
      REQUEST_METHOD: req.method,
      REQUEST_PATH: req.url,
      CONTENT_TYPE: req.headers['content-type'] || ''
    };

    // Add headers and body if present
    if (req.headers) {
      env.HTTP_HEADERS = JSON.stringify(req.headers);
    }
    
    if (req.body) {
      env.BODY = typeof req.body === 'string' ? req.body : JSON.stringify(req.body);
    }

    // Execute the Swift binary
    const output = execSync(binaryPath, { env });
    
    // Parse the Swift response
    const response = JSON.parse(output.toString());
    
    // Set status code
    res.status(response.statusCode || 200);
    
    // Set headers
    if (response.headers) {
      Object.entries(response.headers).forEach(([key, value]) => {
        res.setHeader(key, value);
      });
    }
    
    // Send response body
    if (response.body) {
      res.send(response.body);
    } else {
      res.end();
    }
  } catch (error) {
    console.error('Error executing Swift binary:', error);
    res.status(500).send('Internal Server Error');
  }
};
EOL

# Make sure the build script is executable
chmod +x .vercel/output/functions/api/index.js

# Create Vercel config.json
cat > .vercel/output/config.json << 'EOL'
{
  "version": 3,
  "routes": [
    { "src": "/(.*)", "dest": "/api" }
  ]
}
EOL

echo "Build completed successfully" 