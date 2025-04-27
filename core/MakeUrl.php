<?php
class MakeUrl
{
    function url($path = '')
    {
        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
         
        $host = $_SERVER['HTTP_HOST'];
     
        $scriptDir = rtrim(str_replace(basename($_SERVER['SCRIPT_NAME']), '', $_SERVER['SCRIPT_NAME']), '/');
     
        $baseUrl = $protocol . $host . $scriptDir;
     
        $baseUrl = rtrim($baseUrl, '/');
        
        $path = ltrim($path, '/');
    
        return $baseUrl . '/' . $path;
    }
}
?>
