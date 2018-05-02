# rivet
A POSIX sh vm interpreter thingy

This relies on sed and wc to do memory and line counting for the loaded instructions,  
but it'll do basic math, load and store values to a file, and echo to the terminal.

Counting down from 1000 -> 0

```
seti r1 1000
seti r2 1
seti r3 0
out r1
sub r1 r2 r1
jneq r1 r3 4
```

For best performance, ksh appears to be the way to go. I get roughly 0.8 seconds  
counting down from 1000 in sh, and 0.16 in ksh.
