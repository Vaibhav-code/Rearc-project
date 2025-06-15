const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  const secret = process.env.SECRET_WORD || 'not set';
  res.send(`Hello from ECS Fargate! SECRET_WORD: ${secret}`);
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
