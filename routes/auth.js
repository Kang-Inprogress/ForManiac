const express = require('express');
const router = express.Router();
const session = require('express-session');
const db = require('../routes/db');


router.get('/login', (req, res) => {
	var msg;
	if (req.session.triedRegister) { // 회원가입이 성공적으로 되었을 경우 true가 될 수 있다
		msg = '회원가입이 되었으므로 로그인 창으로 이동 되었습니다';
	}
	res.render('login', {MSG : msg});
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

router.get('/register', (req, res) => {
	res.render('register');
});

router.post('/tryRegister', (req, res) => {
	var id = req.body.id,
		pw = req.body.pw,
		email = req. body.email,
		nickname = req.body.nickname;
	
	// id, pw, nickname은 비어있으면 안되므로 검사
	if(id.length <= 0 || pw.length <= 0 || nickname.length <= 0) {
		res.redirect('/autherror');
	} else {
		if(email) { // email있을때와 없을때 다른 쿼리 호출
			db.registerUSER(id, pw, email, nickname, () => {
				req.session.triedRegister = true;
				res.redirect('/auth/login');
			});
		} else {
			db.registerUSER_withoutEmail(id, pw, nickname, () => {
				req.session.triedRegister = true;
				res.redirect('/auth/login');
			});
		}
	}
});

router.get('/autherror', (req, res) => {
	res.write("<script>alert('AUTH ERROR!')</script>");
	res.write("<script>window.location=/login</script>");
});

module.exports = router;