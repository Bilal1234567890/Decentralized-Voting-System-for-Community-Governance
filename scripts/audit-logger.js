// audit-logger.js
// Script to log voting events and proposal changes
const fs = require('fs');
const LOG_FILE = 'audit-log.txt';

function logEvent(eventType, details) {
  const timestamp = new Date().toISOString();
  const logEntry = `[${timestamp}] ${eventType}: ${JSON.stringify(details)}\n`;
  fs.appendFileSync(LOG_FILE, logEntry);
}

// Example usage:
logEvent('VOTE_CAST', { voter: 'ST123...', candidate: 'Proposal A' });
logEvent('PROPOSAL_ADDED', { proposer: 'ST456...', proposal: 'Proposal B' });