const express = require('express');
const router = express.Router();
const auth = require('../lib/auth');
const db = require('../routes/db');


/* GET home page. */
router.get('/', (req, res, next) => {
	var nickname = req.session.nickname;
	
	if(auth.IsOwner(req, res)) {
		if (auth.IsFirst(req, res)) { // 로그인은 했는데 그게 처음이라면
			res.redirect('/selectField');
		}
	} else {
		res.redirect('/auth/login');
	}
	
	// 로그인 한 사람이 즐겨찾기 한 분야(Fields) 뿌리기
});

router.get('/logout', (req, res) => {
	req.session.destroy( (err) =>{ // 연결되어있던 세션을 파괴함
		if(err) throw err;
		res.redirect('/');
	});
});

router.get('/selectField', (req, res) => {
	res.write("fuck you");
});

module.exports = router;
