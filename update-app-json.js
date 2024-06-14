const fs = require('fs');

// Get the version from the command line arguments
const version = process.argv[2];

if (!version) {
  console.log('No new release version. Skipping app.json update.');
  process.exit(0);
}

// Load the current app.json file
const appJson = JSON.parse(fs.readFileSync('app.json', 'utf8'));

// Make your modifications to the app.json content here
appJson.version = version;

// Write the changes back to app.json
fs.writeFileSync('app.json', JSON.stringify(appJson, null, 2));

console.log('app.json has been updated with the new version:', appJson.version);
