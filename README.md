# glauth-demo
GLAuth demo


## prerequisites

* before starting pull git module with `git submodule sync`
* if in need to build locally, install `libpam0g-dev` package



## setup on microk8s

first of all enable local registry with `sudo microk8s enable registry`, this will give u a `localhost:32000` docker registry to push images to


after that simply kickoff skaffold which will build, push the image and deploy the manifests and dependencies to k8s

```bash
shipperizer in ~/shipperizer/glauth-demo on main ● λ SKAFFOLD_DEFAULT_REPO=localhost:32000 skaffold run --port-forward --tail
.
.
.

#16 exporting to image
#16 exporting layers 0.1s done
#16 writing image sha256:134716d8e2b84901f49f0e53ef8bd85d84e6171f16ace11a6a7777cae69b759e done
#16 naming to localhost:32000/glauth-demo:6bdf2c1-dirty done
#16 DONE 0.1s
The push refers to repository [localhost:32000/glauth-demo]
43d490e250f2: Preparing
c2326bde800f: Preparing
5e552ce6aae5: Preparing
6a1069d9378c: Preparing
1c47a89b8f41: Preparing
c60b28d3f33c: Preparing
4cb10dd2545b: Preparing
d2d7ec0f6756: Preparing
1a73b54f556b: Preparing
e624a5370eca: Preparing
d52f02c6501c: Preparing
ff5700ec5418: Preparing
7bea6b893187: Preparing
6fbdf253bbc2: Preparing
e023e0e48e6e: Preparing
4cb10dd2545b: Waiting
ff5700ec5418: Waiting
d2d7ec0f6756: Waiting
7bea6b893187: Waiting
1a73b54f556b: Waiting
e624a5370eca: Waiting
6fbdf253bbc2: Waiting
d52f02c6501c: Waiting
e023e0e48e6e: Waiting
c60b28d3f33c: Waiting
1c47a89b8f41: Layer already exists
6a1069d9378c: Layer already exists
43d490e250f2: Layer already exists
4cb10dd2545b: Layer already exists
c60b28d3f33c: Layer already exists
d2d7ec0f6756: Layer already exists
1a73b54f556b: Layer already exists
e624a5370eca: Layer already exists
d52f02c6501c: Layer already exists
ff5700ec5418: Layer already exists
7bea6b893187: Layer already exists
6fbdf253bbc2: Layer already exists
e023e0e48e6e: Layer already exists
c2326bde800f: Pushed
5e552ce6aae5: Pushed
6bdf2c1-dirty: digest: sha256:b190ecc8edf13ea6761db7c1b7ea0ece09fabfa266dd2cbe1a1213ad735ed315 size: 3452
Build [glauth-demo] succeeded
Starting test...
Tags used in deployment:
 - glauth-demo -> localhost:32000/glauth-demo:6bdf2c1-dirty@sha256:b190ecc8edf13ea6761db7c1b7ea0ece09fabfa266dd2cbe1a1213ad735ed315
Starting deploy...
WARN[0044] image [localhost:32000/glauth-demo:6bdf2c1-dirty@sha256:b190ecc8edf13ea6761db7c1b7ea0ece09fabfa266dd2cbe1a1213ad735ed315] is not used.  subtask=-1 task=DevLoop
WARN[0044] See helm documentation on how to replace image names with their actual tags: https://skaffold.dev/docs/pipeline-stages/deployers/helm/#image-configuration  subtask=-1 task=DevLoop
Waiting for deployments to stabilize...
Deployments stabilized in 14.06046ms
 - configmap/glauth-config unchanged
 - deployment.apps/glauth configured
 - serviceaccount/glauth unchanged
 - secret/glauth configured
 - service/glauth configured
Waiting for deployments to stabilize...
 - deployment/glauth is ready.
Deployments stabilized in 3.084 seconds
Port forwarding service/postgresql in namespace default, remote port 5432 -> http://127.0.0.1:15432
Port forwarding service/glauth in namespace default, remote port 3893 -> http://127.0.0.1:13893
Port forwarding service/glauth in namespace default, remote port 5555 -> http://127.0.0.1:15555
Press Ctrl+C to exit
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF Debugging enabled
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF AP start
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF Web API enabled
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF Starting HTTP server address=0.0.0.0:5555
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF Database (postgres::host=postgresql.default.svc.cluster.local port=5432 dbname=glauth user=glauth password=glauth sslmode=disable) Plugin: Ready
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF Loading backend datastore=plugin position=0
[glauth] Thu, 07 Sep 2023 10:59:35 +0000 INF LDAP server listening address=0.0.0.0:3893
   
```


