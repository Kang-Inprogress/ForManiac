const express = require('express');
const router = express.Router();
const auth = require('../lib/auth');


/* GET home page. */
router.get('/', (req, res, next) => {
	var nickname = req.session.nickname;
	
	if(auth.IsOwner(req, res)) {
		res.render('index', {nickname: nickname});
	} else {
		res.redirect('/auth/login');
	}
  // res.render('index', { title: 'Rice Field' });
});

router.get('/logout', (req, res) => {
	req.session.destroy( (err) =>{ // 연결되어있던 세션을 파괴함
		if(err) throw err;
		res.redirect('/');
	});
});

module.exports = router;
