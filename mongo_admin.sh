mongo admin --eval 'db.createUser({
user:"admin",
pwd:"admin",
roles:[{
role:"userAdminAnyDatabase",
db:"admin"
}]
});
db.auth("admin", "admin");'
