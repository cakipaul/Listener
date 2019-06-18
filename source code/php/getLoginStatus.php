<?php
    header("Content-type:text/html;charset=utf-8");

  include("check.php");
  if(!empty($_COOKIE["token"])) { //本地token非空且未过期
    header('Content-Type:application/json; charset=utf-8');
	$resInfo = array();
	if(checkToken($_COOKIE["token"]) == -1) { //连接数据库失败，检查失败，返回-1
	  $resInfo['status'] = 0;
	  $resInfo['pic'] = "reload";
	  $resInfo['name'] = "后台维护中";
	  //$resInfo['userid'] = getIdByToken($_COOKIE['token']);
	  echo json_encode($resInfo);
	} else if(checkToken($_COOKIE["token"]) == 0) { //本地token与数据库不同，说明异地登录，需重新登录
	  $resInfo['status'] = 3;
	  $resInfo['pic'] = "reload";
	  $resInfo['name'] = "请重新登录";
	  //$resInfo['userid'] = getIdByToken($_COOKIE['token']);
	  echo json_encode($resInfo);
	} else { //本地token与数据库相同，返回userid
	  $resInfo['status'] = 1;
	  $resInfo['pic'] = "star";
	  $resInfo['name'] = "个人中心";
	  $resInfo['userid'] = checkToken($_COOKIE['token']);
	  echo json_encode($resInfo);
	}
  } else { //本地token为空，登录超时或未登录
    $resInfo = array();
    $resInfo['status'] = 2;
		$resInfo['pic'] = "mine";
		$resInfo['name'] = "登录";
	//$resInfo['userid'] = getIdByToken($_COOKIE['token']);
	echo json_encode($resInfo);
  }
?>