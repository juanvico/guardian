const http = require('http');
require('dotenv/config');

const options = {
  host: process.env.API_URL,
  path: '/errors',
  method: 'POST',
  headers: {},
};

let apiKey = '';

const init = ({ key }) => {
  apiKey = key;
  options.headers['application-key'] = apiKey;
};

const createError = ({ title, assignedDeveloper, description, severity }) => {
  return new Promise((resolve, reject) => {
    const req = http.request(options, res => {
      res.on('end', () => {
        resolve();
      });
    });

    req.on('error', err => {
      reject(err);
    });

    req.end();
  });
};

module.exports = {
  init,
  createError,
};
