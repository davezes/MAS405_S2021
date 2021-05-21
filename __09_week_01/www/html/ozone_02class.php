
<?php
    
    //// use myslqi Database class we made
    include '../_conn_class_mysqli.php' ;
    
    $CDB = new Database ;
    
    //var_dump($CDB) ;
    
    $CDB->connect() ;
    
    //var_dump($CDB) ;
    
    
    $queryStr = "SELECT * FROM ozone_data" ;
    $this_data_array = mysqli_query( $CDB->conn, $queryStr ) ;
    
    $CDB->disconnect() ;
    
    var_dump($CDB) ;
    
    //$this_data = mysqli_fetch_array($this_data_array, MYSQLI_ASSOC) ;
    
    
    $data = [] ;
    
    while ($row = mysqli_fetch_array($this_data_array, MYSQLI_ASSOC)) {
        $data[] = $row ;
    }
    
    //var_dump( $data[ 0 ] ) ;
    
    //echo $data[ 0 ][ 'O3' ] ;
    
    //echo "<br/>" ;
    
    //echo count($data) ;
    
    $o3_values = [] ;
    $latitude = [] ;
    $longitude = [] ;
    for($i=0; $i<count($data); $i++) {
        $o3_values[$i] = $data[ $i ][ 'O3' ] ;
        $latitude[$i] = $data[ $i ][ 'latitude' ] ;
        $longitude[$i] = $data[ $i ][ 'longitude' ] ;
    }
    
    //var_dump( $o3_values ) ;
    
    
    //var_dump( $data[ ][ 'O3' ] ) ;
    
    //$thisjson = json_encode($this_user) ;
    
    //echo $thisjson ;
    //var_dump($this_data) ;
    
    // var_dump($this_user_array) ;
    
    //echo "XXX" ;
    
    ?>


<head>
<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
</head>


<div id="histogram_1" style="width:700px;height:700px;"></div>


<!-- pass php array to javascript -->

<script>

var js_o3 = <?php echo json_encode($o3_values); ?> ;
var js_lat = <?php echo json_encode($latitude); ?> ;
var js_lon = <?php echo json_encode($longitude); ?> ;

// Display the array elements
for(var i = 0; i < js_o3.length; i++){
    document.write('<br/>');
    document.write(js_lon[i]);
    document.write(' ');
    document.write(js_lat[i]);
    document.write(' ');
    document.write(js_o3[i]);
}

</script>





<script>

myDiv = document.getElementById('histogram_1');

var trace = {
x: js_o3,
type: 'histogram',
};
var data = [trace];
Plotly.newPlot(myDiv, data);

</script>

