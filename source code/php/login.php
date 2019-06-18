<?php
	include("check.php");
	header("Content-type:text/html;charset=utf-8");

	$loginInfo='';
  if(!empty($_REQUEST['email']) && !empty($_REQUEST['password'])) { //通过post提交的用户名和密码非空
    $email = $_REQUEST['email'];
		$pwd = $_REQUEST['password'];
		if(checkPassword($email,$pwd) == -1) { //数据库连接失败
			$loginInfo['message'] = "connect error:can't connect to database";
		  	$loginInfo['username'] = "";
		 	 $loginInfo['avatar'] = "";
			echo json_encode($loginInfo);
		} else if(checkPassword($email,$pwd) == 1) { //密码正确，检查token
			if(!empty($_COOKIE["token"])) { //本地token非空且未过期，检查token是否和数据库相同，不相同则将服务器token修改为本地token
					include("condb.php");
				//检查本地和数据库的token是否相同
				if(checkToken($_COOKIE["token"]) == -1) {
					$loginInfo['message'] = "connect error:can't connect to database";
					$loginInfo['username'] = "";
					$loginInfo['avatar'] = "";
					echo json_encode($loginInfo);
				} else if(checkToken($_COOKIE["token"]) != 0) {			
					$username=getUserName($email);
					$loginInfo['message'] = 'token login success';
					$loginInfo['username'] = getUserName($email);
					$loginInfo['avatar'] = getAvatar($email);
					echo json_encode($loginInfo);
				} else { //本地和数据库token不同，修改数据库
					$query = "update users set token=? where user_id=?";
					$uid = getId($email);
					$stmt = $con->stmt_init();
					if($stmt->prepare($query)) {
					$stmt->bind_param("si",$_COOKIE["token"],$uid);
					$stmt->execute();
					if($stmt->affected_rows != 0) {				
						$username=getUserName($email);
						$loginInfo['message'] = 'password login success with local cookie update';
						$loginInfo['username'] = getUserName($email);
						$loginInfo['avatar'] = getAvatar($email);
						echo json_encode($loginInfo);
					} else {
						$loginInfo['message'] = "login with wrong token on server";
						$loginInfo['username'] = getUserName($email);
						$loginInfo['avatar'] = getAvatar($email);
						echo json_encode($loginInfo);
					}
					}
				}
				} else { //本地token为空，设置新的token存入cookie，修改服务器token
						$token = md5(rand()); 
						setcookie("token", $token, time()+3600*24, '/'); //随机token用于验证用户登录状态，保存一天3600*24
				include("condb.php");
				$query = "update users set token=? where user_id=?";
				$uid = getId($email);
				$stmt = $con->stmt_init();
				if($stmt->prepare($query)) {
					$stmt->bind_param("si",$token,$uid);
					$stmt->execute();
					if($stmt->affected_rows != 0) {	
						$username=getUserName($email);
						$loginInfo['message'] = 'password login success without local cookie';
						$loginInfo['username'] = getUserName($email);
						$loginInfo['avatar'] = getAvatar($email);
						echo json_encode($loginInfo);
					} else {
						$loginInfo['message'] = "login without local token & worng token in server";
						$loginInfo['username'] = getUserName($email);
						$loginInfo['avatar'] = getAvatar($email);
						echo json_encode($loginInfo);
					}
				}
				}
			} else { //密码不正确，重新登录
				$loginInfo['message'] = 'wrong password';
				$loginInfo['username'] = '';
				$loginInfo['avatar'] = "";

				echo json_encode($loginInfo);
		}
  } else { 
		$loginInfo['message'] = 'illegal input!';
		$loginInfo['username'] = '';
		$loginInfo['avatar'] = "";

		echo json_encode($loginInfo);
  }
?>