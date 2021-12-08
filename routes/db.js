const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: '!DOGLIKEepdlxjqpdltm!',
	database: 'ForManiac'
});


async function searchUSER(USER_id, USER_password, callback) {
	connection.query(`SELECT * FROM USERS WHERE USER_id='${USER_id}' AND USER_password=password('${USER_password}')`, (err, result) => {
		if(err) throw err;
		if(result) {
			callback(result); //USERS 엔티티의 모든 속성값 반환
		} else {
			callback(null);
		}
	});
}

async function registerUSER(USER_id, USER_password, USER_email, USER_nickname, callback) {
	var sql = `INSERT INTO USERS VALUES(
	"${USER_id}",
	password("${USER_password}"),
	"${USER_email}",
	"${USER_nickname}",
	null
	)`;
	connection.query(sql, (err) => {
		if(err) throw err;
		callback(null);
	});
}
async function registerUSER_withoutEmail(USER_id, USER_password, USER_nickname, callback) {
	var sql = `INSERT INTO USERS(USER_id, USER_password, USER_nickname, USER_lastlogined) VALUES(
	"${USER_id}",
	password("${USER_password}"),
	"${USER_nickname}",
	null
	)`;
	connection.query(sql, (err) => {
		if(err) throw err;
		callback(null);
	});
}

module.exports = {
	searchUSER,
	registerUSER,
	registerUSER_withoutEmail
}