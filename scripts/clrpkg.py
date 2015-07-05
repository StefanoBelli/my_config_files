#! /usr/bin/python2

from os import system

keyword = str(raw_input("Key: "))

system("sudo emerge -C $(qlist -ICv %s)" %keyword)

