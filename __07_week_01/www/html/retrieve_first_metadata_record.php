
<?php

    ////// Have JSONView extension installed on Chrome for this
     
    include $_SERVER[ 'DOCUMENT_ROOT' ] . '/_site_parameters.php' ; /// this is in root.  It contains your connection parameters
    
    $db = mysqli_connect($param_hostname, $param_user, $param_pw, $param_dbname) ;
    
    /////// first meta data entry
    $queryStr = "SELECT entry FROM metadata WHERE entryNumber = '1'" ;
    
    ///// OR . . .
    /////// variable definitions for ozone data
    // $queryStr = "SELECT variableDefs FROM dataDictionary WHERE tableName = 'ozone_data'" ;
    
    /// MYSQLI_ASSOC
    $this_query_array = mysqli_query( $db, $queryStr ) ;
    $this_result = mysqli_fetch_array($this_query_array, MYSQLI_BOTH) ; //// MYSQLI_BOTH drop field name
    
    $xx = '[' . $this_result[ 0 ] . ']' ;
    
   //$thisjson = json_encode($xx) ;
    
    echo $xx ;
    
    ?>
