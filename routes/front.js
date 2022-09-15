var express = require('express');
var router = express.Router();
require('dotenv').config();

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send({ WEBAPP_URL: process.env.WEBAPP_URL });
});

module.exports = router;
