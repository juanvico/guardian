const centinela = require('centinelajs');
require('dotenv/config');

centinela.init({ key: process.env.CENTINELA_API_KEY });

setTimeout(async () => {
  try {
    await centinela.createError({ title: 'test error', description: 'lorem ipsum', severity: 2 });
  } catch (e) {
    console.log('An error occurred');
  }
}, 5000);
