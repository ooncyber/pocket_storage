const router = require('express').Router();
configMulter = require('../multer/config')
const { uploadFile } = require("../models/file");


router.post('/uploadFile', configMulter.single('file',), async (req, res, next) =>
    uploadFile(req).then(r => res.send(r)).catch(err => res.status(400).send(err)));

module.exports = router;