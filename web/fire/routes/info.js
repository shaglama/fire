var express = require('express');
var router = express.Router();
var spawn = require('child_process').spawn;

/* GET home page. */
router.get('/', function(req, res, next) {
	var out="";
	var errs="";
	var args= ['/home/randy/fire/fire','--info'];
	var child = spawn('/bin/bash',args);
	child.stdout.on('data', function(data) {
    		out += data ;
	});
	child.stderr.on('data', function(data) {
    		errs += data;
	});
	child.on('close', function(code) {
		if(code == 0){
			res.render('info',{ title: 'Fire Info', data: out}); 
		} else {
			res.render('info',{ title: 'Fire Info', data: errs});
		}
	});

});

module.exports = router;

