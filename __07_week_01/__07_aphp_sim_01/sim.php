

<?php ini_set('memory_limit', '256M') ; ?>

<?php
    
    
    //$time_start = hrtime(true);

    
    ///// you need a server to run this
    ///// if you have a Mac, the OS comes with a base php install that can run a local server
    ///// in Terminal, change directory to the folder that contains this file
    ///// then issue the command
    ///// php -S simserver:8008
    ///// then, in your favorite browser, point a window to URL:  simserver:8008/sim.php
    /////      ~Quantslob
    
    $n = 3 ; // number of doors
    $r = 1 ; // number of losing doors revealed by host, must be > 0 AND < n - 1
    $nn = 2000000 ; // total number of simulations -- if you make this too large, your php server may puke
    
    //////////
    
    $os_wins = array($nn) ;
    $sw_wins = array($nn) ;
    $d_space = range(1, $n, 1) ;
    
    
    //var_dump($d_space) ;
    
    for($kk=0; $kk<$nn; $kk++) {
        
        $door_prize = [ $d_space[ array_rand($d_space, 1) ] ] ;
        $door_select = [ $d_space[ array_rand($d_space, 1) ] ] ;

        
        $doors_can_reveal = array_diff( $d_space, array_merge( $door_prize, $door_select ) ) ;
        
        if($r > 1) {
            $xndxs = array_rand($doors_can_reveal, $r) ;
            $doors_revealed = array($r) ;
            for($jj=0; $jj<$r; $jj++) {
                $doors_revealed[$jj] = $doors_can_reveal[ $xndxs[ $jj ] ] ;
            }
        } else {
            $doors_revealed = [ $doors_can_reveal[ array_rand($doors_can_reveal, $r) ]  ] ;
        }
        
        
        $doors_can_switch = array_diff( $d_space, array_merge( $doors_revealed, $door_select ) ) ;
        $door_switch = [ $doors_can_switch[ array_rand($doors_can_switch, 1) ] ] ;
        
        if( $door_prize == $door_select ) {
            $os_wins[$kk] = 1 ;
        } else {
            $os_wins[$kk] = 0 ;
        }
        
        if( $door_prize == $door_switch ) {
            $sw_wins[$kk] = 1 ;
        } else {
            $sw_wins[$kk] = 0 ;
        }
        
        
    }
    
    echo 'proportion original selection wins: ' . array_sum($os_wins) / $nn ;
    echo '<br/>' ;
    echo 'proportion switching wins: ' . array_sum($sw_wins) / $nn ;
    
    


    echo '<br/>' ;
    


    //$time_end = hrtime(true);
    //$time = ($time_end - $time_start) / 1e9 ;

    //echo "Run time: $time seconds\n";
    
    ?>

