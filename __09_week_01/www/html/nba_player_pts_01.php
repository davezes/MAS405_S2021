
<?php ini_set('memory_limit', '256M') ; ?>

<?php
    
    if( file_exists( $_SERVER[ 'DOCUMENT_ROOT' ] . '/_site_parameters.php' ) ) {
        include $_SERVER[ 'DOCUMENT_ROOT' ] . '/_site_parameters.php' ;
    } else {
        include $_SERVER[ 'DOCUMENT_ROOT' ] . '../_site_parameters.php' ;
    }
    

    $db = mysqli_connect($param_hostname, $param_user, $param_pw, $param_dbname) ;
      
    if( !$db ) {
        die("DB connection failed: " . mysqli_connect_error()) ;
    }


    //$queryStr = "SELECT pts FROM nba_playersDate_1 LIMIT 100000" ;
    $queryStr = "SELECT pts FROM nba_playersDate_1" ;
    $this_data_array = mysqli_query( $db, $queryStr ) ;
    
 
    
    $data = [] ;

    while ($row = mysqli_fetch_array($this_data_array, MYSQLI_ASSOC)) {
        $data[] = $row ;
    }
    
    // var_dump( $data[ 0 ] ) ;
    
    //echo $data[ 0 ][ 'O3' ] ;
    
    //echo "<br/>" ;
    
    //echo count($data) ;
    
    $pts = [] ;
    for($i=0; $i<count($data); $i++) {
        $pts[$i] = $data[ $i ][ 'pts' ] ;
    }
      
    //var_dump( $data[ 0 ][ 'pts' ] ) ;
    
    //$thisjson = json_encode($this_user) ;
    
     
    ?>


<head>
    <script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
</head>


<div id="histogram_1" style="width:1080px;height:700px;"></div>


<!-- pass php array to javascript -->

<script>

var js_pts = <?php echo json_encode($pts); ?> ;


// Display the array elements
//for(var i = 0; i < js_o3.length; i++){
//    document.write('<br/>');
//    document.write(js_pts[i]);
//}

</script>





<script>

<!-- VISIT: https://plotly.com/javascript/figure-labels/ for details -->

histDiv = document.getElementById('histogram_1');

var trace = {
x: js_pts,
type: 'histogram',
} ;

var layout = {
title: {
text: 'Histogram: Game-Points Scored by NBA Players',
font: {
family: 'Courier New, monospace',
size: 22
},
},
xref: 'paper',
x: 0,
} ;

var data = [trace];
Plotly.newPlot(histDiv, data, layout);

</script>





<!-- NOTE: if you want more plots you should to purge your large-memory variables, e.g., here,  -->

<?php
    $pts = [] ;
    ?>

<script>
delete(js_pts) ;
</script>
