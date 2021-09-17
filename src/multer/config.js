const multer = require('multer');

module.exports = multer({
    storage: multer.diskStorage({
        destination: 'videos/',
        filename: function (req, file, cb) {
            var name = file.originalname;
            // se o método de envio fosse res.download ou res.sendFile
            // name = file.originalname.replace(".MOV",'.mp4')
            cb(null, name)
        }
    })
});