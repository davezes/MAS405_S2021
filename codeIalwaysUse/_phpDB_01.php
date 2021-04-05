

<?php
    //// if we are going to be reading in a large data set, we can set ini parameter in code (at run-time), like so:
    ini_set('memory_limit', '256M') ;
    
    ?>


<?php

    //$param_hostname = '' ;
    //$param_user = '' ;
    //$param_pw = '' ;
    //$param_dbname = '' ;
    
    ///// note: we may want to move these parameters into a php file named '_site_parameters.php' in root,
    ///// and 'include' the file, e.g.,
    ///// include '../_site_parameters.php' ;
    ///// or better yet, use

    ///// loads all connection parameters -- provided you have them assigned in file '_site_parameters.php'
    ///// which needs to be stashed in server root directory (under www directory on linux and most servers)
    include $_SERVER[ 'DOCUMENT_ROOT' ] . '/_site_parameters.php' ;
  

    
    /////// establish connection:
    
    $db = mysqli_connect($param_hostname, $param_user, $param_pw, $param_dbname) ;
    
    
    ////// php has a slightly unusual routine for returning usable data from a query
    ////// this is the standard approach
    ////// note that mysqli_fetch_array() is a feed-forward function
    
    $queryStr = "SELECT * FROM ozone_data" ;
    $this_data_array = mysqli_query( $db, $queryStr ) ;
    
    $data = [] ;
    while ($row = mysqli_fetch_array($this_data_array, MYSQLI_ASSOC)) {
        $data[] = $row ;
    }
    
    ////// $data is a php array
    
    
    ////// the following creates a vector of values
    
    $x_1 = [] ;
    for($i=0; $i<count($data); $i++) {
        $x_1[ $i ] = $data[ $i ][ 'O3' ] ;
        
        ///// in real life, we would comment out the next line
        printf( "row: %s , value: %s  <br/>", $i, $x_1[ $i ] ) ; /// php uses standard printf syntax -- uncomment to see results
    }

?>
