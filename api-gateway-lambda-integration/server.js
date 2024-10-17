// const express = require('express')
// const app = express()
// const port = 4000

// app.get('/', (req, res) => {
//     res.send('Home page')
//   })

// app.get('/time', (req, res) => {
//   res.send(`Hello World! The current server time is ${(new Date())}`)
// })

// app.listen(port, () => {
//   console.log(`Example app listening on port ${port}`)
// })

module.exports.handler = async (event) => {
  const path = event.rawPath;  
  let response;

  switch (path) {
    case "/":
      response = {
        statusCode: 200,
        body: JSON.stringify("home page"),
      };
      break;

    case "/time":
      const currentTime = new Date();
      response = {
        statusCode: 200,
        body: JSON.stringify(`Hello World! The current server time is ${currentTime}`),
      };
      break;

    default:
      response = {
        statusCode: 404,
        body: JSON.stringify("Page not found"),
      };
  }

  return response;
};
