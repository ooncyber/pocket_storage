const router = require('express').Router();

const uploadFileRoute = require('./uploadFile');
const categoriaRoute = require('./categoria')
const registrosRoute = require('./registros')
const videosRoute = require('./videos')
module.exports = router.use(uploadFileRoute, categoriaRoute, registrosRoute, videosRoute)