const axios = require('axios').default;

let httpClient;
let apiKey = '';

const init = ({ key }) => {
  apiKey = key;
  httpClient = axios.create({
    baseURL: 'http://localhost:4000/api/v1',
    timeout: 1000,
    headers: { 'application-key': apiKey },
  });
};

const createError = ({ title, assignedDeveloper, description, severity }) => {
  return httpClient.post('/errors', { error: { title, assignedDeveloper, description, severity } });
};

module.exports = {
  init,
  createError,
};
