mongo xtest --eval 'db.createUser({
user:"xtest",
pwd:"xtest@2018",
roles:[{
role:"readWrite",
db:"xtest"
}]
});
db.auth("xtest", "xtest@2018");'