## seeding

when all is up, following setup above, connect to the database:

```bash
DB_PASSWORD=glauth pgcli -h 127.0.0.1 -p 15432 -u glauth glauth
Server: PostgreSQL 15.4
Version: 3.5.0
Home: http://pgcli.com
glauth@127:glauth>               
```

and insert data (picked from [here](https://github.com/glauth/glauth-postgres#sqlite-mysql-postgres)):

```sql
INSERT INTO groups(name, gidnumber) VALUES('superheros', 5501);
INSERT INTO groups(name, gidnumber) VALUES('svcaccts', 5502);
INSERT INTO groups(name, gidnumber) VALUES('civilians', 5503);
INSERT INTO groups(name, gidnumber) VALUES('caped', 5504);
INSERT INTO groups(name, gidnumber) VALUES('lovesailing', 5505);
INSERT INTO groups(name, gidnumber) VALUES('smoker', 5506);
INSERT INTO includegroups(parentgroupid, includegroupid) VALUES(5503, 5501);
INSERT INTO includegroups(parentgroupid, includegroupid) VALUES(5504, 5502);
INSERT INTO includegroups(parentgroupid, includegroupid) VALUES(5504, 5501);
INSERT INTO users(name, uidnumber, primarygroup, passsha256) VALUES('hackers', 5001, 5501, '6478579e37aff45f013e14eeb30b3cc56c72ccdc310123bcdf53e0333e3f416a');
INSERT INTO users(name, uidnumber, primarygroup, passsha256) VALUES('johndoe', 5002, 5502, '6478579e37aff45f013e14eeb30b3cc56c72ccdc310123bcdf53e0333e3f416a');
INSERT INTO users(name, mail, uidnumber, primarygroup, passsha256) VALUES('serviceuser', 'serviceuser@example.com', 5003, 5502, '652c7dc687d98c9889304ed2e408c74b611e86a40caa51c4b43f1dd5913c5cd0');
INSERT INTO users(name, uidnumber, primarygroup, passsha256, othergroups, custattr) VALUES('user4', 5004, 5504, '652c7dc687d98c9889304ed2e408c74b611e86a40caa51c4b43f1dd5913c5cd0', '5505,5506', '{"employeetype":["Intern","Temp"],"employeenumber":[12345,54321]}');
INSERT INTO capabilities(userid, action, object) VALUES(5001, 'search', 'ou=superheros,dc=glauth,dc=com');
INSERT INTO capabilities(userid, action, object) VALUES(5003, 'search', '*');
```


## querying

direct your `ldap*` commands to the server on `localhost:13893`:

```bash
shipperizer in ~/shipperizer/glauth-demo on main ● λ ldapsearch -LLL -H ldap://localhost:13893 -D cn=serviceuser,ou=svcaccts,dc=glauth,dc=com -w mysecret -x -bdc=glauth,dc=com cn=hackers
dn: cn=hackers,ou=superheros,ou=users,dc=glauth,dc=com
cn: hackers
uid: hackers
ou: superheros
uidNumber: 5001
accountStatus: active
objectClass: posixAccount
loginShell: /bin/bash
homeDirectory: /home/hackers
description: hackers via LDAP
gecos: hackers via LDAP
gidNumber: 5501
memberOf: ou=caped,ou=groups,dc=glauth,dc=com
memberOf: ou=civilians,ou=groups,dc=glauth,dc=com
memberOf: ou=superheros,ou=groups,dc=glauth,dc=com

shipperizer in ~/shipperizer/glauth-demo on main ● λ ldapsearch  -H ldap://localhost:3893 -D cn=hackers,ou=superheros,dc=glauth,dc=com -w dogood -x -bdc=glauth,dc=com cn=hackers        
ldap_sasl_bind(SIMPLE): Can't contact LDAP server (-1)
shipperizer in ~/shipperizer/glauth-demo on main ● λ ldapsearch  -H ldap://localhost:13893 -D cn=hackers,ou=superheros,dc=glauth,dc=com -w dogood -x -bdc=glauth,dc=com cn=hackers
# extended LDIF
#
# LDAPv3
# base <dc=glauth,dc=com> with scope subtree
# filter: cn=hackers
# requesting: ALL
#

# search result
search: 2
result: 50 Insufficient access

# numResponses: 1
```

or use the ui (partially working) pon `localhost:15555`