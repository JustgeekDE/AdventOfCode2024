<?php

function parseData($fileName)
{
    $myfile = fopen($fileName, "r") or die("Unable to open file!");
    $content = fread($myfile, filesize($fileName));
    fclose($myfile);

    $result = [];
    $splitContent=preg_split("/\r\n|\n|\r/", $content);

    foreach ($splitContent as $y => $line) {
        array_push($result, str_split($line));
    }

    return $result;
}

function getStartPosition($map)
{
    foreach ($map as $y => $line) {
        foreach ($line as $x => $char) {
            if ($char == '^') {
                return [$x, $y];
            }
        }
    }
}

function printMap($map) {
    foreach ($map as $y => $line) {
        echo implode("", $line) . "\n";
    }
}

function traverseMap($map)
{
    $movementModifiers = [[0, -1], [1, 0], [0, 1], [-1, 0]];
    $direction = 0;
    $currentPosition = getStartPosition($map);
    $x = $currentPosition[0];
    $y = $currentPosition[1];

    $exited = false;
    $count = 0;
    while(!$exited) {
        echo "\n( ".$x."/".$y." ) - ".$direction."\n";
        printMap($map);

        if ($map[$y][$x] != "X") {
        $count +=1;
        $map[$y][$x] = "X";
       } 
       $next_x = $x + $movementModifiers[$direction][0];
       $next_y = $y + $movementModifiers[$direction][1];
       if (!array_key_exists($next_y, $map)) {
        $exited = true;
        break;
       }
       if (!array_key_exists($next_x, $map[$next_y])) {
        $exited = true;
        break;
       }
       if ($map[$next_y][$next_x] == "#") {
        $direction += 1;
        $direction = $direction % 4;
       } else {
        $x = $next_x;
        $y = $next_y;
       }
    }

    return $count;
}

$map = parseData("input");
// printMap($map);
$result = traverseMap($map);
echo "\nResult: ". $result . "\n";
