<?php
    header("Content-type:text/html;charset=utf-8");
    include("condb.php");
     
    if ($con) {
        $result=array();
        if($con->connect_error) {
            $result["succeed"] = "-1";            
        }else{
            for($num=10000;$num>0;$num--){
               // echo($num);
                $query="SELECT * FROM tests where test_id='$num'";
            
                //查询数据库
                $res = mysqli_query($con,$query);

                $result["succeed"] = "1";
                $arr=mysqli_fetch_array($res,MYSQL_ASSOC);
                // MYSQL_ASSOC - 关联数组
                // MYSQL_NUM - 数字数组
                // MYSQL_BOTH - 默认。同时产生关联和数字数组

                if(!$res||!$arr){
                    //echo($num);
                    echo (json_encode($result)) ;
                    exit(0);
                }

                foreach ($arr as $key => $value) {
                    //把键/值取出放到result数组的data下
                    $result["test_id:$num"][$key] = $value;

                }

                // echo "<pre>";
               // echo($num);
                //echo (json_encode($result)) ;
                $res=null;
            }
        }
    }
    mysql_close($con);
?>