const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: '!DOGLIKEepdlxjqpdltm!',
	database: 'ForManiac'
});


function searchUSER(USER_id, USER_password, callback) {
	connection.query(`SELECT * FROM USERS WHERE USER_id='${USER_id}' AND USER_password='${USER_password}'`, (err, result) => {
		if(err) throw err;
		if(result) {
			callback(result); //USERS 엔티티의 모든 속성값 반환
		} else {
			callback(null);
		}
	});
}

module.exports = {
	searchUSER
}