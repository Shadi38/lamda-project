const express = require('express')
const app = express()
const port = 4000

app.get('/', (req, res) => {
    res.send('Home page')
  })

app.get('/home', (req, res) => {
  res.send(`Hello World! The current server time is ${(new Date())}`)
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})