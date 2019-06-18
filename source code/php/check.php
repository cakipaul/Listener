<?php
function checkToken($token) { //检查本地token是否和数据库相同
  include("condb.php");
  if($con->connect_error) {
	return -1; //数据库连接失败，检查失败
  } else { //数据库连接成功
	$stmt = $con->stmt_init();	
	$uid = 0;
	$query = "select user_id from users where token=?";
	if($stmt->prepare($query)) {
	  $stmt->bind_param("s", $token);
	  $stmt->execute();
	  $stmt->bind_result($uid);
	  $stmt->fetch();	
	}
	return $uid; //本地token和数据库相同，返回user_id；本地token和数据库不同，返回0
  }
}
function checkPassword($email,$pwd) { //$pwd是md5加密的密码
  include("condb.php");
  if($con->connect_error) {
	return -1; //数据库连接失败，检查失败
  } else { //数据库连接成功，检查id对应的password是否相等
	$stmt = $con->stmt_init();
	$res = "";
	$query = "select password from users where email=?";
	if($stmt->prepare($query)) {
	  $stmt->bind_param("s",$email);
	  $stmt->execute();
	  $stmt->bind_result($res);
	  $stmt->fetch();	
	  if($res== $pwd) { //密码相等
		return 1;
	  } else {
		return 0;
	  }
	}
  }
}
function getId($email) {
  include("condb.php");
  if($con->connect_error) {
	return -1; //数据库连接失败，检查失败
  } else { //数据库连接成功
    $stmt = $con->stmt_init();
	$id = 0;
	$query = "select user_id from users where email=?";
	if($stmt->prepare($query)) {
	  $stmt->bind_param("s",$email);
	  $stmt->execute();
	  $stmt->bind_result($id);
	  $stmt->fetch();
	}
	return $id;
  }
}
function getUserName($email) {
  include("condb.php");
  if($con->connect_error) {
	return -1; //数据库连接失败，检查失败
  } else { //数据库连接成功
  $stmt = $con->stmt_init();
	$username;
	$query = "select username from users where email=?";
	if($stmt->prepare($query)) {
	  $stmt->bind_param("s",$email);
	  $stmt->execute();
	  $stmt->bind_result($username);
	  $stmt->fetch();
	}
	return $username;
  }
}
function getAvatar($email) {
  include("condb.php");
  if($con->connect_error) {
	return -1; //数据库连接失败，检查失败
  } else { //数据库连接成功
  $stmt = $con->stmt_init();
	$avatar;
	$query = "select avatar from users where email=?";
	if($stmt->prepare($query)) {
	  $stmt->bind_param("s",$email);
	  $stmt->execute();
	  $stmt->bind_result($avatar);
	  $stmt->fetch();
	}
	return $avatar;
  }
}

?>