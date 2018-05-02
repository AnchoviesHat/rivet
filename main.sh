#!/bin/sh --posix

pc=1
rg0=0
rg1=0
rg2=0
rg3=0

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
        r4)
            echo $rg3
            return $rg3
            ;;
        *)
            echo Invalid register $1
            rm mem
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
        r4)
            rg3=$value
            ;;
        *)
            echo Invalid register $1
            rm mem
            exit 1
            ;;
    esac

    return 0
}

get_line()
{
    line_idx=$1
    file=$2

    cur_idx=0
    while read -r line
    do
        if test $cur_idx -eq $line_idx; then
            echo $line
        fi

        cur_idx=$(($cur_idx + 1))
    done < $file
}

echo '


















' > mem

prog_size=$(($(wc -l < insts) + 1))

while test $pc -ne $prog_size;
do
    inst=$(get_line $(($pc - 1)) insts)

    IFS=' '
    set -- $inst
    op=$1
    reg_1=$2
    reg_2=$3
    imm=$3
    ret=$4
    jump_pos=$4

    case $op in
        add)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a + $b))
            v=$(get_register $ret)
            # echo $a + $b = $v
            ;;
        sub)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a - $b))
            v=$(get_register $ret)
            # echo $a - $b = $v
            ;;
        mul)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a * $b))
            v=$(get_register $ret)
            # echo $a \* $b = $v
            ;;
        div)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            set_register $ret $(($a / $b))
            v=$(get_register $ret)
            # echo $a / $b = $v
            ;;
        seti)
            set_register $reg_1 $imm
            # echo $reg_1 = $imm
            ;;
        set)
            a=$(get_register $reg_2)
            set_register $reg_1 $a
            # echo $reg_1 = $reg_2
            ;;
        load)
            v=$(sed "$imm"!d mem)
            set_register $reg_1 $v
            # echo $reg_1 = \(mem\["$imm"\]: $v\)
            ;;
        store)
            a=$(get_register $reg_1)
            sed -i '' "$imm"s/.*/$a/ mem
            # echo mem\["$imm"\] = \($reg_1: $a\)
            ;;
        jeq)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            # echo if $a == $b
            if test $a -eq $b; then
                pc=$(($jump_pos - 1))
                # echo jumping to $pc
            fi
            # echo not jumping
            ;;
        jneq)
            a=$(get_register $reg_1)
            b=$(get_register $reg_2)
            # echo if $a != $b
            if test $a -ne $b; then
                pc=$(($jump_pos - 1))
                # echo jumping to $pc
            fi
            # echo not jumping
            ;;
        out)
            echo $(get_register $reg_1)
            ;;
        *)
            echo invalid op $op
            rm mem
            exit 1
            ;;
    esac

    pc=$(($pc + 1))
done

rm mem
