const express = require('express');
const router = express.Router();
const session = require('express-session');
const FileStore = require('session-file-store')(session); // 원래는 서버보다는 해싱데이터베이스 또는 보안된 데이터베이스에 저장하는 것이 안전하다
const db = require('../routes/db');

// var authdata = {
// 	id: 'yeonu1201',
// 	email: 'yeonu1201@gmail.com',
// 	password: '1201',
// 	nickname: 'ezman'
// }

router.get('/login', (req, res) => {
	res.render('login');
});

router.post('/tryLogin', (req, res) => {
	var id = req.body.id;
	var pw = req.body.pw;
	
	db.searchUSER(id, pw, (result) => {
		if(result) {
			req.session.is_logined = true;
			req.session.nickname = result[0]['USER_nickname'];
			// 쿠키의 타임아웃시간: 3600000초=1시간
			// 일반적으로 세션 미들웨어가 session.touch()로 maxAge를 업데이트 하므로 따로 건드릴 필요는 없다
			req.session.cookie.maxAge = 1800000; // 타임아웃: 30분
			res.redirect('/');
			console.log('logined: ' + req.session.nickname);
		} else {
			res.send('no user data. Who?');
		}
	});
});

module.exports = router;