#!/bin/bash
read_property () {
    grep "^$2=" "$1" | cut -d'=' -f2;
}