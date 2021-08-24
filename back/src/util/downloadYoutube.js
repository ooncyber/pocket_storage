const fs = require('fs');
const p = require('path')
const { getInfo } = require('ytdl-core');
const ytdl = require('ytdl-core');
require('dotenv/config');

YTDL_NO_UPDATE = false;
// TypeScript: import ytdl from 'ytdl-core'; with --esModuleInterop
// TypeScript: import * as ytdl from 'ytdl-core'; with --allowSyntheticDefaultImports
// TypeScript: import ytdl = require('ytdl-core'); with neither of the above

async function downloadVideo(urlPassada = '') {
    // https://youtu.be/DPeQsgu90TM
    // https://www.youtube.com/watch?v=Wsp3mb7ZaNY

    return new Promise(async (resolve, reject) => {
        let end = urlPassada.indexOf('tu.be') == -1 ? urlPassada.substring(urlPassada.indexOf('v=') + 2, urlPassada.length) : urlPassada.substring(urlPassada.indexOf('be/') + 3, urlPassada.length)

        let d = await getInfo(end)
        var title = d.videoDetails.title.replace(/"/g, "");
        var path = p.join(__dirname, '../../videos/',title + '.mp4');

        let formato = d.formats.find(format => format.quality == 'hd720' && format.hasAudio)
        var pip = ytdl(urlPassada, formato != undefined ? { format: formato } : 'highest')
            .pipe(fs.createWriteStream(path));
        pip.on('finish', () => {
            resolve({path: process.env.SERVER_URL+':'+process.env.PORT+process.env.VIDEO_FOLDER+'/'+title})
        })
    })
}

module.exports = downloadVideo;