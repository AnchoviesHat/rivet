#!/bin/sh --posix

pc=1
rg0=0
rg1=0
rg2=0

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
            echo Invalid register $1
            exit 1
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
            echo Invalid register $1
            exit 1
            ;;
    esac

    return 0
}

echo '


















' > mem

prog_size=$(wc -l < insts)

while [ $pc != $prog_size ];
do
    inst=$(sed -n "$pc"p insts)

    IFS=' '
    set -- $inst
    op=$1
    reg_1=$2
    reg_2=$3
    imm=$3
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
        mul)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a * $b))
            v=$(get_register $ret)
            echo $a \* $b = $v
            ;;
        div)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a / $b))
            v=$(get_register $ret)
            echo $a / $b = $v
            ;;
        set)
            set_register $reg_1 $imm
            echo $reg_1 = $imm
            ;;
        load)
            v=$(sed "$imm"!d mem)
            set_register $reg_1 $v
            echo $reg_1 = \(mem\["$imm"\]: $v\)
            ;;
        store)
            a=$(get_register $reg_1)
            sed -i '' "$imm"s/.*/$a/ mem
            echo mem\["$imm"\] = \($reg_1: $a\)
            ;;
        *)
            echo invalid op $op
            ;;
    esac

    pc=$(($pc + 1))
done

rm mem
