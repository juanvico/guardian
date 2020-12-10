const axios = require('axios').default;

let httpClient;
let apiKey = '';

const init = ({ key }) => {
  apiKey = key;
  httpClient = axios.create({
    baseURL: 'http://localhost:4000',
    timeout: 500,
    headers: { 'application-key': apiKey },
  });
  return testConnection();
};

const testConnection = () => {
  return httpClient.get('/health')
    .then(() => true)
    .catch(() => 'Connection to Centinela failed');
};

const createError = ({ title, assignedDeveloper, description, severity }) => {
  return httpClient.post('/api/v1/errors', { error: { title, assignedDeveloper, description, severity } });
};

module.exports = {
  init,
  createError,
};
