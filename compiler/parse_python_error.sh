#!/bin/bash

# test.py:
# Traceback (most recent call last):
#   File "test.py", line 1, in <module>
#     print(1/0)
# ZeroDivisionError: division by zero
#   sed Nd: delete N-th line
# Somehow, when using this script/capturing the output via $(), newlines in the error message aren't printed, ie.
#   $ ./parse_python_error.sh test.py 
#   File "test.py", line 1, in <module> ZeroDivisionError: division by zero
# (so, $error_string corresponds to this one line, which is handy because parsing multi-line errors is pure pain in Vim.)
error_string=$(python3 $1 2>&1 | sed '1d;3d')

echo $error_string
