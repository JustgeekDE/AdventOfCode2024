<?php

function parseData($fileName)
{
    $myfile = fopen($fileName, "r") or die("Unable to open file!");
    $content = fread($myfile, filesize($fileName));
    fclose($myfile);

    $result = [];
    $splitContent = preg_split("/\r\n|\n|\r/", $content);

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

function printMap($map)
{
    // foreach ($map as $y => $line) {
    //     echo implode("", $line) . "\n";
    // }
}


function printVisitedMap($map, $visitedMap)
{
    foreach ($map as $y => $line) {
        foreach ($line as $x => $char) {
            $horizontal = false;
            $vertical = false;
            $dir = getVisited($visitedMap, $x, $y);

            if (array_key_exists(1, $dir) || array_key_exists(3, $dir)) {
                $horizontal = true;
            }
            if (array_key_exists(0, $dir) || array_key_exists(2, $dir)) {
                $vertical = true;
            }
            if ($horizontal && $vertical) {
                echo "+";
            } else {
                if ($horizontal) {
                    echo "-";
                } else {
                    if ($vertical) {
                        echo "|";
                    } else {
                        echo $char;
                    }
                }
            }
        }
        echo "\n";
    }
}

function getVisited($map, $x, $y)
{
    if (!array_key_exists($y, $map)) {
        return [];
    }
    if (!array_key_exists($x, $map[$y])) {
        return [];
    }
    return $map[$y][$x];
}

function checkAndSetVisited($map, $x, $y, $dir)
{
    if (!array_key_exists($y, $map)) {
        $map[$y] = [];
    }
    if (!array_key_exists($x, $map[$y])) {
        $map[$y][$x] = [];
    }
    if (array_key_exists($dir, $map[$y][$x])) {
        return [true, $map];
    }
    $map[$y][$x][$dir] = true;
    return [false, $map];
}

function takeStep($map, $x, $y, $dir)
{
    $movementModifiers = [[0, -1], [1, 0], [0, 1], [-1, 0]];

    $next_x = $x + $movementModifiers[$dir][0];
    $next_y = $y + $movementModifiers[$dir][1];

    if (!array_key_exists($next_y, $map)) {
        return [true];
    }
    if (!array_key_exists($next_x, $map[$next_y])) {
        return [true];
    }
    if (($map[$next_y][$next_x] == "#") || ($map[$next_y][$next_x] == "O")) {
        $dir += 1;
        $dir = $dir % 4;
    } else {
        $x = $next_x;
        $y = $next_y;
    }
    return [false, $x, $y, $dir];
}

function detectLoop($map, $x, $y, $dir)
{
    $visitedMap = [];

    $exited = false;
    $count = 0;
    while (!$exited) {
        $visited = checkAndSetVisited($visitedMap, $x, $y, $dir);
        if ($visited[0]) {
            // echo "Found a loop! (" . $x . " / " . $y . " )\n";
            // printVisitedMap($map, $visitedMap);
            return true;
        }
        $visitedMap = $visited[1];

        $stepData = takeStep($map, $x, $y, $dir);
        if ($stepData[0]) {
            break;
        }
        $x = $stepData[1];
        $y = $stepData[2];
        $dir = $stepData[3];
    }
    return false;
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
    while (!$exited) {

        if ($map[$y][$x] != "X") {
            $map[$y][$x] = "X";
        }
        $stepData = takeStep($map, $x, $y, $direction);
        if ($stepData[0]) {
            break;
        }


        $next_x = $stepData[1];
        $next_y = $stepData[2];
        $new_direction = $stepData[3];

        $oldChar = $map[$next_y][$next_x];
        if(($oldChar == '.') && (($next_x != $x) || ($next_y !=$y))){
            $map[$next_y][$next_x] = "O";
            if (detectLoop($map, $x, $y, $direction)) {
                // echo "Found a loop! (" . $x . " / " . $y . " )\n";
                // printMap($map);
                $count += 1;
            }
            $map[$next_y][$next_x] = $oldChar;    
        }
        $x = $next_x;
        $y = $next_y;
        $direction = $new_direction;
    }

    return $count;
}

$map = parseData("input");
// printMap($map);
$result = traverseMap($map);
echo "\nResult: " . $result . "\n";
