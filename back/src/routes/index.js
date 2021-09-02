const router = require('express').Router();

const uploadFileRoute = require('./uploadFile');
const categoriaRoute = require('./categoria')
const videosRoute = require('./videos')
module.exports = router.use(uploadFileRoute, categoriaRoute, videosRoute)