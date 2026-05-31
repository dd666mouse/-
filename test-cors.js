const fetch = require('node-fetch');
fetch('https://img.remit.ee/api/file/BQACAgUAAyEGAASHRsPbAAEUxPVqGrDryKgC80Ddj0Ax2kWQjZZCdAACaCcAAkjl2VSp34PaSFwq2DsE.mp4')
  .then(res => console.log('CORS OK:', res.headers.get('access-control-allow-origin')))
  .catch(err => console.log('Error:', err));
