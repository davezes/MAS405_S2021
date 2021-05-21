
<?php
    
    class Database {
        
        //////// put your DB creds here
        private $hostname = '' ;
        private $user = '' ;
        private $pw = '' ;
        private $dbname = '' ;
        
        public $conn ;
        public $dc ; //// boolean did disconnect
        
        public function connect() {
            
            $this->conn = '' ;
            
            try {
                $this->conn = mysqli_connect( $this->hostname, $this->user, $this->pw, $this->dbname ) ;
            } catch(Exception $e) {
                echo 'Connection Error: ' . $e->getMessages(), "\n";
            }
        }
        
        public function disconnect() {
            
            try {
                $this->dc = mysqli_close( $this->conn );
            } catch(Exception $e) {
                echo 'Disconnection Error: ' . $e->getMessages(), "\n";
            }
            
            if( $this->dc ) {
                $this->conn = '' ;
                $this->pw = '' ;
                $this->hostname = '' ;
                $this->dbname = '' ;
                $this->user = '' ;
            }
            
        }
        
    }
    
    
    ?>

