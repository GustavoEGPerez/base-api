var express = require('express');
var router = express.Router();

function getRandomString(length) {
  var result = '';
  var characters = 'ABCDEFGHI JKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() *
      charactersLength));
  }
  return result;
}

/* GET users listing. */
router.get('/', function (req, res, next) {
  let results = [];
  for (var ndx = 0; ndx < 1000; ndx++) {
    results.push({ id: ndx + 1, name: getRandomString(30), code: getRandomString(10), new: true })
  }
  res.send(results);
});

module.exports = router;
