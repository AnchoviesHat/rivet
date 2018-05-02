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
            ret=$rg0
            ;;
        r2)
            ret=$rg1
            ;;
        r3)
            ret=$rg2
            ;;
        r4)
            ret=$rg3
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
}

get_line()
{
    line_idx=$1
    file=$2

    cur_idx=0
    while read -r line
    do
        if test $cur_idx -eq $line_idx; then
            break
        fi

        cur_idx=$(($cur_idx + 1))
    done < $file
}

echo '


















' > mem

prog_size=$(($(wc -l < insts) + 1))

while test $pc -ne $prog_size;
do
    get_line $(($pc - 1)) insts; inst=$line

    IFS=' '
    set -- $inst
    op=$1
    reg_1=$2
    reg_2=$3
    imm=$3
    reg_3=$4
    jump_pos=$4

    case $op in
        add)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            set_register $reg_3 $(($a + $b))
            # get_register $reg_3; v=$ret
            # echo $a + $b = $v
            ;;
        sub)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            set_register $reg_3 $(($a - $b))
            # get_register $reg_3; v=$ret
            # echo $a - $b = $v
            ;;
        mul)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            set_register $reg_3 $(($a * $b))
            # get_register $reg_3; v=$ret
            # echo $a \* $b = $v
            ;;
        div)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            set_register $reg_3 $(($a / $b))
            # get_register $reg_3; v=$ret
            # echo $a / $b = $v
            ;;
        seti)
            set_register $reg_1 $imm
            # echo $reg_1 = $imm
            ;;
        set)
            get_register $reg_2; a=$ret
            set_register $reg_1 $a
            # echo $reg_1 = $reg_2
            ;;
        load)
            sed "$imm"!d mem; v=$ret
            set_register $reg_1 $v
            # echo $reg_1 = \(mem\["$imm"\]: $v\)
            ;;
        store)
            get_register $reg_1; a=$ret
            sed -i '' "$imm"s/.*/$a/ mem
            # echo mem\["$imm"\] = \($reg_1: $a\)
            ;;
        jeq)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            # echo if $a == $b
            if test $a -eq $b; then
                pc=$(($jump_pos - 1))
                # echo jumping to $pc
            fi
            # echo not jumping
            ;;
        jneq)
            get_register $reg_1; a=$ret
            get_register $reg_2; b=$ret
            # echo if $a != $b
            if test $a -ne $b; then
                pc=$(($jump_pos - 1))
                # echo jumping to $pc
            fi
            # echo not jumping
            ;;
        out)
            get_register $reg_1; echo $ret
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
