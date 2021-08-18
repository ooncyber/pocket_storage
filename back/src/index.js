const express = require('express');
const cors = require('cors');
const morgan = require('morgan')
const multer = require('multer');

const server = express();

server.use(morgan('dev'));
server.use(express.json());
server.use(cors());


const upload = multer({
    storage: multer.diskStorage({
        destination: 'uploads/',
        filename: function (req, file, cb) {
            cb(null,file.originalname)
        }
    })
});

server.post('/', upload.single('file'), (req, res, next) => {
    console.log(req.file);
    res.send('<h2>Upload realizado com sucesso</h2>')
});

server.listen(80, () => console.log('http://localhost:80'));


