#!/bin/bash

for i in {1..240}; do
    Rscript collect_evol2016.R
    echo $i
done

