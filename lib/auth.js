// 인증 관련 함수 모듈
const db = require('../routes/db');



// 세션정보에 로그인 여부 묻기
// 간단한 것이지만 필요함 모든 액션에는 로그인 여부를 물을 것이기 때문에
function IsOwner(req, res) { 
	if(req.session.is_logined) {
		return true;
	} else {
		return false;
	}
}

module.exports = {
	IsOwner
}