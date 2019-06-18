<?php
	include("check.php");
	include("condb.php");

	header("Content-type:text/html;charset=utf-8");

	$sigupInfo='';
  if(!empty($_REQUEST['username'])&&!empty($_REQUEST['email']) && !empty($_REQUEST['password'])) { //通过post提交非空
    	$email = $_REQUEST['email'];
		$pwd = $_REQUEST['password'];
		$username = $_REQUEST['username'];
		if(getID($email) == -1) { //数据库连接失败
			$signupInfo['message'] = "can't connect to db";
			echo json_encode($signupInfo);
		}else if(getID($email)>0){//邮箱已注册
			$signupInfo['message'] = "Email already registered";
			echo json_encode($signupInfo);
		}else{
			if($con->connect_error) {
				$signupInfo['message'] = "can't connect to db";
				echo json_encode($signupInfo);
			  } else { //数据库连接成功
				$query = "insert into users(username,email,password) values('$username','$email','$pwd');";
				if($con->query($query)==TRUE) {
					$signupInfo['message'] = "register success";
					//$signupInfo[''] = "register success";
					echo json_encode($signupInfo);
				}else{
					$signupInfo['message'] = "register fail";
					//$signupInfo[''] = "register success";
					echo json_encode($signupInfo);
				}

			  }
		}
	}else{//
		$signupInfo['message'] = "Unauthorized access";
		echo json_encode($signupInfo);
	}
?>