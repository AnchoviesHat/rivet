#!/bin/sh --posix

rg0=5
rg1=4
rg2=4

get_register()
{
    reg=$1

    case $reg in
        r1)
            echo $rg0
            return $rg0
            ;;
        r2)
            echo $rg1
            return $rg1
            ;;
        r3)
            echo $rg2
            return $rg2
            ;;
        *)
            return -1
            ;;
    esac
}

set_register()
{
    reg=$1
    value=$2

    case $reg in
        r1)
            rg0=$value
            ;;
        r2)
            rg1=$value
            ;;
        r3)
            rg2=$value
            ;;
        *)
            return -1
            ;;
    esac

    return 0
}

inst="sub r1 r2 r3"
IFS=' '
set -- $inst
op=$1
reg_1=$2
reg_2=$3
ret=$4

case $op in
    add)
        a=$(get_register $reg_1)
        b=$(get_register $reg_2)
        set_register $ret $(($a + $b))
        v=$(get_register $ret)
        echo $a + $b = $v
        ;;
    sub)
        a=$(get_register $reg_1)
        b=$(get_register $reg_2)
        set_register $ret $(($a - $b))
        v=$(get_register $ret)
        echo $a - $b = $v
        ;;
    *)
        echo invalid op $op
        ;;
esac
